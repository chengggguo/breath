import processing.serial.*;
import processing.io.*;
import hypermedia.net.*;
import processing.serial.*;

Serial myPort;            //Serial communication for sending number to arduino

JSONObject json;          //create a json object to store the total number of lost Packets
String temLost;
String totalLost;
String converted = "";
int first;
int second;

/////MCP3008 ADC and air pruessure sensor setup
SPI MCP;
MCP3008 adc;
float rawData;
boolean packetsSent =false;

int sensorData = 0;
String state = null;
boolean runState=true;
boolean blowing = false;
boolean initInhale = false;
long blowStart;
long blowEnd;
long interval = 0;
int maxSpeed = 0;
int minSpeed = 0;
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
int sent = 0;
int receive = 0;
int valState=4;
int breathState=23;
int ledOn =13;
int breathingState=26;

void setup() {
  /////MCP3008 adc
  adc = new MCP3008(SPI.list()[0]); 
  adc.settings(100000, SPI.MSBFIRST, SPI.MODE0); // 1MHz should be OK...
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



  GPIO.pinMode(valState, GPIO.OUTPUT);              //GPIO -valve inhale
  GPIO.pinMode(breathState, GPIO.OUTPUT);              // GPIO -valve state(exhale/inhale)
  GPIO.pinMode(ledOn, GPIO.OUTPUT);
  GPIO.pinMode(breathingState, GPIO.OUTPUT);
  //frameRate(10);

  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  json = loadJSONObject("new.json");
  totalLost = json.getString("lost");
}

//////////////////////////////////////////// main loop
void draw() {
  if (runState) {
    rawData = adc.getAnalog(0);
    sensorData = int(rawData * 100);
    //println(sensorData);
    if (sensorData > 81) {
      state = "blow";
      //delay(400);
      maxSpeed = sensorData;
      println("key1: " + maxSpeed);
      runState = false;
      blowing = true;
      if (init) {
        blowStart = millis();
      }
      GPIO.digitalWrite(breathState, GPIO.HIGH);        //exhale
    } else if (sensorData < 71) {
      println(sensorData);
      state = "inhale";
      if (init) {
        blowStart = millis();
      }
      runState = false;
      GPIO.digitalWrite(breathState, GPIO.LOW);      //inhale
    } else {
      state = "standby";
      GPIO.digitalWrite(breathState, GPIO.LOW);      //stand by -GPIO 12 LOW
      packetsSent = false;
    }
    println(state);
  }


  if (state == "blow") {                        // get the lung capacity and send packets
    if (initInhale) {
      rawData = adc.getAnalog(0);
      sensorData = int(rawData * 100);
      if (sensorData <78) {
        state = "standby";
        runState = true;
        initInhale = false;
      }
    } else {
      rawData = adc.getAnalog(0);
      sensorData = int(rawData * 100);
      if (sensorData <78) {
        state = "standby";
        runState = true;
      }
    }
  }

  if (state == "inhale") {                      //drive valves
    if (init) {
      rawData = adc.getAnalog(0);
      sensorData = int(rawData * 100);
      for (int i = 0; i<5; i++) {
        if (minSpeed < sensorData) {
          minSpeed = sensorData;
        }
      }
      println("key2: " + sensorData);
      blowEnd = millis();
      println("timeStart: " + blowStart);
      println("timeEnd: " + blowEnd);
      if (sensorData > minSpeed) {
        minSpeed = sensorData;
      }
      println(sensorData + "/" + maxSpeed);
      if (sensorData > 72 ) {
        println("b: " + sensorData);
        interval = blowEnd - blowStart;
        maxSpeed = 150 - minSpeed;
        println(interval * maxSpeed * sensorCSA);
        initPackets = int((interval * maxSpeed * sensorCSA)/200) + 1;
        println("packets" + initPackets);
        println("time: " + interval);
        //delay(1000);
        //initPackets=1000; /////////////////////////////////////
        inPackets = new boolean[initPackets];
        for (int i = 0; i < initPackets; i++) {  // assign red to the background as defalut
          inPackets[i] = true;
        }

        sendPackets();
        initInhale = true; ///  starts with inhaling
        state = "standby";
        runState = true;
        GPIO.digitalWrite(breathState, GPIO.LOW);      //stand by -GPIO 12 LOW
      }
    } else {
      if (!initInhale) {
        valSwitch();
        runState = true;
        state = "standby";
        sendPackets();
      } else {
        rawData = adc.getAnalog(0);
        sensorData = int(rawData * 100);
        if (sensorData >70) {
          state = "standby";
          runState = true;
        }
      }
    }
  }
    if (state == "standby") {                    //do nothing
      println(sensorData);
    }


    if (allSent == true) {                      //update pixels
      if (init) {
        step = w*h/initPackets;
        init =false;
      }
      pixelUpdate();
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

  void timer() {           // timeout for udp communication
    ellapsedTime = millis() - startTime;
    if (ellapsedTime > timeout) {
      allDataArrived = true;

      println("receive: " + receive);
      receive = 0;
    }
  }

  void sendPackets() {
    startTime = millis();
    //if (!initInhale) {
    //  //udp.listen(true);
    //  for (int i = 0; i <  initPackets; i++) { 
    //    if (inPackets[i] == true) {
    //      inPackets[i] = false;
    //      String message = str(i);
    //      message = message + ":\n";
    //      udp.send(message, ip, port);
    //      sent=sent+1;
    //    }
    //  }
    //}
    //initInhale = false;
    for (int i = 0; i <  initPackets; i++) { 
      if (inPackets[i] == true) {
        inPackets[i] = false;
        String message = str(i);
        message = message + ":\n";
        udp.send(message, ip, port);
        sent=sent+1;
      }
    }
    println("sent: " +sent);
    sent = 0;
    allSent = true;
    packetsSent = true;
    println("packets sent");
  }

  void receive(byte[] data, String ip, int port) {    
    data = subset(data, 0, data.length - 2);
    String info = new String(data);
    int index = int(info);
    inPackets[index] = true;
    if (inPackets[index] == true) {
      receive = receive +1;
    }
  }



  void pixelUpdate() {        //red/blue dataVis
    //println("draw");
    //delay(1000);
    timer();

    if (allDataArrived == true) {
      //udp.listen(false);
      println("allArrived");
      if (initPackets != 0) {
        println("xxx");

        for (int i=0; i < initPackets; i++) {  ////////////////// i=0
          pos = i*step;      
          if (inPackets[i] == false) {
            for (int n = 0; n < step; n++) {          
              color blue = color(46, 49, 146);
              pixels[n + pos] = blue;
            }
            lostPackets= lostPackets+1;
          } else {
            for (int n = 0; n < step; n++) {          
              color red = color(237, 28, 36);
              pixels[n + pos] = red;
            }
          }
        }
        //print(inPackets);
        updatePixels();
        println("updated");
        println("lost: " + lostPackets);
        println("all: " +initPackets);

        long n = Integer.parseInt(totalLost)+lostPackets;
        println(totalLost);
        println(n);
        temLost = Long.toString(n);
        //println("longstring" + temLost);
        ledPrint(temLost);

        //println(temLost);

        lostPackets = 0;
        delay(3000);
      }
      allSent = false;
      allDataArrived = false;
    }
  }


  void valSwitch() {
    //println(inPackets.length);
    for (int i = 0; i < initPackets; i++) {
      if (inPackets[i] == true) {
        GPIO.digitalWrite(valState, GPIO.HIGH);
        GPIO.digitalWrite(ledOn, GPIO.HIGH);
        delay(50);
        GPIO.digitalWrite(ledOn, GPIO.LOW);
      } else {
        GPIO.digitalWrite(valState, GPIO.LOW);
        delay(50);
      }
    }
    println("done");
    state = "standby";
    allDataArrived = false;
  }

  void keyPressed() {
    background(237, 28, 36);
    loadPixels();
    init = true;
    json.setString("lost", temLost);
    //json = new JSONObject();
    saveJSONObject(json, "data/new.json");
    delay(50);
    json = loadJSONObject("new.json");
    totalLost = json.getString("lost");
    println(totalLost);
  }

  void ledPrint(String num) {
    String converted = "";
    String numPrint1 = "";
    String numPrint2 = "";
    String numPrint3 = "";
    String numPrint4 = "";
    String numPrint5 = "";
    String numPrint6 = "";
    String numPrint7 = "";
    String numPrint8 = "";
    String numPrint9 = "";
    String numPrint10 = "";
    String numPrint11= "";
    String numPrint12 = "";
    String numPrint13 = "";
    String numPrint14 = "";
    String numPrint15 = "";
    String numPrint16= "";
    String c = num; 
    //println("input: " + c);
    int n = c.length();
    //println("length: " + n);
    char [] bit = new char[16];
    char[] n1 = new char[1];
    char[] n2 = new char[2];
    char[] n3 = new char[3];
    char[] n4 = new char[4];
    char[] n5 = new char[5];
    char[] n6 = new char[6];
    char[] n7 = new char[7];
    char[] n8 = new char[8];
    char[] n9 = new char[9];
    char[] n10 = new char[10];
    char[] n11= new char[11];
    char[] n12 = new char[12];
    char[] n13 = new char[13];
    char[] n14 = new char[14];
    char[] n15= new char[15];
    char[] n16 = new char[16];


    for (int i=0; i<n; i++) {
      bit[i] = c.charAt(i);
    }

    for (int i=(n-1); i>-1; i--) {
      converted += bit[i];
    }
    for (int o=0; o<(16-n); o++) {
      converted += 0;
    }

    for (int p =0; p<1; p++) {
      n1[p]=converted.charAt(p);
      numPrint1 +=n1[p];
    }

    for (int p =1; p<2; p++) {
      n2[p]=converted.charAt(p);
      numPrint2 +=n2[p];
    }

    for (int p =2; p<3; p++) {
      n3[p]=converted.charAt(p);
      numPrint3 +=n3[p];
    }
    for (int p =3; p<4; p++) {
      n4[p]=converted.charAt(p);
      numPrint4 +=n4[p];
    }

    for (int p =4; p<5; p++) {
      n5[p]=converted.charAt(p);
      numPrint5 +=n5[p];
    }

    for (int p =5; p<6; p++) {
      n6[p]=converted.charAt(p);
      numPrint6 +=n6[p];
    }
    for (int p =6; p<7; p++) {
      n7[p]=converted.charAt(p);
      numPrint7 +=n7[p];
    }

    for (int p =7; p<8; p++) {
      n8[p]=converted.charAt(p);
      numPrint8 +=n8[p];
    }

    for (int p =8; p<9; p++) {
      n9[p]=converted.charAt(p);
      numPrint9 +=n9[p];
    }
    for (int p =9; p<10; p++) {
      n10[p]=converted.charAt(p);
      numPrint10 +=n10[p];
    }

    for (int p =10; p<11; p++) {
      n11[p]=converted.charAt(p);
      numPrint11 +=n11[p];
    }

    for (int p =11; p<12; p++) {
      n12[p]=converted.charAt(p);
      numPrint12 +=n12[p];
    }
    for (int p =12; p<13; p++) {
      n13[p]=converted.charAt(p);
      numPrint13 +=n13[p];
    }
    for (int p =13; p<14; p++) {
      n14[p]=converted.charAt(p);
      numPrint14 +=n14[p];
    }

    for (int p =14; p<15; p++) {
      n15[p]=converted.charAt(p);
      numPrint15 +=n15[p];
    }

    for (int p =15; p<16; p++) {
      n16[p]=converted.charAt(p);
      numPrint16 +=n16[p];
    }
    //println(converted);
    myPort.write(int(numPrint1));
    delay(5);
    myPort.write(int(numPrint2));
    delay(5);
    myPort.write(int(numPrint3));
    delay(5);
    myPort.write(int(numPrint4));
    delay(5);
    myPort.write(int(numPrint5));
    delay(5);
    myPort.write(int(numPrint6));
    delay(5);
    myPort.write(int(numPrint7));
    delay(5);
    myPort.write(int(numPrint8));
    delay(5);
    myPort.write(int(numPrint9));
    delay(5);
    myPort.write(int(numPrint10));
    delay(5);
    myPort.write(int(numPrint11));
    delay(5);
    myPort.write(int(numPrint12));
    delay(5);
    myPort.write(int(numPrint13));
    delay(5);
    myPort.write(int(numPrint14));
    delay(5);
    myPort.write(int(numPrint15));
    delay(5);
    myPort.write(int(numPrint16));
    delay(5);
  }