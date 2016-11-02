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
long blowStart;
long blowEnd;
long interval = 0;
int maxSpeed = 0;
int initPackets=0;
int lostPackets = 0;
float sensorCSA = 0.785; // the cross-sectional area of air pressure sensor
boolean init;
/////~

/////udp and draw() setup
UDP udp;
String ip;
int port;
boolean [] inPackets;
int w;                      // image size
int h;
boolean allSent;
boolean allDataArrived;
int startTime;
int timeout;
int ellapsedTime;
int step;
int pos;    // starting postion(pixel) of red/blue lines
/////~


void setup() {
  /////MCP3008 adc
  adc = new MCP3008(SPI.list()[0]); 
  adc.settings(1000000, SPI.MSBFIRST, SPI.MODE0); // 1MHz should be OK...
  /////~

  ///// -red/blue dataVis
  size(800, 600);
  background(237, 28, 36);
  loadPixels();
  port = 10002;
  w = width;
  h = height;
  init = true;
  /////~

  /////udp
  ip = "localhost"; 
  //inPackets = new boolean[initPackets];
  allDataArrived = false;
  allSent = false;
  udp = new UDP( this, 10001);
  udp.listen(true);
  //startTime = millis();
  timeout = 3000;
  /////~

  /////GPIO -valve switch
  GPIO.pinMode(12, GPIO.OUTPUT);
  //frameRate(10);
  /////~
}
void draw() {
  if (runState) {
    rawData = adc.getAnalog(0);
    sensorData = int(rawData * 100);
    //println(sensorData);
    if (sensorData > 75) {
      state = "blow";
      runState = false;
      blowStart = millis();
    } else if (sensorData < 68) {
      println(sensorData);
      state = "inhale";
      runState = false;
    } else {
      state = "standby";
    }
    println(state);
  }

  ///////// get the lung capacity 
  if (state == "blow") {
    rawData = adc.getAnalog(0);
    sensorData = int(rawData * 100);
    if (sensorData < 75) {
      interval = blowEnd - blowStart;
      //      Serial.print(interval);
      initPackets = int((interval * maxSpeed * sensorCSA)/100);
      println(initPackets);
      delay(1000);
      inPackets = new boolean[initPackets];
      startTime = millis();
      for (int i = 0; i < initPackets; i++) {  // assign blue to the background as defalut
        inPackets[i] = false;
      }
      for (int i = 0; i < initPackets; i++) { 
        String message = str(i);
        message = message + ":\n";
        udp.send(message, ip, port);
      }

      println("packets sent");
      state = "standby";
      runState = true;
      allSent = true;
    } else {
      blowEnd = millis();
      if (sensorData > maxSpeed) {
        maxSpeed = sensorData;
        delay(10);
      }
    }
  }
  if (init== true) {
    if (allSent == true) {
      println("draw");
      delay(1000);
      timer();
      if (allDataArrived == true) {
        println("allArrived");
        if (initPackets != 0) {
          step = w*h/initPackets;
          for (int i=0; i < initPackets; i++) {
            pos = i*step;      
            if (inPackets[i] == true) {
              for (int n = 0; n < step; n++) {          
                color red = color(237, 28, 36);
                pixels[n + pos] = red;
              }
              lostPackets= lostPackets+1;
            } else {
              for (int n = 0; n < step; n++) {          
                color blue = color(46, 49, 146);
                pixels[n + pos] = blue;
              }
              //lostPackets= lostPackets+1;
            }
          }

          updatePixels();
          println("updated");
          init = false;
          println(lostPackets);
          delay(1000);
        }
        //println(lostPackets);
        //allDataArrived = false;
        delay(800);
      }
      //allSent = false;
    }
  }

  if (state == "inhale") {
    valSwitch();
    runState = true;
    state = "standby";
  }
  if (state == "standby") {
    println(sensorData);
  }
}



///////////for MCP3008
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
///////////////

void timer() {
  ellapsedTime = millis() - startTime;
  if (ellapsedTime > timeout) {
    allDataArrived = true;
  }
}

void receive(byte[] data, String ip, int port) {
  data = subset(data, 0, data.length - 2);
  String info = new String(data);
  int index = int(info);
  inPackets[index] = true;
}

void valSwitch() {
  //println(inPackets.length);
  for (int i = 0; i < initPackets; i++) {
    if (inPackets[i] == true) {
      GPIO.digitalWrite(12, GPIO.HIGH);
      delay(50);
    } else {
      GPIO.digitalWrite(12, GPIO.LOW);
      delay(50);
    }
  }
  println("done");
  state = "standby";
}