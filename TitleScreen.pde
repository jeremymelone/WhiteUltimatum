int birdFrame, birdX, birdY, birdYMax, yTitlePos, textFade;
boolean titleSet = false;
//Resets variables used only for title screen
public void titleSetup() {
  birdFrame = 0;
  birdX = width+64;
  birdY = height/4; 
  birdYMax = birdY;
  yTitlePos = -622;
  textFade = 255;
}

public void TitleBoot() {
  //Variable Setup
  if (!titleSet) {
    titleSetup();
    titleSet=true;
  }
  //Resets
  creditSet = false;
  //Audio Setup
  if (player.isPlaying()) {
    player.pause();
    player.rewind();
  }
  if (effect!=boot) {
    effect.pause();
    effect = boot;
  } else if (!effect.isPlaying()) {  
    effect.rewind();
  }
  effect.play();
  if (yTitlePos>-343) {
    gameState++;
  } else {
    //Screen
    background(255);
    fill(textFade);
    textFont(titleFont);
    text("Company Name Goes Here", width/2, height-96);
    //Animation + Sound Effect
    if (yTitlePos<-452&&textFade>1) {
      effect.play();
      textFade-=2;
    } else if (textFade<255) {
      textFade+=3;
    }
    yTitlePos++;
  }
}
public void Title() {
  //Sets title screen to setup if you enter the boot screen
  titleSet = false;
  //Audio Setup
  if (player!=intro) {
    player.pause();    
    player=intro;
    player.rewind();
    player.play();
  }
  //Image Setup
  if (background!=backgroundTitle) {
    background=backgroundTitle;
  }
  //Set to screen
  image(background, 0, yTitlePos);
  if (!player.isPlaying()) { 
    player.rewind();
    player.play();
  }
  if (yTitlePos<0) {
    yTitlePos++;
  } else {
    image(title, 0, 0);
    //Bird Animation
    switch(birdFrame) {
    case 0:
      bird = bird1;
      break;
    case 10:
      bird = bird2;
      break;
    case 20:
      bird = bird3;
      break;
    }
    if (frameCounter==0) {
      birdYMax+=random(-height/4, height/4);
      if (birdYMax>height/2) {
        birdYMax=height/2;
      } else if (birdYMax<0) {
        birdYMax=0;
      }
    }
    image(bird, birdX, birdY);
    birdX--; 
    if (birdYMax!=birdY) {
      if (birdYMax>birdY) {
        birdY++;
      } else {
        birdY--;
      }
    }
    if (birdX<-bird.width) {
      birdX=width+int(random(0, 128));
    }
    //Text Animation
    if (frameCounter>30) {
      fill(255);
      textFont(titleFont);
      text("PRESS ENTER", width/2, height-96);
    }
    //Counters
    if (birdFrame==30) {
      birdFrame=0;
    }
    birdFrame++;
  }
}
public void keyInputTitle() {
  if (keyCode == ENTER||key==primaryKey) {
    if (debug) {
      println("Title");
    }
    menuBootEffect.rewind();
    menuBootEffect.play();
    gameState = 2;
    yTitlePos=0;
    birdX = width+64;
    birdY = height/4;
  }
}
