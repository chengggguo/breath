import processing.serial.*;

Serial myPort;  // Create object from Serial class
int stateNow;      // current state
String capacity = null;  // lung capacity
int packets;


void setup() 
{
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
}

void serialEvent(Serial myPort) {
  if ( myPort.available() > 0) {  
    if (myPort.read()<10) {

      stateNow = myPort.read();
      if (stateNow == -1) {
        stateNow = 2;
      }
    } 

      switch(stateNow) {
      case 0:
        println("blowing");
        println(myPort.read());

        //if (myPort.readString() != null);
        //{
        //  capacity = myPort.readString();
        //  println(capacity);
        //  packets = Integer.parseInt(capacity);
        //  println(packets);
        //  delay(200);
        //}

        break;

      case 1:
        println("inhaling");
        break;
      case 2:
        println("Stand by");
        println(stateNow);
      }
    }
  delay(100);
}