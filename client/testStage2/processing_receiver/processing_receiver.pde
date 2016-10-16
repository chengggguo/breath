
import processing.serial.*;
import vsync.*;

//  We create a new ValueReceiver to receive values from the arduino
ValueReceiver receiver;
//  This is the variable we want to sync from the Arduino to this sketch
public int analogValue;

// fliter
float alpha = 0.5; // weighe of fliter(smoothing)
float smoothed = 0;
float rawValue;
float mappedValue;

//timer
int time;

//array for average wind speed
float[] speed = new float[100];


void setup() 
{
  //size(400, 400);
  Serial serial = new Serial(this, "/dev/ttyACM0", 19200);

  receiver = new ValueReceiver(this, serial);
  receiver.observe("analogValue");
}

void draw() 
{
  Smooth(mappedValue);
  int i = 0;
  time = millis();
  while (smoothed >= 8.5) {
    if ((millis()-time)>1000) {
      speed[i] = smoothed;
      i = i+1;
    }
  }
  print(speed);
  //println("smoothed "+ smoothed);
  //println("raw " + mappedValue);
  //println("######");
  //delay(500);
}

void Smooth(float rawValue) {
  smoothed = alpha * rawValue + (1-alpha)*smoothed;
  mappedValue = map(analogValue, 70, 1000, 0, 255);
}