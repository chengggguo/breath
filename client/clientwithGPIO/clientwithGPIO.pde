import hypermedia.net.*;

UDP udp;
String ip;
int port;
int numberOfPackets;
boolean [] inPackets;
int w;
int h;
boolean allDataArrived;

int startTime;
int timeout;
int ellapsedTime;


void  setup(){
  size(800,600);
 background(0);
 loadPixels();
 ip = "localhost"; // 45.33.74.32 remote server of fito, can be replaced by "localserver"
 port = 10002;
 w = width;
 h = height;
 numberOfPackets = w * h;
 inPackets = new boolean[numberOfPackets];
 allDataArrived = false;
 
 udp = new UDP( this, 10001);
 udp.listen(true);
 
 for(int i = 0; i < numberOfPackets; i++){
  inPackets[i] = false; 
 }
 
 
 startTime = millis();
 timeout = 3000;
}

void draw(){
  timer();
  if(allDataArrived = true){
    for(int i=0; i < numberOfPackets; i++){
      
    if(inPackets[i] == true){
      color c = color(255);
      pixels[i] = c;
      
     }
    }
    updatePixels();
  }
}

void keyPressed(){
  if(key == ' '){
    for(int i=0; i < numberOfPackets;  i++){
      String message = str(i);
      message = message + ":\n";
      udp.send(message, ip, port);
    }
  }
}

void timer(){
  ellapsedTime = millis() - startTime;
  if(ellapsedTime > timeout){
    allDataArrived = true;
  }
}

void receive(byte[] data, String ip, int port){
  data = subset(data, 0 , data.length - 2);
  String message = new String(data);
  int index = int(message);
  inPackets[index] = true;
  
}