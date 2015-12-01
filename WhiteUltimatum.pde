//Jan 18,2015
import ddf.minim.*;
import gifAnimation.*;

PFont titleFont = createFont("Press Start 2P", 28);
PFont menuFont = createFont("Press Start 2P", 20);
PFont pauseFont = createFont("Press Start 2P", 18);
PFont textFont = createFont("Press Start 2P", 16);
PFont commentFont = createFont("Press Start 2P", 17);
PFont turnFont = createFont("Press Start 2P", 10);
PFont teamHPfont=createFont("Press Start 2P", 13);
PFont creditFont = createFont("sao", 64);

AudioPlayer player, intro, credit, town, battle, overworld, fanfare;//Music
AudioPlayer effect, boot, menuBootEffect, menuEffect, cancel, error, zoneChange;//Sound Effects
Minim minim;

PImage background, backgroundTitle, title;
PImage backgroundCredit1, backgroundCredit2, backgroundCredit3, backgroundCredit4;//Credit Screen Background
PImage bird, bird1, bird2, bird3;//Title Screen Bird
PImage spriteSheet1, tileSheetA, tileSheetB, tileSheetC, tileSheetD, tileSheetE, tileSheetF, tileSheetG, tileSheetH, tileSheetI;
PImage grass, mound, sign, street, sandbag, houseTopL, houseBotL, houseTopR, houseBotR,roofTopL, roofBotL, roofTopR, roofBotR, innSign;
PImage character, npc1, npc2, npc3;

PImage bottomBarSimple;
PImage dude;

Gif water;

char primaryKey = 'o';
char secondaryKey = 'p';

ArrayList<TFextbox> Dialog = new ArrayList<TFextbox>();

int gameState;
/*
GameState Legend:
 0 == Boot Screen;
 1 == Title Screen;
 2 == Start Screen;
 3 == Overworld;
 4 == Battle;
 -1 == Credit Screen;
 */
int frameCounter = 0;
int optionSelected = 0;

boolean debug = false;//For debugging

//Loads Audio Files
public void loadMusic() {
  intro = minim.loadFile("intro.mp3");
  boot = minim.loadFile("companyIntro.mp3");
  credit = minim.loadFile("Shirushi.mp3");
  menuEffect = minim.loadFile("Cursor.wav");
  menuBootEffect = minim.loadFile("Menu.wav");
  cancel  = minim.loadFile("Cancel.wav"); 
  error = minim.loadFile("Error.wav");
  zoneChange = minim.loadFile("zoneChange.wav");
  battle = minim.loadFile("battle.mp3");
  overworld = minim.loadFile("overworld.mp3");
  town = minim.loadFile("town.mp3");
  fanfare = minim.loadFile("Fanfare.mp3");
  player = intro;
  effect = boot;
}

//Loads Imae Files
public void loadImages() {
  title = loadImage("Title.png"); 
  bird1 = loadImage("Bird1.png");
  bird2 = loadImage("Bird2.png");
  bird3 = loadImage("Bird3.png");
  backgroundCredit1 = loadImage("Credit1.png");
  backgroundCredit2 = loadImage("Credit2.png");
  backgroundCredit3 = loadImage("Credit3.png");
  backgroundCredit4 = loadImage("Credit4.png");
  backgroundTitle = loadImage("backgroundZoom2.png");
  spriteSheet1 = loadImage("spriteSheet1.png");
  character = spriteSheet1.get(0, 0, 32, 48);
  npc1 = spriteSheet1.get(128, 0, 32, 48);
  npc2 = spriteSheet1.get(256, 0, 32, 48);
  npc3 = spriteSheet1.get(256, 192, 32, 48);
  tileSheetA = loadImage("A.png");
  tileSheetB = loadImage("B.png");
  tileSheetC = loadImage("C.png");
  tileSheetD = loadImage("D.png");
  tileSheetE = loadImage("E.png");
  tileSheetF = loadImage("F.png");
  tileSheetG = loadImage("G.png");
  tileSheetH = loadImage("H.png");
  tileSheetI = loadImage("I.png");
  //Gifs
  water = new Gif(this, "water.gif");
  water.loop();
  //Zooms in on images
  imageZoom(backgroundTitle);
  imageZoom( backgroundCredit1);
  imageZoom( backgroundCredit2);
  imageZoom( backgroundCredit3);
  imageZoom( backgroundCredit4);
  imageZoom(tileSheetA);
  imageZoom(tileSheetB);
  imageZoom(tileSheetC);
  imageZoom(tileSheetD);
  imageZoom(tileSheetE);
  imageZoom(tileSheetF);
  imageZoom(tileSheetG);
  imageZoom(tileSheetH);
  imageZoom(tileSheetI);
  imageZoom(npc1);
  imageZoom(npc2);
  imageZoom(npc3);

  bottomBarSimple=loadImage("Backdrop.png");
  dude=loadImage("SampleDude.jpg");
  imageZoom(dude);

  //Common Tiles
  grass = tileSheetB.get(0, 0, 64, 64);
  mound = tileSheetB.get(64*2, 64*6, 64, 64);
  sign = tileSheetF.get(64*1, 64*5, 64, 64);
  street = tileSheetE.get(64*1, 64*6, 64, 64);
  sandbag = tileSheetH.get(64*8, 64*9, 64, 64);
  houseTopL = tileSheetC.get(64*6, 64*6, 64, 64);
  houseTopR = tileSheetC.get(64*7, 64*6, 64, 64);
  houseBotL = tileSheetC.get(64*6, 64*7, 64, 64);
  houseBotR = tileSheetC.get(64*7, 64*7, 64, 64);
  roofTopL = tileSheetC.get(64*6, 64*4, 64, 64);
  roofTopR = tileSheetC.get(64*7, 64*4, 64, 64);
  roofBotL = tileSheetC.get(64*6, 64*5, 64, 64);
  roofBotR = tileSheetC.get(64*7, 64*5, 64, 64);
  innSign = tileSheetF.get(64*4,0,64,64);
}
//Used to resize images
public void imageZoom(PImage i) {
  i.resize(i.width*2, i.height*2);
}
//Load Text Boxes
public void loadText() {
  if (Dialog.size()==0) {
    Dialog.add(new TFextbox( "Welcome to the world of Sekai!", 0, height-80, 50, false, null));//Intro
    Dialog.add(new TFextbox( "Would you like to view the credits?", 0, height-80, 50, true, "Credit NPC"));//npc1
    Dialog.add(new TFextbox( "Would you like to battle?", 0, height-80, 50, true, "Combat NPC"));//npc2
    Dialog.add(new TFextbox( "Your wounds have been healed!", 0, height-80, 50, false, "Healer"));//npc3
  }
}

public void setup() {
  size(640, 480);
  textAlign(CENTER, CENTER);
  minim = new Minim(this);
  loadMusic();
  loadImages();
  loadText();
  testCase();
  gameState = 0;
}

//Text Boxes 
class TFextbox {
  int xpos;
  int ypos;
  String myText;
  String name;
  int delayTime;
  int creationTime;
  int currentIndex;
  boolean isDone;
  boolean hasOptions;
  boolean resetSelected;
  TFextbox( String _myText, int _xpos, int _ypos, int _delayTime, boolean _hasOptions, String _name) {
    this.myText = _myText;
    this.xpos = _xpos;
    this.ypos = _ypos;
    this.delayTime = _delayTime;
    this.hasOptions = _hasOptions;
    this.resetSelected = !this.hasOptions;
    this.currentIndex = 0;
    this.creationTime = 0;
    this. isDone = false;
    this.name = _name;
  }
  void create() {
    if (resetSelected) {
      optionSelected = 0;
      resetSelected = false;
    }
    if (creationTime == 0) {
      creationTime = millis();
    }
    while ( millis () - creationTime > delayTime ) {
      creationTime += delayTime;
      currentIndex+=1;
    }
    textFont(textFont);
    fill( 0, 0, 255);
    stroke(255);
    rect(xpos+20, ypos, width-40, 60);
    if (name!=null) {
      rect(xpos+20, ypos-20, name.length()*16, 20);
    }
    fill(255);
    noStroke();
    textAlign(LEFT, BASELINE);
    if (name!=null) {
      text(name, xpos+20, ypos);
    }
    currentIndex = constrain( currentIndex, 0, myText.length());
    text( myText.substring(0, currentIndex), xpos+40, ypos+22 );
    if (!hasOptions) {
      if (currentIndex>myText.length()-2&&frameCounter>30) {
        text(",", width-42, ypos+58);
        isDone = true;
      }
    } else if (currentIndex>myText.length()-2) {
      if (optionSelected == 0) {
        textAlign(RIGHT);
        text("No", width-42, ypos+58);
        if (frameCounter>30) {
          textAlign(LEFT);
          text("Yes", 42, ypos+58);
        }
      } else {
        textAlign(LEFT);
        text("Yes", 42, ypos+58);
        if (frameCounter>30) {
          textAlign(RIGHT);
          text("No", width-42, ypos+58);
        }
      }
      isDone = true;
    }
    textAlign(CENTER, CENTER);
  }
  void reset() {
    resetSelected = !this.hasOptions;
    isDone = false;
    creationTime = 0;
    currentIndex = 0;
  }
}

public void draw() {
  clear();
  switch(gameState) {
  case 0:
    TitleBoot();
    break;
  case 1://Title Screen
    Title();
    break;
  case 2://Start Screen
    StartScreen();
    break;
  case 3://Overworld
    Overworld();
    break;
  case 4://Battle
    Battle();
    break;
  case -1://Credit Screen
    Credits();
    break;
  default://GameState not programed
    background(255);
    println("Error: gameState failure. Please restart the game.");
    break;
  }
  frameCounter++;
  if (frameCounter==60) {
    frameCounter=0;
  }
}

void stop()
{
  player.close();
  intro.close();
  credit.close();
  boot.close();
  effect.close();
  fanfare.close();
  menuBootEffect.close();
  menuEffect.close();
  error.close();
  cancel.close();
  battle.close();
  overworld.close();
  town.close();
  zoneChange.close();
  minim.stop();
  super.stop();
}

void keyPressed() {
  switch(gameState) {
  case 0:
    if (debug) {
      println("Title Boot");
    }
    break;
  case 1://Title Screen
    keyInputTitle();
    break;
  case 2://Start Screen
    keyInputStart();
    break;
  case 3://Overworld
    keyInputOverworld();
    break;
  case 4://Battle
    keyInputBattle();
    break;
  case -1://Credit Screen
    keyInputCredits();
    break;
  default://GameState not programed
    println("Error: gameState failure");
    break;
  }
}
void keyReleased() {
  if (gameState==3) {//Overworld
    keyReleasedOverworld();
  }
}
