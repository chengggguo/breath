
//Pin connected to latch pin (ST_CP) of 74HC595
const int latchPin = 8;

//Pin connected to clock pin (SH_CP) of 74HC595
const int clockPin = 3;
////Pin connected to Data in (DS) of 74HC595
const int dataPin = 9;
byte Tab[] = {
  0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90, 0xff
};

int lengthNum;
int counting = 0;
int L;
int firL;
int secL;
int state = 0;
int lengthCount = 0;
int bitToSet;

void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("reset");
  for (int i = 0; i < 10; i++) {
    digitalWrite(latchPin, LOW);
    //        shiftOut(dataPin, clockPin, MSBFIRST, Tab[i]);
    shiftOut(dataPin, clockPin, MSBFIRST, 0xc0);
    digitalWrite(latchPin, HIGH);
    delay(5);
  }
}
void loop() {

  if (Serial.available() > 0) {
    switch (state) {
      case 0:
        L = Serial.read();

        if (lengthCount == 0) {
          lengthNum = L * 10;
        } else {
          lengthNum = lengthNum + L;
          state = 1;
        }
        lengthCount++;

        break;

      case 1:


        bitToSet = Serial.read();
        digitalWrite(latchPin, LOW);
        shiftOut(dataPin, clockPin, MSBFIRST, Tab[bitToSet]);
        digitalWrite(latchPin, HIGH);
        counting++;
        if (counting > (lengthNum - 1)) {
          state = 2;
        }

        break;

      case 2:
        if (counting < 17) {
          int bit = Serial.read();

          digitalWrite(latchPin, LOW);
          shiftOut(dataPin, clockPin, MSBFIRST, 0xff);
          digitalWrite(latchPin, HIGH);

          counting++;
        } else {
          lengthNum = 0;
          counting = 0;
          state = 0;
          lengthCount = 0;
          bitToSet = 0;
        }
        break;
    }

  }

  //        int bitToSet = Serial.read();
  //        // write to the shift register with the correct bit set high:
  //        digitalWrite(latchPin, LOW);
  //        // shift the bits out:
  //        shiftOut(dataPin, clockPin, MSBFIRST, Tab[bitToSet]);
  //        // turn on the output so the LEDs can light up:
  //        digitalWrite(latchPin, HIGH);
}

