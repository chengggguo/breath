
import processing.serial.*;
Serial myPort; 
void setup() {
  String portName = Serial.list()[0];
 println(portName);
  myPort = new Serial(this, portName, 9600);
  delay(1000);
  myPort.write(1);
  myPort.write(1);
  myPort.write(1);
  myPort.write(1);
  myPort.write(1);
  
  
  
  //String num = "77419920006526";
  //String converted = "";
  //String numPrint1 = "";
  //String numPrint2 = "";
  //String numPrint3 = "";
  //String numPrint4 = "";
  //String numPrint5 = "";
  //String numPrint6 = "";
  //String numPrint7 = "";
  //String numPrint8 = "";
  //String numPrint9 = "";
  //String numPrint10 = "";
  //String numPrint11= "";
  //String numPrint12 = "";
  //String numPrint13 = "";
  //String numPrint14 = "";
  //String numPrint15 = "";
  //String numPrint16= "";

  //String c = num; 
  //println("input: " + c);
  //int n = c.length();
  //println("length: " + n);
  //char [] bit = new char[16];
  //char[] n1 = new char[1];
  //char[] n2 = new char[2];
  //char[] n3 = new char[3];
  //char[] n4 = new char[4];
  //char[] n5 = new char[5];
  //char[] n6 = new char[6];
  //char[] n7 = new char[7];
  //char[] n8 = new char[8];
  //char[] n9 = new char[9];
  //char[] n10 = new char[10];
  //char[] n11= new char[11];
  //char[] n12 = new char[12];
  //char[] n13 = new char[13];
  //char[] n14 = new char[14];
  //char[] n15= new char[15];
  //char[] n16 = new char[16];


  //for (int i=0; i<n; i++) {
  //  bit[i] = c.charAt(i);
  //}

  //for (int i=(n-1); i>-1; i--) {
  //  converted += bit[i];
  //}
  //for (int o=0; o<(16-n); o++) {
  //  converted += 0;
  //}

  //for (int p =0; p<1; p++) {
  //  n1[p]=converted.charAt(p);
  //  numPrint1 +=n1[p];
  //}

  //for (int p =1; p<2; p++) {
  //  n2[p]=converted.charAt(p);
  //  numPrint2 +=n2[p];
  //}

  //for (int p =2; p<3; p++) {
  //  n3[p]=converted.charAt(p);
  //  numPrint3 +=n3[p];
  //}
  //for (int p =3; p<4; p++) {
  //  n4[p]=converted.charAt(p);
  //  numPrint4 +=n4[p];
  //}

  //for (int p =4; p<5; p++) {
  //  n5[p]=converted.charAt(p);
  //  numPrint5 +=n5[p];
  //}

  //for (int p =5; p<6; p++) {
  //  n6[p]=converted.charAt(p);
  //  numPrint6 +=n6[p];
  //}
  //for (int p =6; p<7; p++) {
  //  n7[p]=converted.charAt(p);
  //  numPrint7 +=n7[p];
  //}

  //for (int p =7; p<8; p++) {
  //  n8[p]=converted.charAt(p);
  //  numPrint8 +=n8[p];
  //}

  //for (int p =8; p<9; p++) {
  //  n9[p]=converted.charAt(p);
  //  numPrint9 +=n9[p];
  //}
  //for (int p =9; p<10; p++) {
  //  n10[p]=converted.charAt(p);
  //  numPrint10 +=n10[p];
  //}

  //for (int p =10; p<11; p++) {
  //  n11[p]=converted.charAt(p);
  //  numPrint11 +=n11[p];
  //}

  //for (int p =11; p<12; p++) {
  //  n12[p]=converted.charAt(p);
  //  numPrint12 +=n12[p];
  //}
  //for (int p =12; p<13; p++) {
  //  n13[p]=converted.charAt(p);
  //  numPrint13 +=n13[p];
  //}
  //for (int p =13; p<14; p++) {
  //  n14[p]=converted.charAt(p);
  //  numPrint14 +=n14[p];
  //}

  //for (int p =14; p<15; p++) {
  //  n15[p]=converted.charAt(p);
  //  numPrint15 +=n15[p];
  //}

  //for (int p =15; p<16; p++) {
  //  n16[p]=converted.charAt(p);
  //  numPrint16 +=n16[p];
  //}

  //println(converted);
  ////println(int(numPrint1));
  ////println(int(numPrint2));
  ////println(int(numPrint3));
  ////println(int(numPrint4));
  ////println(int(numPrint5));
  ////println(int(numPrint6));

  //myPort.write(int(numPrint1));
  //delay(5);
  //myPort.write(int(numPrint2));
  //delay(5);
  //myPort.write(int(numPrint3));
  //delay(5);
  //myPort.write(int(numPrint4));
  //delay(5);
  //myPort.write(int(numPrint5));
  //delay(5);
  //myPort.write(int(numPrint6));
  //delay(5);
  //myPort.write(int(numPrint7));
  //delay(5);
  //myPort.write(int(numPrint8));
  //delay(5);
  //myPort.write(int(numPrint9));
  //delay(5);
  //myPort.write(int(numPrint10));
  //delay(5);
  //myPort.write(int(numPrint11));
  //delay(5);
  //myPort.write(int(numPrint12));
  //delay(5);
  //myPort.write(int(numPrint13));
  //delay(5);
  //myPort.write(int(numPrint14));
  //delay(5);
  //myPort.write(int(numPrint15));
  //delay(5);
  //myPort.write(int(numPrint16));
  //delay(5);
}

void draw() {
    myPort.write(6);
  //String num = "1992326456526";
  //String converted = "";
  //String numPrint1 = "";
  //String numPrint2 = "";
  //String numPrint3 = "";
  //String numPrint4 = "";
  //String numPrint5 = "";
  //String numPrint6 = "";
  //String numPrint7 = "";
  //String numPrint8 = "";
  //String numPrint9 = "";
  //String numPrint10 = "";
  //String numPrint11= "";
  //String numPrint12 = "";
  //String numPrint13 = "";
  //String numPrint14 = "";
  //String numPrint15 = "";
  //String numPrint16= "";

  //String c = num; 
  //println("input: " + c);
  //int n = c.length();
  //println("length: " + n);
  //char [] bit = new char[16];
  //char[] n1 = new char[1];
  //char[] n2 = new char[2];
  //char[] n3 = new char[3];
  //char[] n4 = new char[4];
  //char[] n5 = new char[5];
  //char[] n6 = new char[6];
  //char[] n7 = new char[7];
  //char[] n8 = new char[8];
  //char[] n9 = new char[9];
  //char[] n10 = new char[10];
  //char[] n11= new char[11];
  //char[] n12 = new char[12];
  //char[] n13 = new char[13];
  //char[] n14 = new char[14];
  //char[] n15= new char[15];
  //char[] n16 = new char[16];


  //for (int i=0; i<n; i++) {
  //  bit[i] = c.charAt(i);
  //}

  //for (int i=(n-1); i>-1; i--) {
  //  converted += bit[i];
  //}
  //for (int o=0; o<(16-n); o++) {
  //  converted += 0;
  //}

  //for (int p =0; p<1; p++) {
  //  n1[p]=converted.charAt(p);
  //  numPrint1 +=n1[p];
  //}

  //for (int p =1; p<2; p++) {
  //  n2[p]=converted.charAt(p);
  //  numPrint2 +=n2[p];
  //}

  //for (int p =2; p<3; p++) {
  //  n3[p]=converted.charAt(p);
  //  numPrint3 +=n3[p];
  //}
  //for (int p =3; p<4; p++) {
  //  n4[p]=converted.charAt(p);
  //  numPrint4 +=n4[p];
  //}

  //for (int p =4; p<5; p++) {
  //  n5[p]=converted.charAt(p);
  //  numPrint5 +=n5[p];
  //}

  //for (int p =5; p<6; p++) {
  //  n6[p]=converted.charAt(p);
  //  numPrint6 +=n6[p];
  //}
  //for (int p =6; p<7; p++) {
  //  n7[p]=converted.charAt(p);
  //  numPrint7 +=n7[p];
  //}

  //for (int p =7; p<8; p++) {
  //  n8[p]=converted.charAt(p);
  //  numPrint8 +=n8[p];
  //}

  //for (int p =8; p<9; p++) {
  //  n9[p]=converted.charAt(p);
  //  numPrint9 +=n9[p];
  //}
  //for (int p =9; p<10; p++) {
  //  n10[p]=converted.charAt(p);
  //  numPrint10 +=n10[p];
  //}

  //for (int p =10; p<11; p++) {
  //  n11[p]=converted.charAt(p);
  //  numPrint11 +=n11[p];
  //}

  //for (int p =11; p<12; p++) {
  //  n12[p]=converted.charAt(p);
  //  numPrint12 +=n12[p];
  //}
  //for (int p =12; p<13; p++) {
  //  n13[p]=converted.charAt(p);
  //  numPrint13 +=n13[p];
  //}
  //for (int p =13; p<14; p++) {
  //  n14[p]=converted.charAt(p);
  //  numPrint14 +=n14[p];
  //}

  //for (int p =14; p<15; p++) {
  //  n15[p]=converted.charAt(p);
  //  numPrint15 +=n15[p];
  //}

  //for (int p =15; p<16; p++) {
  //  n16[p]=converted.charAt(p);
  //  numPrint16 +=n16[p];
  //}

  //println(converted);
  ////println(int(numPrint1));
  ////println(int(numPrint2));
  ////println(int(numPrint3));
  ////println(int(numPrint4));
  ////println(int(numPrint5));
  ////println(int(numPrint6));

  //myPort.write(int(numPrint1));
  //delay(10);
  //myPort.write(int(numPrint2));
  //delay(10);
  //myPort.write(int(numPrint3));
  //delay(10);
  //myPort.write(int(numPrint4));
  //delay(10);
  //myPort.write(int(numPrint5));
  //delay(10);
  //myPort.write(int(numPrint6));
  //delay(10);
  //myPort.write(int(numPrint7));
  //delay(10);
  //myPort.write(int(numPrint8));
  //delay(10);
  //myPort.write(int(numPrint9));
  //delay(10);
  //myPort.write(int(numPrint10));
  //delay(10);
  //myPort.write(int(numPrint11));
  //delay(10);
  //myPort.write(int(numPrint12));
  //delay(10);
  //myPort.write(int(numPrint13));
  //delay(10);
  //myPort.write(int(numPrint14));
  //delay(10);
  //myPort.write(int(numPrint15));
  //delay(10);
  //myPort.write(int(numPrint16));
  //delay(10);
}