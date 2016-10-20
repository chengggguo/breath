int sensor = A0;                       // Switch connected to pin 4

void setup() {
  pinMode(sensor, INPUT);             // Set pin 0 as an input
  Serial.begin(9600);                    // Start serial communication at 9600 bps
}

void loop() {
 while (true) {
    Serial.write(250);
    delay(1000);
 }

  //  if (analogRead(sensor) > 100) {  // If switch is ON,
  //    Serial.write(100);               // send 1 to Processing
  //  } else {                               // If the switch is not ON,
  //    Serial.write(0);               // send 0 to Processing
  //  }
//  delay(1000);                            // Wait 100 milliseconds
}
