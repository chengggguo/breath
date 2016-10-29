import processing.serial.*;

Serial myPort;  // Create object from Serial class
int stateNow;      // current state
String capacity = null;  // lung capacity
int packets;
int stateRun;
int inValue;


void setup() 
{
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.write("true");
}

void draw()
{
}

void serialEvent(Serial myPort) {
  String message = myPort.readStringUntil(13);
  if (message != null) {
    float  value = float(message);
    inValue = int(value);
  }

  if (inValue == 0) {

    println("blowing");
  } else if (inValue == 1) {

    println("inhaling");
    myPort.write("false");
    delay(5000);
    myPort.write("true");
    delay(100);
  } else if (inValue == 2) {

    println("stand by");
  } else {
    println(inValue);
  }
}