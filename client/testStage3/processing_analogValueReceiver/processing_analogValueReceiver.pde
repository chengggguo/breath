import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int MaxS = 0;

void setup() 
{
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();
    //if (val == 0) {
    //  println("get0");
    //} else if (val == 1) {
    //  println("get1");
    //}
    switch(val) {
    case 0:
      while (true) {
        val = myPort.read();
        if (val > MaxS) {
          MaxS = val;
        }
        break;
      }

    case 1:
      println("Stand by");
      MaxS = 0;
      break;
    case 2:
      println("inhaling");
    }
    println("dataNow "+ val);
    println("Max " +MaxS);
    delay(1000);
  }
  //background(255);             // Set background to white
  //if (val == 0) {              // If the serial value is 0,
  //  fill(0);                   // set fill to black
  //} 
  //else {                       // If the serial value is not 0,
  //  fill(204);                 // set fill to light gray
  //}
  //rect(50, 50, 100, 100);
}