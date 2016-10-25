String state = "";
int d = 100;
int sensorData = 0;
boolean runState = false;

void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  state = "standby";
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
    sensorData = analogRead(0);

    if (sensorData > 110) {
      state = "blow";
      delay(d);
      runState = false;
    }

    if (sensorData < 101) {
      state = "inhale";
      delay(d);
      runState = false;
    }

    else {
      state = "standby";
    }

    if (state == "inhale") {
      Serial.println(state);
    }

    if (state == "blow") {
      Serial.println(state);
    }

    if (state == "standby") {
      Serial.println(state);
    }
  }
}
