import processing.io.*;
import hypermedia.net.*;

UDP udp;
String ip;
int port;
int numberOfPackets;
boolean [] inPackets;
int w;
int h;
boolean allDataArrived;

int startTime;
int timeout;
int ellapsedTime;
int step;
int pos;

boolean valOn = false;


void  setup() {
  size(800, 600);
  background(0);
  loadPixels();
  ip = "localhost"; // 45.33.74.32 remote server of fito, can be replaced by "localserver"
  port = 10002;
  w = width;
  h = height;
  numberOfPackets = 1000;
  step = w*h/numberOfPackets;

  inPackets = new boolean[numberOfPackets];
  allDataArrived = false;

  udp = new UDP( this, 10001);
  udp.listen(true);
  GPIO.pinMode(12, GPIO.OUTPUT);
  //frameRate(10);

  for (int i = 0; i < numberOfPackets; i++) {
    inPackets[i] = false;
  }


  startTime = millis();
  timeout = 3000;
}

void draw() {
  timer();
  valOn = !valOn;
  if (allDataArrived == true) {
    for (int i=0; i < numberOfPackets; i++) {
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

void keyPressed() {
  if (key == ' ') {
    for (int i=0; i < numberOfPackets; i++) {
      String message = str(i);
      message = message + ":\n";
      udp.send(message, ip, port);
    }
  }

  if (key == '1') {
    valSwitch();
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
  String message = new String(data);
  int index = int(message);
  inPackets[index] = true;
}

void valSwitch() {
  println(inPackets.length);
  for (int i = 400; i < numberOfPackets; i++) {
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