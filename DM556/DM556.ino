#include <MobaTools.h>

#define DIR_PIN 3
#define STEP_PIN 2
#define SWITCH_PIN 7
#define ENA 5

const int stepsPerRev = 800;
const long targetPos = 440;
long nextPos;

unsigned int x = 0;
float AcsValue = 0.0, Samples = 0.0, AvgAcs = 0.0, AcsValueF = 0.0;

MoToStepper myStepper ( stepsPerRev, STEPDIR );
MoToTimer pause;
bool stepperRunning;


void setup() {
  Serial.begin(115200);
  pinMode(SWITCH_PIN, INPUT_PULLUP);

  myStepper.attach( STEP_PIN, DIR_PIN );
  myStepper.setSpeed( 200 );  // 300 is 30 Rev/Min
  // /8 is slower than /2 -> Ramping length step, for example the step per rev is 800, if ramp is 400, than it will ramp up until 400.
  // if Ramp = 0, no Ramp.
  myStepper.setRampLen( stepsPerRev / 8);
  stepperRunning = true;


  //Calibrate Posititon
  myStepper.setSpeed(100);
  myStepper.setRampLen(0);
  while (digitalRead(SWITCH_PIN) != 1){
    myStepper.moveTo(-440);
  }
  myStepper.stop();
  myStepper.setZero();

  delay(1000);  
}

void loop() {
  if ( stepperRunning ) {
    if (!myStepper.moving() ) {
      pause.setTime(2000); //pause state is HIGH
      stepperRunning = false;
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

  if (x < 150) { //Read until
    AcsValue = analogRead(A0);
    Samples = Samples + AcsValue;
    x++;
  }
  else {
    AvgAcs = Samples / 150.0;
    AcsValueF = fabs((2.5 - (AvgAcs * (5.0 / 1024.0)) ) / 0.100);
    AcsValueF*=1.1914; //Offset
    if (AcsValueF < 0.2) AcsValueF = 0;
    x = 0;
    Samples = 0;
  }

  Serial.print(AcsValueF);
  Serial.print('\t');
  Serial.println(myStepper.currentPosition());

}
