
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
float[] speed = new float[10];
boolean counting = true;
boolean wormup = true;


void setup() 
{
  //size(400, 400);
  Serial serial = new Serial(this, "/dev/ttyACM0", 19200);

  receiver = new ValueReceiver(this, serial);
  receiver.observe("analogValue");
}

void draw() {
  while (wormup) {
    for (int i = 0; i <5; i++) {
      Smooth(analogValue);
      println(mappedValue);
      delay(500);
    }
    wormup = false;
    println("wormup done");
  }

  int i = 0;

  time = millis();
  while (counting) {
    Smooth(analogValue);
    if (mappedValue>8.5) {
      if ((millis()-time)> 2000) {
        speed[i] = smoothed;
        time = millis();
        println(i +": " + speed[i]);
        if (i<9) {
          i = i+1;
        } else {
          counting = false;
        }
      }
    } else {
      counting = false;
    }
  }
  //Smooth(analogValue);
  //println(mappedValue);
  println("done");
  delay(1000);

  //print(speed);
  //println("smoothed "+ smoothed);
  //println("raw " + mappedValue);
  //println("######");
  //delay(500);
}

void Smooth(float rawValue) {
  smoothed = alpha * rawValue + (1-alpha)*smoothed;
  mappedValue = map(smoothed, 70, 1000, 0, 255);
}