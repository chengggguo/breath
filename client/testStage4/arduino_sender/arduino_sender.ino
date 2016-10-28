String state = "";
int d = 100;
int sensorData = 0;
boolean runState = false;
boolean blowing = false;
float sensorCSA = 0.785; // the cross-sectional area of air pressure sensor


unsigned long timeStart;
unsigned long timeEnd;
int interval = 0;
int maxSpeed = 0;

int capacity = 0;

void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(A0, INPUT);
  state = "standby";
  runState = true;
}

void loop() {

  //Processing has ALL CONTROL
  while (Serial.available() > 0) {

    String stateCheck = Serial.readString();
    if (stateCheck == "true") {
      runState = true;
      digitalWrite(13, HIGH);
    } else {
      runState = false;
      digitalWrite(13, LOW);
    }
  }

  if (runState) {
    sensorData = analogRead(A0);

    if (sensorData > 510) {
      state = "0";        // blow
//      Serial.print(sensorData);
      delay(d);
      runState = false;
      timeStart = millis();
      blowing = true;
    }

    else if (sensorData < 495) {
      state = "1";      //inhale
//      Serial.print(sensorData);
      delay(d);
      runState = false;
    }

    else {
      state = "2";      // stand by
//  
    }


    if (state == "1") {         //inhale
      Serial.print(state);
      delay(d);
    }

    if (state == "0") {       //blow
      Serial.print(state);
      delay(d);

    }

    if (state == "2") {     //stand by
      Serial.print(state);
      delay(d);
    }
  }

  if (blowing == true) {
    if (analogRead(0) < 510) {
      interval = timeEnd - timeStart;
      Serial.print(interval);
      capacity = int((interval * maxSpeed * sensorCSA)/10);
      Serial.print(capacity);
      delay(100);

      blowing = false;

    } else {
      timeEnd = millis();
      if (analogRead(A0) > maxSpeed) {
        maxSpeed = analogRead(A0);
        delay(10);

      }
    }
  }
}

