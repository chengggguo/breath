int sensor = A0;
float sensorCSA = 0.785; // the cross-sectional area of air pressure sensor

int mValue; // mapped value
boolean check = true; // state check(blowing, inhaling, stand by)
boolean countingBlow = false;
unsigned long timeStart;
unsigned long timeEnd;
unsigned long interval;
int maxSpeed = 0;
int capacity;



void setup() {
  pinMode(sensor, INPUT);             // Set pin 0 as an input
  Serial.begin(9600);                    // Start serial communication at 9600 bps
}

void loop() {
  Serial.println("raw " + analogRead(sensor));
  if (check = true) {
    if (analogRead(sensor) >= 110) {
      Serial.println("Blowing");
      //      Serial.write(0);  // blowing
      countingBlow = true;
      timeStart = millis();
      check = false;
      delay(200);
    } else if (analogRead(sensor)<110 and analogRead(sensor) >= 100) {
      Serial.println("stand by");
      //      Serial.write(1); // stand by
      delay(100);
    } else {
      Serial.println("inhaling");
      //      Serial.write(2);
      delay(100);  // inhaling
    }
  }
  if (countingBlow == true) {
    if (analogRead(sensor) < 110) {

      interval = timeEnd - timeStart;
      capacity = interval * maxSpeed * sensorCSA;
      Serial.println("capacity " + capacity);
      delay(1000);

      check = true;
      //    countingBlow = false;


    } else {
      timeEnd = millis();
      if (analogRead(sensor) > maxSpeed) {
        maxSpeed = analogRead(sensor);

        //    mValue = int(map(analogRead(sensor), 100, 900, 10, 255));
        //    Serial.write(mValue);
        //    delay(100);
      }
    }
  }
  delay(500);
}




