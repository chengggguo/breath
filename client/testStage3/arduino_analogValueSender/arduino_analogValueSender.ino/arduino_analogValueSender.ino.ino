int sensor = A0;  // Switch connected to pin 4
int mValue; // mapped value
boolean check = true;
boolean case2;
boolean i;


void setup() {
  pinMode(sensor, INPUT);             // Set pin 0 as an input
  Serial.begin(9600);                    // Start serial communication at 9600 bps
}

void loop() {
  if (check = true) {
    if (analogRead(sensor) >= 110) {
      Serial.write(0);
      delay(100);
      check = false;
    } else if (analogRead(sensor)<110 and analogRead(sensor) >= 100) {
      Serial.write(1);
      delay(100);
    } else {
      Serial.write(2);
      delay(100);
    }
  }
  
  if (analogRead(sensor) < 110) {
    check = true;
  } else {
    mValue = int(map(analogRead(sensor), 100, 900, 10, 255));
    Serial.write(mValue);
    delay(100);
  }
}




