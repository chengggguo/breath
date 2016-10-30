import processing.serial.*;
import processing.io.*;
import hypermedia.net.*;
import processing.serial.*;

//// udp set up
UDP udp;
String ip;
int port;
int numPackets;  // lung capacity recieved from arduino
boolean [] inPackets;
int w;                      // image size
int h;
boolean allDataArrived;
int startTime;
int timeout;
int ellapsedTime;
int step;
int pos;    // starting postion(pixel) of red/blue lines



////////////////////////// Serial communication set up
Serial myPort;  // Create object from Serial class
int stateNow;      // current state
String capacity = null;  // lung capacity
int packets;
int stateRun;
int inValue;
boolean blowing = false;


void setup() 
{
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.write("true");
  delay(100);

  size(800, 600);
  background(0);
  loadPixels();
  ip = "localhost"; 
  port = 10002;
  w = width;
  h = height;
  numPackets = 1000;
  step = w*h/numPackets;

  inPackets = new boolean[numPackets];
  allDataArrived = false;

  udp = new UDP( this, 10001);
  udp.listen(true);
  GPIO.pinMode(12, GPIO.OUTPUT);
  //frameRate(10);

  for (int i = 0; i < numPackets; i++) {  // assign blue to the background as defalut
    inPackets[i] = false;
  }
  startTime = millis();
  timeout = 3000;
}

void draw()
{
  timer();
  //valOn = !valOn;
  if (allDataArrived == true) {
    for (int i=0; i < numPackets; i++) {
      pos = i*step;      
      if (inPackets[i] == true) {
        for (int n = 0; n < step; n++) {          
          color red = color(46, 49, 146);
          pixels[n + pos] = red;
        }
      } else {
        for (int n = 0; n < step; n++) {          
          color blue = color(237, 28, 36);
          pixels[n + pos] = blue;
        }
      }
    }
    updatePixels();
    //valSwitch();
  }
}

void serialEvent(Serial myPort) {
  String message = myPort.readStringUntil(13);
  if (message != null) {
    float  value = float(message);
    inValue = int(value);
  }

  if (inValue == 0) {                 //blowing
    blowing = true;
    while (blowing) {             //hold until recieve the capacity
      if (inValue >3 ) {
        println(inValue);
        numPackets = inValue;
        for (int i=0; i < numPackets; i++) {  // send packets
          String info = str(i);
          info = info + ":\n";
          udp.send(info, ip, port);
        }
        myPort.write("true");                // turn on the analog sensor
        delay(100);
        blowing = false;
      }
    }

    println("blowing");
  } else if (inValue == 1) {

    println("inhaling");
    myPort.write("false");  // holding the arduino


    delay(5000);
    myPort.write("true");
    delay(100);
  } else if (inValue == 2) {

    println("stand by");
  } else {
    println("someing else");
  }
}

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
  println(inPackets.length);
  for (int i = 0; i < numPackets; i++) {
    if (inPackets[i] == true) {
      GPIO.digitalWrite(12, GPIO.HIGH);
      delay(100);
    } else {
      GPIO.digitalWrite(12, GPIO.LOW);
      delay(100);
    }
  }
  println("done");
}