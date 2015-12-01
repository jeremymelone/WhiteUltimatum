ArrayList<String> startScreenOptions = new ArrayList<String>();
int startScreenState = -1;
public void StartScreen() {
  //Setup
  background(255);
  if (player.isPlaying()) { 
    player.pause();
  }
  //Display
  textFont(menuFont);
  fill(0);
  switch(startScreenState) {
  case -1://Menu
    if (!startScreenOptions.contains("New Game")) {
      optionSelected = 0;
      startScreenOptions.add("New Game");
      startScreenOptions.add("About");
      startScreenOptions.add("Options");
    }
    for (int i = 0; i<startScreenOptions.size (); i++) {
      if (i!=optionSelected) {
        text(startScreenOptions.get(i), width/2, 30*i+30);
      } else {
        if (frameCounter>30) {
          text(startScreenOptions.get(i), width/2, 30*i+30);
        }
      }
    }
    break;
  case 0://New Game
    Dialog.get(0).create();
    break;
  case 1://About
    text("Please refer to the" + "\n" + "design documents for information", width/2, height/2);
    break;
  case 2://Options
    text("This feature will be avaliable" + '\n' + "a in future update", width/2, height/2);
    break;
  }
}
public void StartSelect(int selected) {
  switch(startScreenState) {
  case -1:
    startScreenState = selected;
    startScreenOptions.clear();
    break;
  }
}
public void keyInputStart() {
  if (debug) {
    println("Start Scren");
  }
  if (key=='w') {
    if (optionSelected!=0) {
      frameCounter = 0;
      menuEffect.rewind();
      menuEffect.play();
      optionSelected--;
    }
  }
  if (key=='s') {
    if (optionSelected!=startScreenOptions.size()-1) {
      frameCounter = 0;
      menuEffect.rewind();
      menuEffect.play();
      optionSelected++;
    }
  }
  if (key==secondaryKey) {
    if (startScreenState!=-1) {
      if (startScreenState==0) {
        if (Dialog.get(0).isDone) {
          Dialog.get(0).reset();
          startScreenState=-1;
          cancel.rewind();
          cancel.play();
        }
      } else {
        startScreenState=-1;
        cancel.rewind();
        cancel.play();
      }
    } else {
      gameState--;
      cancel.rewind();
      cancel.play();
    }
  }
  if (keyCode==ENTER||key==primaryKey) {
    if (startScreenOptions.size()!=0) {
      menuEffect.rewind();
      menuEffect.play();
      StartSelect(optionSelected);
    }
  }
  if (key==primaryKey) {
    if (Dialog.get(0).isDone) {
      Dialog.get(0).reset();
      menuEffect.rewind();
      menuEffect.play();
      gameState++;
    }
  }
}
