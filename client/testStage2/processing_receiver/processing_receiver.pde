
import processing.serial.*;
import vsync.*;

//  We create a new ValueReceiver to receive values from the arduino
ValueReceiver receiver;
//  This is the variable we want to sync from the Arduino to this sketch
public int analogValue;

// fliter
float alpha = 0.5;
float smoothed = 0;
float rawValue;
float mappedValue;

void setup() 
{
  //size(400, 400);
  Serial serial = new Serial(this, "/dev/ttyACM0", 19200);

  receiver = new ValueReceiver(this, serial);
  receiver.observe("analogValue");
}

void draw() 
{
  mappedValue = map(analogValue, 95, 1000, 0, 255);
  //  Draw the background using the variable that was synced from the Arduino to this sketch
  background(mappedValue);

  Smooth(mappedValue);
  println("smoothed "+ smoothed);
  println("raw " + mappedValue);
  println("######");
  delay(500);
}

void Smooth(float rawValue) {
  smoothed = alpha * rawValue + (1-alpha)*smoothed;
}