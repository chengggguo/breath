


//Pin connected to latch pin (ST_CP) of 74HC595
const int latchPin = 8;

//Pin connected to clock pin (SH_CP) of 74HC595
const int clockPin = 3;
////Pin connected to Data in (DS) of 74HC595
const int dataPin = 9;
byte Tab[]={
  0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0xff};
void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);  
  pinMode(clockPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("reset");
  for(int i = 0;i < 10; i++){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, MSBFIRST, Tab[i]);
    digitalWrite(latchPin, HIGH);
    delay(500);
  }
}
void loop() {
  if (Serial.available() > 0) {
    int rawNum = Serial.read() - 48;
    String num = String(rawNum);
    int n = num.length();
    String reversedNum[16];
    for (int i = 0; i<n; i++){
      reversedNum[15-i]= num[n-1-i];
      }
    for(int e=0; e<(15-n); e++){
      reversedNum[e]="0";
      }
      
    int bitToSet = int(reversedNum);
    Serial.println(bitToSet);
    // write to the shift register with the correct bit set high:
    digitalWrite(latchPin, LOW);
    // shift the bits out:
    shiftOut(dataPin, clockPin, MSBFIRST, Tab[bitToSet]);
    // turn on the output so the LEDs can light up:
    digitalWrite(latchPin, HIGH);
  }
}
