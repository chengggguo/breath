import processing.serial.*;
import processing.io.*;
import hypermedia.net.*;
import processing.serial.*;

/////MCP3008 ADC and air pruessure sensor setup
SPI MCP;
MCP3008 adc;
float rawData;

int sensorData = 0;
String state = null;
boolean runState=true;
boolean blowing = false;
long timeStart;
long timeEnd;
long interval = 0;
int maxSpeed = 0;
int numPackets=0;
float sensorCSA = 0.785; // the cross-sectional area of air pressure sensor
/////

/////udp and draw() setup
UDP udp;
String ip;
int port;
boolean [] inPackets;
int w;                      // image size
int h;
boolean allDataArrived;
int startTime;
int timeout;
int ellapsedTime;
int step;
int pos;    // starting postion(pixel) of red/blue lines
/////


void setup() {
  // printArray(SPI.list()); // to check SPI enabled - should give [0] "spidev0.0", [1] "spidev0.1"
  adc = new MCP3008(SPI.list()[0]); // raspberry pi has 2 SPI interfaces, SPI.list()[1] is the other
  adc.settings(1000000, SPI.MSBFIRST, SPI.MODE0); // 1MHz should be OK...
}
void draw() {
  if (runState) {
    rawData = adc.getAnalog(0);
    sensorData = int(rawData * 100);
    println(sensorData);

    if (sensorData > 75) {
      state = "blow";
      runState = false;
      timeStart = millis();
    } else if (sensorData < 69) {
      state = "inhale";
    } else {
      state = "standby";
    }
    println(state);
    delay(100);
  }
  ///////// get the lung capacity(number of packets will be sent) -start
  if (state == "blow") {
    rawData = adc.getAnalog(0);
    sensorData = int(rawData * 100);
    if (sensorData < 75) {
      interval = timeEnd - timeStart;
      //      Serial.print(interval);
      numPackets = int((interval * maxSpeed * sensorCSA)/10);
      println(numPackets);
      delay(1000);
      state = "standby";
      runState = true;
    } else {
      timeEnd = millis();
      if (sensorData > maxSpeed) {
        maxSpeed = sensorData;
        delay(10);
      }
    }
  }
  ///////// get the lung capacity(number of packets will be sent) -end
  
  if(state == "inhale"){
    
    
  }
}



///////////for MCP3008(begin)
class MCP3008 extends SPI {
  MCP3008(String dev) {
    super(dev);
    super.settings(500000, SPI.MSBFIRST, SPI.MODE0);
  }
  float getAnalog(int channel) {
    if (channel < 0 ||  channel > 3) {
      System.err.println("The channel needs to be from 0 to 3");
      throw new IllegalArgumentException("Unexpected channel");
    }
    byte[] out = { 0, 0, 0 };
    // encode the channel number in the first byte
    out[0] = (byte)(0x18 | channel);
    byte[] in = super.transfer(out);
    int val = ((in[1] & 0x3f)<< 4 ) | ((in[2] & 0xf0) >> 4);// val is between 0 and 1023
    return float(val)/1023.0;
  }
}
int returnADC(int ch) {
  byte[] out = {1, byte((8 + ch) << 4), 0}; // outgoing bytes to the MCP
  byte[] in = MCP.transfer(out); // sends & returns
  int highInt = in[1] & 0xFF; // processing sees bytes as signed (-128 to 127) which is not what we want here
  int lowInt = in[2] & 0xFF; // doing this converts to unsigned ints (0 to 255)
  // here's why http://stackoverflow.com/questions/4266756/can-we-make-unsigned-byte-in-java
  int result = ((highInt & 3) << 8) + lowInt; // adds lowest 2 bits of 2nd byte to 3rd byte to get 10 bit result 
  return result;
}
///////////////for MCP3008(end)