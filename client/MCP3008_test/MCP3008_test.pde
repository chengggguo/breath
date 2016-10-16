import processing.io.*;
MCP3008 adc;

// see setup.png in the sketch folder for wiring details

float sec = 0.0005*0.0005 * 3.1415926; // volume of air
float speed=0;
int t = 100;


// fliter
float alpha = 0.1;
float smoothed = 0;
float rawValue;
float mappedValue;

void setup() {
  printArray(SPI.list());
  adc = new MCP3008(SPI.list()[0]);
  adc.settings(500000, SPI.MSBFIRST, SPI.MODE0);
}

void draw() {
  //for (int i = 0; i<8; i++){
  //  println("result" + i +" " + adc.getAnalog(i));
  //}

  //println(sec * adc.getAnalog(1) * t);
  rawValue = adc.getAnalog(1)*255;
  //mappedValue = map(rawValue, 0, 130, 0, 255);
  //Smooth(mappedValue);
  Smooth(rawValue);
  println("smoothed "+ smoothed);
  
  println("raw " + rawValue);
  println("#########");
  delay(1000);

  //background(adc.getAnalog(1) * 255);
  //fill(adc.getAnalog(1) * 255);
  //ellipse(width/2, height/2, width * 0.75, width * 0.75);
}

void Smooth(float rawValue) {
  //if (rawValue > smoothed) {
  //  smoothed = smoothed + (rawValue - smoothed)*alpha;
  //} else {
  //  smoothed = smoothed - (smoothed - rawValue)*alpha;
  //}
  
  smoothed = alpha * rawValue + (1-alpha)*smoothed;
}