int sensor = A0;  // Switch connected to pin 4
int mValue; // mapped value


void setup() {
  pinMode(sensor, INPUT);             // Set pin 0 as an input
  Serial.begin(9600);                    // Start serial communication at 9600 bps
}

void loop() {
    if (analogRead(sensor) > 100) {  
      mValue = int(map(analogRead(sensor),100,900,10,255));
      Serial.write(mValue);               // send data to Processing
    } else {                              
//      Serial.write(0);              
    }
  delay(1000);                            
}
