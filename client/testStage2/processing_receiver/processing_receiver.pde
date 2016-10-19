
import processing.serial.*;
import vsync.*;

//  We create a new ValueReceiver to receive values from the arduino
ValueReceiver receiver;
//  This is the variable we want to sync from the Arduino to this sketch
public int analogValue;

// fliter
float alpha = 0.6;// weighe of fliter(smoothing)
float smoothed = 0;
float rawValue;
float mappedValue;
float bValue;

//timer
int time;

//array for average wind speed
float[] speed = new float[10];
boolean counting = true;
boolean wormup = true;

int i = 0;
  int num;

void setup() 
{
  //size(400, 400);
  Serial serial = new Serial(this, "/dev/ttyACM0", 19200);

  receiver = new ValueReceiver(this, serial);
  receiver.observe("analogValue");
  size(400, 400);
}

void draw() {
  background(analogValue/4);
  if(analogValue>100){
    num = 0;
  }else{
    num = 1;
  }

  switch(num) {
    case 0:
    if ((millis()-time)> 1000) {
      println("analogValue");
      println(analogValue);
      delay(10);
      if (analogValue>100) {
        println(smoothed);
        speed[i] = analogValue;
        time = millis();
        //println(i +": " + speed[i]);
        if (i<9) {
          println("done" + i);
          i = i+1;
        } else {
          counting = false;
        }
      } else {
        counting = false;
      }
    }
  }
  //Smooth(analogValue);
  //println("mappedValue");
  //println(mappedValue);
  //delay(10);
}




//while (counting) {
//  while (wormup) {
//    for (int n = 0; n <10; n++) {
//      Smooth(analogValue);
//      println(mappedValue);
//      delay(500);
//    }
//    wormup = false;
//    println("wormup done");
//  }
//  println("raw" + analogValue);
//  println("mapped" + mappedValue);
//  delay(100);
//  if ((millis()-time)> 1000) {
//    Smooth(analogValue);
//    println("mappedValue");
//    println(mappedValue);
//    delay(10);
//    if (mappedValue>8.3) {
//      println(smoothed);
//      speed[i] = smoothed;
//      time = millis();
//      //println(i +": " + speed[i]);
//      if (i<9) {
//        println("done" + i);
//        i = i+1;
//      } else {
//        counting = false;
//      }
//    } else {
//      counting = false;
//    }
//  }
//  Smooth(analogValue);
//  println("mappedValue");
//  println(mappedValue);
//  delay(10);
//}
//Smooth(analogValue);
//println(mappedValue);
//println("done");
//delay(1000);

void Smooth(float rawValue) {
  smoothed = alpha * rawValue + (1-alpha)*smoothed;
  mappedValue = map(smoothed, 70, 1000, 0, 255);
  delay(500);
}

void keyPressed() {
  if (key == ' ') {
    println("pressed");
    time = millis();
    while (counting) {
      if (analogValue>i) {
        println("analogValue");
        println(analogValue);
        delay(10);
        i = analogValue;
      } else if (i<100) {
        counting = false;
      }
    }
  }
}     