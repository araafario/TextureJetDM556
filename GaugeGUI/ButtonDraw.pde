void mousePressed() {
  lastState = state;
  
  if (overBox1) state = 0;
  else if (overBox2) {
    if (needCalib == false) state = 1;
  }
  else if (overBox3) {
    needCalib = false;
    state = 2;
    lastState = 2;
  }
  else if (overBox4) state = 3;
  else if (overBox5) state = 4;
  
  if (state == 3) {
    if (overBoxSP1) sendSpeed = 50;
    else if (overBoxSP2) sendSpeed = 100;
    else if (overBoxSP3) sendSpeed = 150;
    else if (overBoxSP4) sendSpeed = 200;
    else if (overBoxSP5) sendSpeed = 400;
    else if (overBoxRP1) sendRamp = 1;
    else if (overBoxRP2) sendRamp = 2;
    else if (overBoxRP3) sendRamp = 4;
    else if (overBoxRP4) sendRamp = 8;
    else if (overBoxRP5) sendRamp = 16;
  }
}

void checkButton(int bx, int by, int xSize, int ySize, int box) {
  if (mouseX > bx-xSize && mouseX < bx+xSize && mouseY > by-ySize && mouseY < by+ySize) {
    if (box == 1) overBox1 = true;
    else if (box == 2) overBox2 = true;
    else if (box == 3) overBox3 = true;
    else if (box == 4) overBox4 = true;
    else if (box == 5) overBox5 = true;
    else if (box == 6) overBoxSP1 = true;
    else if (box == 7) overBoxSP2 = true;
    else if (box == 8) overBoxSP3 = true;
    else if (box == 9) overBoxSP4 = true;
    else if (box == 10) overBoxSP5 = true;
    else if (box == 11) overBoxRP1 = true;
    else if (box == 12) overBoxRP2 = true;
    else if (box == 13) overBoxRP3 = true;
    else if (box == 14) overBoxRP4 = true;
    else if (box == 15) overBoxRP5 = true;
  } else {
    if (box == 1) overBox1 = false;
    else if (box == 2) overBox2 = false;
    else if (box == 3) overBox3 = false;
    else if (box == 4) overBox4 = false;
    else if (box == 5) overBox5 = false;
    else if (box == 6) overBoxSP1 = false;
    else if (box == 7) overBoxSP2 = false;
    else if (box == 8) overBoxSP3 = false;
    else if (box == 9) overBoxSP4 = false;
    else if (box == 10) overBoxSP5 = false;
    else if (box == 11) overBoxRP1 = false;
    else if (box == 12) overBoxRP2 = false;
    else if (box == 13) overBoxRP3 = false;
    else if (box == 14) overBoxRP4 = false;
    else if (box == 15) overBoxRP5 = false;
  }
}

void drawMainButton() {
  int bx1=350-240, by1=330, xSize1=50, ySize1 = 25;
  int bx2=350-120, by2=330, xSize2=50, ySize2 = 25;
  int bx3=350, by3=330, xSize3=50, ySize3 = 25;
  int bx4=350+120, by4=330, xSize4=50, ySize4 = 25;
  int bx5=350+240, by5=330, xSize5=50, ySize5 = 25;
  rectMode(RADIUS);

  if (state == 0) fill(100);
  else fill (0);
  rect(bx1, by1, xSize1, ySize1);

  if (needCalib == true) fill (200);
  else if (state == 1) fill(100);
  else fill (0);
  rect(bx2, by2, xSize2, ySize2);

  if (state == 2) fill(100);
  else fill (0);
  rect(bx3, by3, xSize3, ySize3);

  if (state == 3) fill(100);
  else fill (0);
  rect(bx4, by4, xSize4, ySize4);

  if (state == 4) fill(100);
  else fill (0);
  rect(bx5, by5, xSize5, ySize5);

  fill(255);

  checkButton(bx1, by1, xSize1, ySize1, 1);
  checkButton(bx2, by2, xSize2, ySize2, 2);
  checkButton(bx3, by3, xSize3, ySize3, 3);
  checkButton(bx4, by4, xSize4, ySize4, 4);
  checkButton(bx5, by5, xSize5, ySize5, 5);

  textAlign(LEFT);
  String disp = "Something Wrong...";
  if (receivedState == 0) disp = "Arduino Status - Stopping";
  else if (receivedState == 1) disp = "Arduino Status - Running " + str(sendSpeed/10) + "rpm";
  else if (receivedState == 2) disp = "Arduino Status - Calibrating";
  else disp = "Arduino Status - Unknown";
  text(disp, 15, 390);
  textAlign(CENTER);

  text("Stop", bx1, by1+10);
  text("Run", bx2, by2+10);
  text("Calib", bx3, by3+10);
  text("Speed", bx4, by4+10);
  text("Manual", bx5, by5+10);
  
  if (needCalib == true) {
    fill(255,0,0);
    text("Need Calibrate", 600, 390);
    fill(255);
  }
}


void drawSpeedButton() {
  int bx1=350-240, by1=100, xSize1=50, ySize1 = 25;
  int bx2=350-120, by2=100, xSize2=50, ySize2 = 25;
  int bx3=350, by3=100, xSize3=50, ySize3 = 25;
  int bx4=350+120, by4=100, xSize4=50, ySize4 = 25;
  int bx5=350+240, by5=100, xSize5=50, ySize5 = 25;
  rectMode(RADIUS);

  if (sendSpeed == 50) fill(100);
  else fill (0);
  rect(bx1, by1, xSize1, ySize1);

  if (sendSpeed == 100) fill(100);
  else fill (0);
  rect(bx2, by2, xSize2, ySize2);

  if (sendSpeed == 150) fill(100);
  else fill (0);
  rect(bx3, by3, xSize3, ySize3);

  if (sendSpeed == 200) fill(100);
  else fill (0);
  rect(bx4, by4, xSize4, ySize4);

  if (sendSpeed == 400) fill(100);
  else fill (0);
  rect(bx5, by5, xSize5, ySize5);

  fill(255);

  checkButton(bx1, by1, xSize1, ySize1, 6);
  checkButton(bx2, by2, xSize2, ySize2, 7);
  checkButton(bx3, by3, xSize3, ySize3, 8);
  checkButton(bx4, by4, xSize4, ySize4, 9);
  checkButton(bx5, by5, xSize5, ySize5, 10);

  text("Set Speed", bx1, by1-40);
  text("5rpm", bx1, by1+10);
  text("10rpm", bx2, by2+10);
  text("15rpm", bx3, by3+10);
  text("20rpm", bx4, by4+10);
  text("40rpm", bx5, by5+10);
}

void drawRampButton() {
  int bx1=350-240, by1=100+120, xSize1=50, ySize1 = 25;
  int bx2=350-120, by2=100+120, xSize2=50, ySize2 = 25;
  int bx3=350    , by3=100+120, xSize3=50, ySize3 = 25;
  int bx4=350+120, by4=100+120, xSize4=50, ySize4 = 25;
  int bx5=350+240, by5=100+120, xSize5=50, ySize5 = 25;
  rectMode(RADIUS);

  if (sendRamp == 1) fill(100);
  else fill (0);
  rect(bx1, by1, xSize1, ySize1);

  if (sendRamp == 2) fill(100);
  else fill (0);
  rect(bx2, by2, xSize2, ySize2);

  if (sendRamp == 4) fill(100);
  else fill (0);
  rect(bx3, by3, xSize3, ySize3);

  if (sendRamp == 8) fill(100);
  else fill (0);
  rect(bx4, by4, xSize4, ySize4);

  if (sendRamp == 16) fill(100);
  else fill (0);
  rect(bx5, by5, xSize5, ySize5);

  fill(255);

  checkButton(bx1, by1, xSize1, ySize1, 11);
  checkButton(bx2, by2, xSize2, ySize2, 12);
  checkButton(bx3, by3, xSize3, ySize3, 13);
  checkButton(bx4, by4, xSize4, ySize4, 14);
  checkButton(bx5, by5, xSize5, ySize5, 15);

  textAlign(LEFT);
  text("Set Ramp (Step per revolution divided by setting)", bx1-50, by1-40);
  textAlign(CENTER);
  text("1", bx1, by1+10);
  text("2", bx2, by2+10);
  text("4", bx3, by3+10);
  text("8", bx4, by4+10);
  text("16", bx5, by5+10);
}
