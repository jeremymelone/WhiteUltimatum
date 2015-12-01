int creditFrame, creditY, xCreditPos, bgFade;
boolean creditSet = false;
//Resets variables used only for Credit screen
public void creditSetup() {
  creditFrame = 0;
  creditY = -110;
  xCreditPos = 0;
  bgFade = 255;
}
public void Credits() {
  //Variable Setup
  if (!creditSet) {
    creditSetup();
    creditSet=true;
  }
  //Audio Setup
  if (player!=credit) {
    player.pause();
    player=credit;
    player.rewind();
    player.play();
  }
  if (!player.isPlaying()) { 
    player.rewind();
    player.play();
  }
  //Background Animation
  switch(creditFrame) {
  case 0:
    background = backgroundCredit1;
    break;
  case 10:
    background= backgroundCredit2;
    break;
  case 20:
    background = backgroundCredit3;
  case 30:
    background = backgroundCredit4;
    break;
  }
  //Credit Animations
  if (xCreditPos<-220) {
    image(background, xCreditPos, -228);
    fill(255);
    textFont(creditFont);
    text("1501 Final Assigment", width/2, height-creditY);
    text("Jeremy Melone", width/2, height*1.5-creditY);
    text("Justin Rodriguez", width/2, height*2-creditY);
    text("James Fitzgerald", width/2, height*2.5-creditY);
    text("All  assets used are property" + '\n' + "of their respective owner," + "\n" + "support their offical release", width/2, height*3-creditY);
    text("See the manual for full details", width/2, height*3.5-creditY);
    textFont(titleFont);
    text("THANKS FOR PLAYING", width/2, height*4.2-creditY);
  } else {
    if (bgFade>0) {
      background(255-bgFade);
    } else {
      background(255);
    }
    fill(255);
    textFont(creditFont);
    text("The Journey's End", width/2, height/2);
    if (xCreditPos<-60) {
      bgFade-=2;
    }
  }
  //Counters
  if (xCreditPos>-940) {
    xCreditPos--;
  } else if (creditY<height*3.5+100) {
    creditY++;
  }
  if (creditFrame==40) {
    creditFrame=0;
  }
  creditFrame++;
}
public void keyInputCredits() {
  if (debug) {
    println("Credits");
  }
  if ((creditY==height*3.5+100)) {
    gameState = 3;
  }
}
