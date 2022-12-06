import processing.net.*;
import processing.serial.*;

Serial port;    // Create an object from Serial class
static final int PORT_INDEX = 0, BAUDS = 115200;
String[] ports;

PFont font;
float x1, y1, x2, y2;
String angle = "0"; // angle in degrees
float anglef1, anglef2;
float angle1 = 0.0;
float segLength = 110;
BufferedReader reader;
String line;
float[] vals = {};

float current;
int step;

//Variable for parsing
char[] dataIn;
String dt[];
int i;
boolean parsing = false;

//Send to arduino
int arduinoState; //0-OFF, 1-ON, 2-RESET
int state=1;

//Button
boolean overBox1, overBox2, overBox3;

void setup() {

  size(350*2, 500);
  strokeWeight(2);
  stroke(255, 160);

  x1 = 350*2 * 0.25;
  y1 = 300 * 0.8;

  x2 = 350*2 * 0.75;
  y2 = 300 * 0.8;

  font = loadFont("LucidaSans-20.vlw");
  textFont(font);
  textAlign(CENTER);

  background(0);
  text("No Serial", 350, 280);
  do {
    ports = Serial.list();
    printArray(ports);
    println("Searching for Serial");
  } while (!(ports.length > 0));


  new Serial(this, ports[PORT_INDEX], BAUDS).bufferUntil(ENTER);
  println("Connected !");

  /*
  if (Serial.available())
   */
}

void draw() {
  background(0);

  switch(state) {
  case 0:
    break;
  case 1:
    currentGauge();
    stepperGauge();

    int bx1=150, by1=350, xSize1=50, ySize1 = 25;
    int bx2=200, by2=350, xSize2=50, ySize2 = 25;
    int bx3=250, by3=350, xSize3=50, ySize3 = 25;
    rectMode(RADIUS);
    rect(bx1, by1, xSize1, ySize1);
    
    checkButton(bx1,by1,xSize1,ySize1,overBox1);
    checkButton(bx2,by2,xSize2,ySize2,overBox2);
    checkButton(bx3,by3,xSize3,ySize3,overBox3);
    

    break;
  case 3:
    break;
  default:
    break;
  }
}

void serialEvent(final Serial s) {
  try {
    vals = float(splitTokens(s.readString()));
    current = vals[0];
    step = int(vals[1]);
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}

void mousePressed() {
  if (overBox1) state = 0;
  else if (overBox2) state = 1;
  else if (overBox3) state = 2;
}

void checkButton(int bx,int by,int xSize,int ySize,boolean overBox) {
  if (mouseX > bx-xSize && mouseX < bx+xSize && mouseY > by-ySize && mouseY < by+ySize) overBox = true;
  else overBox = false;
}
