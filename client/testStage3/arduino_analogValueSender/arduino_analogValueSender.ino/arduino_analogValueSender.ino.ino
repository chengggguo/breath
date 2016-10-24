int sensor = A0;
float sensorCSA = 0.785; // the cross-sectional area of air pressure sensor

int mValue; // mapped value
boolean check = true; // state check(blowing, inhaling, stand by)
boolean countingBlow = false;
unsigned long timeStart;
unsigned long timeEnd;
int interval = 0;
int maxSpeed = 0;
int capacity = 0;



void setup() {
  pinMode(sensor, INPUT);             // Set pin 0 as an input
  Serial.begin(9600);                    // Start serial communication at 9600 bps
}

void loop() {
  if (check = true) {
    stateMachine(analogRead(sensor));

  }
  if (countingBlow == true) {
    if (analogRead(sensor) < 110) {

      interval = timeEnd - timeStart;
      capacity = int(interval * maxSpeed * sensorCSA);
      Serial.println("time " + interval);
      Serial.print("capacity ");
      Serial.println(capacity);
      //      Serial.write(capacity);
      delay(1000);

      check = true;
      countingBlow = false;


    } else {
      timeEnd = millis();
      if (analogRead(sensor) > maxSpeed) {
        maxSpeed = analogRead(sensor);
      }
    }
  }
  delay(500);
}

void stateMachine(int i) {
  if (i >= 115) {
    Serial.println("Blowing");
    Serial.println(i);
    //      Serial.write(0);
    countingBlow = true;
    timeStart = millis();
    check = false;
    delay(200);
  } else if (i < 99) {
    Serial.println("inhaling");
    Serial.println(i);
    //     Serial.write(1);
    delay(100);
  } else {
    Serial.println("stand by");
    Serial.println(i);
    //      Serial.write(2);
    delay(100);
  }


}


