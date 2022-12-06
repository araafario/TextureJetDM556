import processing.net.*;
import processing.serial.*;

Serial port;    // Create an object from Serial class
static final int PORT_INDEX = 0, BAUDS = 115200;
String[] ports;

PFont font;
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
int iteration;

//Send to arduino
int sendState, sendSpeed = 200, sendRamp = 8; //StateArduino => 0-Stop, 1-Run, 2-Calib, 3-Manual
int receivedState;
int state, lastState, stateDraw; //State => 0-Stop 1-Run 2-Calib 3-SetSpeed 4-Manual
boolean needCalib;


//Button
boolean overBox1, overBox2, overBox3, overBox4, overBox5;
boolean overBoxSP1, overBoxSP2, overBoxSP3, overBoxSP4, overBoxSP5;
boolean overBoxRP1, overBoxRP2, overBoxRP3, overBoxRP4, overBoxRP5;

void setup() {

  size(350*2, 400);
  strokeWeight(2);
  stroke(255, 160);

  font = loadFont("LucidaSans-20.vlw");
  textFont(font);
  textAlign(LEFT);
  background(0);
  text("Serial undetected", 30, 350);
  text("Waiting for serial...", 30, 370);

  do {
    ports = Serial.list();
    printArray(ports);
    println("Searching for Serial");
  } while (!(ports.length > 0));

  delay(50);
  new Serial(this, ports[PORT_INDEX], BAUDS).bufferUntil(ENTER);
  background(0);
  text("Connected!!", 30, 20);
  textAlign(CENTER);

  delay(3000);

  /*
  if (Serial.available())
   */
}

void draw() {
  background(0);

  if (state == 3) { //Change Screen to Setting Speed
    drawSpeedButton();
    drawRampButton();
  } else if (state == 4) { //Change Screen to Manual
  } else {
    sendState = state;
    drawGauge();
  }
  /*
  if (state != 2 && step > 2 && needCalib == false) {
   needCalib = true;
   }*/
  if (lastState == 1 && state != 1) needCalib = true;
  drawMainButton();
}

void serialEvent(final Serial s) {
  try {
    vals = float(splitTokens(s.readString()));

    if (vals[0] == 255.0 && vals[4] == 254.0) {
      current = vals[1];
      step = int(vals[2]);
      receivedState = int(vals[3]);

      iteration++;
      if (iteration > 4) {
        iteration = 0;
        String sendSerial = "#" + str(sendSpeed) + "," + str(sendState)
          + "," + str(sendRamp) + "@" + "\n";
        s.write(sendSerial);
        if (state == 2) state = 0;
      }
    }
  }
  catch(RuntimeException e) {
    //e.printStackTrace();
    println("Serial Error Happened");
  }
}
