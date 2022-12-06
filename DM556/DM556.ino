#include <MobaTools.h>

#define DIR_PIN 3
#define STEP_PIN 2
#define SWITCH_PIN 7
#define ENA 5

#define ACS_PIN A0

#define STOP 0
#define RUN 1
#define CALIB 2
#define SETSPEED 3
#define MANUAL 4

//===== Notes =====//
/*  Rail 13 Centimeter, 440 Step. 0.029cm/Step
    Data Send : ACS(A) \t(delimiter) Stepper Postition(Step) \t(delimiter) Status(flag) \n(footer)
    Data Received : #(footer) Speed(Speed/10 = Rev/Min) , Ramp , Status(flag) @
*/

const int stepsPerRev = 800;
const long targetPos = 420;
long nextPos;

int calibSpeed = 150;

unsigned int x = 0;
float AcsValue = 0.0, Samples = 0.0, AvgAcs = 0.0, AcsValueF = 0.0;

MoToStepper myStepper ( stepsPerRev, STEPDIR );
MoToTimer pause,sPause;

//== Program Flag ==//
bool stepperRunning;
int stateStatus;
bool doneCalib;

//== Serial ==//
int lastSend;
int receivedSpeed = 200;
int receivedRamp = 8;
String dataIn;
String dt[10];
int i;
boolean parsing = false;


void setup() {
  Serial.begin(115200);
  pinMode(SWITCH_PIN, INPUT_PULLUP);
  pinMode(13, OUTPUT);

  myStepper.attach( STEP_PIN, DIR_PIN );
  sPause.setTime(50);

  //==Calibrate Posititon==//
  myStepper.setSpeed(calibSpeed);
  myStepper.setRampLen(0);
  myStepper.moveTo(-440);
  while (digitalRead(SWITCH_PIN) != 1) {
    stateStatus = CALIB;
    sendSerial();
    //delay(10);
  }
  doneCalib = true;
  stateStatus = STOP;
  myStepper.stop();
  sendSerial();
  myStepper.setZero(1);
  delay(100);

  //==Setting up default value for Stepper==//
  myStepper.setSpeed(receivedSpeed);  // 300 is 30 Rev/Min
  // /8 is slower than /2 -> Ramping length step, for example the step per rev is 800, if ramp is 400, than it will ramp up until 400.
  // if Ramp = 0, no Ramp.
  myStepper.setRampLen(stepsPerRev / receivedRamp);

  stepperRunning = true;

  delay(1000);
}

void loop() {

  if (Serial.available() > 0) {
    char inChar = (char)Serial.read();
    dataIn += inChar;
    if (inChar == '@' && dataIn[0] == '#') {
      parsing = true;
    }
    else if (inChar == '#') {
      dataIn = "#";
    }
  }
  if (parsing) {
    parsingData();
    parsing = false;
    dataIn = "";
  }

  if (stateStatus != RUN) {
    pause.stop();
    nextPos = 0;
    stepperRunning = true;
  }
  if (doneCalib == false) stateStatus = CALIB;


  switch (stateStatus) {
    case STOP:
      myStepper.stop();
      setRamp();
      myStepper.setSpeed(receivedSpeed);
      break;
    case RUN:
      if ( stepperRunning ) {
        if (!myStepper.moving() ) {
          pause.setTime(1000); //pause state is HIGH
          stepperRunning = false;
          setRamp();
          myStepper.setSpeed(receivedSpeed);
        }
      }
      else {
        if ( pause.expired() ) {
          if ( nextPos == 0 ) {
            nextPos = targetPos;
          } else {
            nextPos = 0;
          }
          myStepper.moveTo( nextPos );
          stepperRunning = true;
        }
      }
      break;
    case CALIB:
      myStepper.setSpeed(calibSpeed);
      myStepper.setRampLen(0);
      if (digitalRead(SWITCH_PIN) != 1) {
        doneCalib = false;
        myStepper.moveTo(-440);
      }
      else {
        myStepper.stop();
        delay(100);
        myStepper.setZero(1);
        doneCalib = true;
        stateStatus = STOP;
      }
      break;
    case SETSPEED:
      break;
    case MANUAL:
      break;
    default:
      myStepper.stop();
      break;
  }

  readACS();
  sendSerial();
}

void setRamp() {
  myStepper.setRampLen(stepsPerRev / receivedRamp);
}

void readACS() {
  if (x < 150) { //Read until
    AcsValue = analogRead(ACS_PIN);
    Samples = Samples + AcsValue;
    x++;
  }
  else {
    AvgAcs = Samples / 150.0;
    AcsValueF = fabs((2.5 - (AvgAcs * (5.0 / 1024.0)) ) / 0.100); //Voltage
    AcsValueF *= 1.1914; //Offset
    if (AcsValueF < 0.2) AcsValueF = 0;
    //AcsValueF = 0.5543*AcsValueF + 0.1417; //Regression Bad Result | 0.06 - 0.175 | 0.52 - 0.43 |
    x = 0;
    Samples = 0;
  }
}

void sendSerial() {
  
  if (sPause.expired()) {
    Serial.print("255");
    Serial.print('\t');
    Serial.print(AcsValueF);
    Serial.print('\t');
    Serial.print(myStepper.currentPosition());
    Serial.print('\t');
    Serial.print(stateStatus);
    Serial.print('\t');
    Serial.println("254");
    sPause.setTime(50);
  }
}

void parsingData() {
  int j = 0;

  // Serial.print("data masuk : ");
  // Serial.print(dataIn);

  dt[j] = "";
  for (i = 1; i < dataIn.length(); i++) {
    if ((dataIn[i] == '#') || (dataIn[i] == ',')) {
      j++;
      dt[j] = "";
    }
    else {
      dt[j] = dt[j] + dataIn[i];
    }
  }

  receivedSpeed = dt[0].toInt();
  stateStatus = dt[1].toInt();
  receivedRamp = dt[2].toInt();
  if (stateStatus == 1) digitalWrite(13, HIGH);
  else digitalWrite(13, LOW);
}
