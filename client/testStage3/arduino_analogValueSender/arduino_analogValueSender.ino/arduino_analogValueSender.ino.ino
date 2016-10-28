int sensor = A0;
float sensorCSA = 0.785; // the cross-sectional area of air pressure sensor

boolean stateCheck = true; // state check(blowing, inhaling, stand by)
boolean Blowing = false;
boolean inhaling = false;

unsigned long timeStart;
unsigned long timeEnd;
int interval = 0;
int maxSpeed = 0;
int capacity = 0;



void setup() {
  pinMode(sensor, INPUT);
  Serial.begin(9600);
}

void loop() {

  if (stateCheck = true) {
    stateMachine(analogRead(sensor)); // Three states : blowing, inhaling, stand by

  }

  if (Blowing == true) {
    if (analogRead(sensor) < 111) {

      interval = timeEnd - timeStart;
      capacity = int((interval * maxSpeed * sensorCSA) / 10);
      Serial.println(capacity);
      //      Serial.println("time " + interval);
      //      Serial.print("capacity ");
      //      Serial.println(capacity);
      Serial.write(capacity);
      delay(100);

      stateCheck = true;
      Blowing = false;


    } else {
      timeEnd = millis();
      if (analogRead(sensor) > maxSpeed) {
        maxSpeed = analogRead(sensor);
        stateCheck = false;
      }
    }
  } else if (inhaling == true) {
    //    Serial.println(capacity + "ms");
    delay(5000);
    //    delay(capacity * 100);
    interval = 0;
    stateCheck = true;
    inhaling = false;

  }
  //  delay(500);
}

void stateMachine(int i) {
  if (i >= 115) {
    Serial.println("Blowing");
    Serial.println(i);
    //    Serial.write(0);
    Blowing = true;
    timeStart = millis();
    stateCheck = false;
    delay(100);
  } else if (i < 99) {
    Serial.println("inhaling");
    Serial.println(i);
    inhaling = true;
    stateCheck = false;
    //    Serial.write(1);
    delay(100);
  } else {
    Serial.println("stand by");
    Serial.println(i);
    //    Serial.write(2);
    stateCheck = true;
    delay(100);
  }

  //  if (i >= 115) {
  //    //    Serial.println("Blowing");
  //    //    Serial.println(i);
  //    Serial.write(0);
  //    Blowing = true;
  //    timeStart = millis();
  //    stateCheck = false;
  //    delay(100);
  //  } else if (i < 99) {
  //    //    Serial.println("inhaling");
  //    //    Serial.println(i);
  //    inhaling = true;
  //    stateCheck = false;
  //    Serial.write(1);
  //    delay(100);
  //  } else {
  //    //    Serial.println("stand by");
  //    //    Serial.println(i);
  //    //    Serial.write(2);
  //    stateCheck = true;
  //    delay(100);
  //  }
}


