void drawGauge() {
  currentGauge();
  stepperGauge();
}

void segment(float x, float y, float a) {
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
}

void currentGauge() {
  float dispCurrent;
  if (current > 4.0) dispCurrent = 4.0;
  else dispCurrent = current;
  anglef1 = (180-(dispCurrent)*45)*3.1416/180*-1; //desiredHalf*x = 180

  pushMatrix();
  float x1 = 350*2 * 0.25, y1 = 300 * 0.8;
    
  segment(x1, y1, anglef1);
  popMatrix();

  text("Current (A)", 175, 50);
  text(current, 175, 280);
  text("0.0", 35, 250);
  text("1.0", 65, 150);
  text("2.0", 175, 100);
  text("3.0", 285, 150);
  text("4.0", 320, 250);

  noFill();
  arc(175, 245, 240, 245, PI, TWO_PI);
}

void stepperGauge() {
  int drawStep;
  if (step < 0) drawStep = 0;
  else drawStep = step;
  anglef2 = (180-(drawStep)*0.09)*3.1416/180*-1; //desiredHalf*x = 180

  pushMatrix();
  float x2 = 350*2 * 0.75, y2 = 300 * 0.8;
  segment(x2, y2, anglef2);
  popMatrix();

  text("Stepper (Step)", 175 + 350, 50);
  text(step, 175 + 350, 280);
  text("0", 35 + 350, 250);
  text("500", 65 + 350, 150);
  text("1000", 175 + 350, 100);
  text("1500", 285 + 350, 150);
  text("2000", 320 + 350, 250);

  noFill();
  arc(175 + 350, 245, 240, 245, PI, TWO_PI);
}
