int Choice=100;
int Scenario=100;
int countdown=50;
boolean once=true;
String dead="";
int FightState=0; //0:Fighting 1:loss 2:win
ArrayList<character> TurnOrder= new ArrayList<character>();
ArrayList<player> Party = new ArrayList<player>();
ArrayList<enemy> Ennemies = new ArrayList<enemy>();
ArrayList<String> ItemHolder = new ArrayList<String>();
player personToLevel=null;
int currentItemPosition=0;
int choice;
boolean showDamage=false;
int damageDealt;
String whoGotHit;
String whoHit;
boolean showFlea=false;
boolean showDefense=false;
String who;
boolean choseTarget=false;
boolean Fleing=false;
int totalExp=0;
boolean starting=true;
boolean leveling=false; //to be removed when the return works properly
//function will need to take in an ArrayList<enemy> and an ArrayList<player>

void testCase() {
  player Bob = new player("BUTTBALLS", 5, 5, 5, 1, 100, 100, 1000);
  player Tom = new player("Tom", 8, 3, 5, 1, 100, 100, 1000);
  player Shiro = new player("Shiro", 2, 7, 5, 1, 100, 100, 1000);

  PImage TomPic = spriteSheet1.get(32, 96, 32, 48);
  PImage BobPic = spriteSheet1.get(32, 288, 32, 48);
  PImage ShiroPic = spriteSheet1.get(128, 288, 32, 48);

  imageZoom(BobPic);
  imageZoom(TomPic);
  imageZoom(ShiroPic);

  Bob.battlePicture = BobPic;
  Tom.battlePicture = TomPic;
  Shiro.battlePicture = ShiroPic;

  PImage DragonPic = loadImage("Dragon.png");
  PImage OrcPic = loadImage("Orc.png");
  PImage BullyPic = loadImage("Bully.png");


  enemy Orc = new enemy("Orc", 8, 1, 2, 1, 1, 15, 0, 2000);
  enemy Bully=new enemy("Bully", 1, 1, 1, 1, 1, 50, 0, 2000);
  enemy Dragontwo=new enemy("Dragon", 10, 1, 7, 1, 1, 0, 500, 2000);
  enemy Dragon=new enemy("Dragon", 10, 10, 1, 1, 1, 0, 500, 2000);

  Dragon.battlePicture = DragonPic;
  Dragontwo.battlePicture = DragonPic;
  Orc.battlePicture = OrcPic;
  Bully.battlePicture = BullyPic;


  Ennemies.add(Orc);
  Ennemies.add(Dragon);
  Ennemies.add(Bully);
  Ennemies.add(Dragontwo);

  ItemHolder.add("Item 1");
  ItemHolder.add("Item 2");
  ItemHolder.add("Item 3");
  ItemHolder.add("Item 4");
  ItemHolder.add("Potatoe");

  Tom.addItem(new Weapon("Dagger", 14, 0.67f));
  Bob.addItem(new Weapon("Dagger", 14, 0.67f));
  Tom.addItem(new Weapon("Sword", 12, 0.52f));
  Tom.addItem(new Armour("Cloth Armour", 14, 2));
  Shiro.addItem(new Armour("Chainmail Dress", 6, 20));

  Party.add(Tom);
  Party.add(Bob);
  Party.add(Shiro);
}
public void Battle() {
  //to restore all the settings of the game at startup
  if (FightState==2||FightState==3) {
    if (player!=fanfare) {
      player.pause();
      player=fanfare;
      player.rewind();
      player.play();
    }
  } else {
    if (player!=battle) {
      player.pause();
      player=battle;
      player.rewind();
      player.play();
    }
  }
  if (!player.isPlaying()) { 
    player.rewind();
    player.play();
  }
  if (once==true) {
    faster(Party, Ennemies);
    once=false;
    Choice=100;
    Scenario=100;
    dead="";
    FightState=0; //0:Fighting 1:loss 2:win
    currentItemPosition=0;
    showDamage=false;
    showFlea=false;
    showDefense=false;
    choseTarget=false;
    Fleing=false;
    starting=true;
    leveling=false;
  }
  background(124, 245, 113);
  image(bottomBarSimple, 0, 0);
  drawTurns();
  drawHealthBars();
  drawEnnemies();
  if (starting) {
    drawWelcome();
  }
  if (FightState==0) {
    if (choseTarget) {
      displaychosing();
    }
    if (Fleing) {
      drawEndScreen();
    } else if (showDamage) {
      displaydamage();
    } else if (showFlea) {
      displayflea();
    } else if (showDefense) {
      displayDefense();
    } else if (Choice==1) {
      drawMainScreenS1();
      displayTeamHP();
    } else if (Choice==2) {
      drawMainScreenS2();
      displayTeamHP();
    } else if (Choice==3) {
      drawMainScreenS3();
      displayTeamHP();
    } else if (Choice==4) {
      drawMainScreenS4();
      displayTeamHP();
    }
  } else if (FightState==3) { 
    if (Choice==2) {
      drawMainScreenS2();
      displayTeamHP();
    } else if (Choice==3) {
      drawMainScreenS3();
      displayTeamHP();
    } else if (Choice==4) {
      drawMainScreenS4();
      displayTeamHP();
    }
  } else {
    drawEndScreen();
  }
  if (countdown!=0) {
    fill(0,countdown*5);
    rect(0, 0, width, height);
    countdown--;
  }
}
void faster(ArrayList<player> PlayerParty, ArrayList<enemy> EnnemyParty) {
  for (int i=0; i<PlayerParty.size (); i++) {
    TurnOrder.add(PlayerParty.get(i));
  }
  for (int i=0; i<EnnemyParty.size (); i++) {
    TurnOrder.add(EnnemyParty.get(i));
  }
  character holder= new character();
  for (int i=TurnOrder.size (); i>0; i--) {
    int start=0;
    int index=0;
    for (int j=0; j<i; j++) {
      if (TurnOrder.get(j).agality>start) {
        start=TurnOrder.get(j).agality;
        index=j;
      }
    }
    holder=TurnOrder.get(index);
    TurnOrder.remove(index);
    TurnOrder.add(holder);
  }
}

int firstNotDead() {
  for (int i=0; i<Ennemies.size (); i++) {
    if (Ennemies.get(i).Alive==true) {
      return i+1;
    }
  }
  return 0;
}

void drawTurns() {
  fill(255, 255, 255);
  textAlign(LEFT);
  textFont(turnFont);
  text("Turn Order", 520, 353);
  int dead=0;
  for (int i=0; i<TurnOrder.size (); i++) {
    if (TurnOrder.get(i).Alive==false && i!=0) {
      dead++;
    } else {
      text(TurnOrder.get(i).Name, 520, 363+(i-dead)*10);
    }
  }
  fill(216, 206, 217);
  rect(515, 335, 3, 95);
}
void drawEnnemies() {
  for (int i=0; i<Ennemies.size (); i++) {
    if (i==0 && Ennemies.get(i).Alive==true) {
      if (Ennemies.get(i).battlePicture == null) {
        image(dude, 566, 15);
        image(dude, 502, 15);
      } else {
        image(Ennemies.get(i).battlePicture, 502, 15);
      }
    }
    if (i==1 && Ennemies.get(i).Alive==true) {
      if (Ennemies.get(i).battlePicture == null) {
        image(dude, 566, 165);
        image(dude, 502, 165);
      } else {
        image(Ennemies.get(i).battlePicture, 502, 165);
      }
    }
    if (i==2 && Ennemies.get(i).Alive==true) {
      if (Ennemies.size()==3) {
        if (Ennemies.get(i).battlePicture == null) {
          image(dude, 382, 90);
          image(dude, 318, 90);
        } else {
          image(Ennemies.get(i).battlePicture, 318, 90);
        }
      } else {
        if (Ennemies.get(i).battlePicture == null) {
          image(dude, 382, 15);
          image(dude, 318, 15);
        } else {
          image(Ennemies.get(i).battlePicture, 318, 15);
        }
      }
    }
    if (i==3 && Ennemies.get(i).Alive==true) {
      if (Ennemies.get(i).battlePicture == null) {
        image(dude, 382, 165);
        image(dude, 318, 165);
      } else {
        image(Ennemies.get(i).battlePicture, 318, 165);
      }
    }
  }
}

void drawHealthBars() {
  float lengthBar;
  for (int i=0; i<Party.size (); i++) {
    if (i==0 && Party.get(i).Alive==true) {
      image(Party.get(i).battlePicture, 24, 15);
      fill(255, 255, 255);
      rect(5, 5, 100, 5);
      lengthBar=(float(Party.get(i).currentHP) / float(Party.get(i).hp))*100;
      fill(255, 0, 0);
      rect(5, 5, lengthBar, 5);
      //lenght=length of red rec * currenthealth/max health
    } else if (i==1 && Party.get(i).Alive==true) {
      image(Party.get(i).battlePicture, 24, 165);
      fill(255, 255, 255);
      rect(5, 155, 100, 5);
      lengthBar=(float(Party.get(i).currentHP) / float(Party.get(i).hp))*100;
      fill(255, 0, 0);
      rect(5, 155, lengthBar, 5);
    } else if (i==2 && Party.get(i).Alive==true) {
      image(Party.get(i).battlePicture, 144, 90);
      fill(255, 255, 255);
      rect(125, 80, 100, 5);
      lengthBar=(float(Party.get(i).currentHP) / float(Party.get(i).hp))*100;
      fill(255, 0, 0);
      rect(125, 80, lengthBar, 5);
    }
  }
}

void updateTurns() {
  character holder= new character();
  holder=TurnOrder.get(0);
  TurnOrder.remove(0);
  TurnOrder.add(holder);
  if (TurnOrder.get(0).Alive==false) {
    updateTurns();
  }
}

void autoAttack() { //the ennemy getting hit
  if (TurnOrder.get(0).PersonType=="player") {
    whoHit=TurnOrder.get(0).Name;
    whoGotHit=Ennemies.get(choice).Name;
    damageDealt=TurnOrder.get(0).basicAttack();
    Ennemies.get(choice).attacked(TurnOrder.get(0).basicAttack());
    if (Ennemies.get(choice).Alive==false) {
      dead=Ennemies.get(choice).Name+" has been defeated";
    } else {
      dead="";
    }
  } else {
    int randomlyHit=int(random(0, Party.size()));
    while (Party.get (randomlyHit).Alive!=true) {
      randomlyHit=int(random(0, Party.size()));
    }
    whoHit=TurnOrder.get(0).Name;
    whoGotHit=Party.get(randomlyHit).Name;
    damageDealt=TurnOrder.get(0).basicAttack();
    Party.get(randomlyHit).attacked(TurnOrder.get(0).basicAttack());
    if (Party.get(randomlyHit).Alive==false) {
      dead=Party.get(randomlyHit).Name+" fainted";
    } else {
      dead="";
    }
  }
  checkGameState();
  updateTurns();
  showDamage=true;
  choseTarget=false;
}

void checkGameState() {
  int playerdead=0;
  int cpudead=0;
  for (int i=0; i<TurnOrder.size (); i++) {
    if (TurnOrder.get(i).PersonType=="player" && TurnOrder.get(i).Alive==false) {
      playerdead++;
    } else if (TurnOrder.get(i).PersonType=="enemy" && TurnOrder.get(i).Alive==false) {
      cpudead++;
    }
    if (debug) {
      println(TurnOrder.get(i).Name+"="+TurnOrder.get(i).currentHP);
    }
  }
  if (debug) {
    println("---------");
  }
  if (playerdead==Party.size()) {
    FightState=1;
  } else if (cpudead==Ennemies.size()) {
    FightState=2;
  }
}
void runAway() {
  float allSpeedOfEnnemies=0;
  for (int i=0; i<Ennemies.size (); i++) {
    if (Ennemies.get(i).Alive==true) {
      allSpeedOfEnnemies+=Ennemies.get(i).agality;
    }
  }
  float chancesAtEscaping=chancesAtEscaping=float(TurnOrder.get(0).agality)/allSpeedOfEnnemies*50;
  if (chancesAtEscaping>=random(0, 101)) {
    Fleing=true;
  } else {
    who=TurnOrder.get(0).Name+" has unsuccesfully fled the battle" ;
    showFlea=true;
    checkGameState();
    updateTurns();
  }
}
void checkWhoToLevel() {
  for (int i=0; i<Party.size (); i++) {
    if (Party.get(i).levelDifference!=0) {
      personToLevel=Party.get(i);
    }
  }
  if (personToLevel==null) {
    leveling=false;
    once=true;
    totalExp=0;
    countdown=50;
    gameState = 3;
  }
  Choice=2;
}

void displayTeamHP() {
  fill(255);
  textAlign(LEFT);
  textFont(teamHPfont);
  for (int i=0; i<Party.size (); i++) {
    if (i==0) {
      text(Party.get(i).Name+" "+Party.get(i).currentHP+"/"+Party.get(i).hp, 315, 353, 200, 14);
    } else if (i==1) {
      text(Party.get(i).Name+" "+Party.get(i).currentHP+"/"+Party.get(i).hp, 315, 373, 200, 14);
    } else if (i==2) {
      text(Party.get(i).Name+" "+Party.get(i).currentHP+"/"+Party.get(i).hp, 315, 395, 200, 14);
    }
  }
}

void displaydamage() {
  fill(255, 255, 255);
  textAlign(CENTER, CENTER);
  textFont(commentFont);
  text(whoHit+" hit "+whoGotHit+" for "+damageDealt, 25, 350, 489, 18);
  text(dead, 25, 375, 489, 18);
}

void displayflea() {
  fill(255);
  textFont(commentFont);
  textAlign(CENTER, CENTER);
  text(who, 25, 350, 489, 18);
}
void drawWelcome() {
  fill(255, 255, 255);
  textFont(commentFont);
  textAlign(CENTER, CENTER);
  text("Prepare for Battle", 25, 350, 489, 18);
}
void displayDefense() {
  fill(255, 255, 255);
  textFont(commentFont);
  textAlign(CENTER, CENTER);
  text(who+" has taken a defensive", 25, 350, 489, 18);
  text("stance!", 25, 375, 489, 18);
}
void drawEndScreen() {
  fill(255, 255, 255);
  textFont(commentFont);
  textAlign(CENTER, CENTER);
  if (FightState==1) {
    text("You Have Lost The Battle.", 25, 350, 489, 18);
    gold = gold/2;
    interactionState = -1;
  } else if (Fleing) {
    text("You Have Fled The Battle.", 25, 350, 489, 18);
  } else if (FightState==2) {
    text("You Have Won The Battle!", 25, 350, 489, 18);
  }
}
void displaychosing() {
  fill(255, 133, 53);
  if (Choice==1) {
    triangle(566, 15, 561, 0, 571, 0);
  } else if (Choice==2) {
    triangle(566, 165, 561, 150, 571, 150);
  } else if (Choice==3) {
    if (Scenario==10) {
      triangle(382, 90, 377, 75, 387, 75);
    } else {
      triangle(382, 15, 377, 0, 387, 0);
    }
  } else if (Choice==4) {
    triangle(382, 165, 377, 150, 387, 150);
  }
}
void drawMainScreenS1() {
  fill(235, 201, 4);
  rect(30, 345, 275, 15);
  fill(255);
  rect(34, 349, 267, 7);
  rect(30, 365, 275, 15);
  rect(30, 385, 275, 15);
  rect(30, 405, 275, 15);
  if (FightState==3) {
    drawLevelUpScreen();
  } else if (Scenario==0) {
    drawOptionsSZero();
  } else if (Scenario==1) {
    drawOptionSOne();
  } else if (Scenario==2) {
    drawOptionSTwo();
  } else if (Scenario==10 || Scenario==11 || Scenario==12) {
    drawEnnemiesNames();
  } else if (Scenario==9) {
    drawItems();
  }
}
void drawMainScreenS2() {
  fill(235, 201, 4);
  rect(30, 365, 275, 15);
  fill(255);
  rect(34, 369, 267, 7);
  rect(30, 345, 275, 15);
  rect(30, 385, 275, 15);
  rect(30, 405, 275, 15);
  if (FightState==3) {
    drawLevelUpScreen();
  } else if (Scenario==0) {
    drawOptionsSZero();
  } else if (Scenario==1) {
    drawOptionSOne();
  } else if (Scenario==2) {
    drawOptionSTwo();
  } else if (Scenario==10 || Scenario==11 || Scenario==12) {
    drawEnnemiesNames();
  } else if (Scenario==9) {
    drawItems();
  }
}
void drawMainScreenS3() {
  fill(235, 201, 4);
  rect(30, 385, 275, 15);
  fill(255);
  rect(34, 389, 267, 7);
  rect(30, 345, 275, 15);
  rect(30, 365, 275, 15);
  rect(30, 405, 275, 15);
  if (FightState==3) {
    drawLevelUpScreen();
  } else if (Scenario==0) {
    drawOptionsSZero();
  } else if (Scenario==2) {
    drawOptionSTwo();
  } else if (Scenario==10 || Scenario==11 || Scenario==12) {
    drawEnnemiesNames();
  } else if (Scenario==9) {
    drawItems();
  }
}
void drawMainScreenS4() {
  fill(235, 201, 4);
  rect(30, 405, 275, 15);
  fill(255);
  rect(34, 409, 267, 7);
  rect(30, 345, 275, 15);
  rect(30, 365, 275, 15);
  rect(30, 385, 275, 15);
  if (FightState==3) {
    drawLevelUpScreen();
  } else if (Scenario==0) {
    drawOptionsSZero();
  } else if (Scenario==2) {
    drawOptionSTwo();
  } else if (Scenario==10 || Scenario==11 || Scenario==12) {
    drawEnnemiesNames();
  } else if (Scenario==9) {
    drawItems();
  }
}
void drawLevelUpScreen() {
  fill(0);
  textFont(turnFont);
  textAlign(LEFT, CENTER);
  text("Leveling up "+personToLevel.Name, 35, 345, 275, 15);
  text(personToLevel.strength+" | Strength + 1", 35, 365, 275, 15);
  text(personToLevel.agality+" | Agility + 1", 35, 385, 275, 15);
  text(personToLevel.intellect+" | Intellect + 1", 35, 405, 275, 15);
}
void drawOptionsSZero() {
  fill(0);
  textFont(turnFont);
  textAlign(LEFT, CENTER);
  text("Attack", 35, 345, 275, 15);
  text("Defend", 35, 365, 275, 15);
  text("Items (In Developement)", 35, 385, 275, 15);
  text("Run", 35, 405, 275, 15);
}
void drawOptionSOne() {
  fill(0);
  textFont(turnFont);
  textAlign(LEFT, CENTER);
  text("Auto-Attack", 35, 345, 275, 15);
  text("Skills (Coming Soon)", 35, 365, 275, 15);
}
void drawOptionSTwo() {
  fill(0);
  textFont(turnFont);
  textAlign(LEFT, CENTER);
  text("Skill 1", 35, 345, 275, 15);
  text("Skill 2", 35, 365, 275, 15);
  text("Skill 3", 35, 385, 275, 15);
  text("Skill 4", 35, 405, 275, 15);
}
void drawEnnemiesNames() {
  fill(0);
  textFont(turnFont);
  textAlign(LEFT, CENTER);
  for (int i=0; i<Ennemies.size (); i++) {
    if (i==0 && Ennemies.get(i).Alive) {
      text(Ennemies.get(i).Name, 35, 345, 275, 15);
    } else if (i==1 && Ennemies.get(i).Alive) {
      text(Ennemies.get(i).Name, 35, 365, 275, 15);
    } else if (i==2 && Ennemies.get(i).Alive) {
      text(Ennemies.get(i).Name, 35, 385, 275, 15);
    } else if (i==3 && Ennemies.get(i).Alive) {
      text(Ennemies.get(i).Name, 35, 405, 275, 15);
    }
  }
}
void drawItems() {
  fill(0);
  textFont(turnFont);
  textAlign(LEFT, CENTER);
  if (currentItemPosition<ItemHolder.size()) {
    text(ItemHolder.get(currentItemPosition), 35, 345, 275, 15);
  }
  if (currentItemPosition+1<ItemHolder.size()) {
    text(ItemHolder.get(currentItemPosition+1), 35, 365, 275, 15);
  }
  if (currentItemPosition+2<ItemHolder.size()) {
    text(ItemHolder.get(currentItemPosition+2), 35, 385, 275, 15);
  }
  if (currentItemPosition+3<ItemHolder.size()) {
    text(ItemHolder.get(currentItemPosition+3), 35, 405, 275, 15);
  }
  fill(255);
  if (currentItemPosition>0) {
    triangle(309, 350, 324, 350, 316.5, 340);
  }
  if (currentItemPosition+4<ItemHolder.size()) {
    triangle(309, 415, 324, 415, 316.5, 425);
  }
}
void keyInputBattle() {
  if (countdown==0) {
    if (key!=secondaryKey&&(key==primaryKey||key=='w'||key=='s')) {
      menuEffect.rewind();
      menuEffect.play();
    } else if (key==secondaryKey&&Scenario!=0&&FightState==3) {
      cancel.rewind();
      cancel.play();
    }
    if (starting) {
      starting=false;
      checkGameState();
      if (TurnOrder.size()!=0&&TurnOrder.get(0).PersonType!="player") {
        autoAttack();
      } else {
        Scenario=0;
        Choice=1;
      }
    } else if (Fleing) {
      TurnOrder.clear();
      once=true;
      countdown=50;
      gameState = 3;
      Ennemies.clear();
    } else if (FightState==0) {

      if (TurnOrder.get(0).PersonType=="player") {

        if (TurnOrder.get(0).Defence) {
          TurnOrder.get(0).Defence=false;
        }
        if (showDamage==true) {
          showDamage=false;
          Scenario=0;
          Choice=1;
        } else if (showFlea==true) {
          showFlea=false;
          Scenario=0;
          Choice=1;
        } else if (showDefense==true) {
          showDefense=false;
          Scenario=0;
          Choice=1;
        } else if (key=='s' && Scenario==0 && Choice==1) {
          Choice=2;
        } else if (key=='s' && Scenario==0 && Choice==2) {
          Choice=3;
        } else if (key=='s' && Scenario==0 && Choice==3) {
          Choice=4;
        } else if (key=='w' && Scenario==0 && Choice==4) {
          Choice=3;
        } else if (key=='w' && Scenario==0 && Choice==3) {
          Choice=2;
        } else if (key=='w' && Scenario==0 && Choice==2) {
          Choice=1;
        } else if (key==primaryKey && Scenario==0 && Choice==1) {
          Scenario=1;
        } else if (key==primaryKey && Scenario==0 && Choice==2) {
          TurnOrder.get(0).Defence=true;
          showDefense=true;
          who=TurnOrder.get(0).Name;
          updateTurns();
        } else if (key==primaryKey && Scenario==0 && Choice==3) {
          Scenario=9;
          Choice=1;
          //using items
        } else if (key==primaryKey && Scenario==0 && Choice==4) {
          runAway();
        }
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //scenario 1
        else if (key=='s' && Scenario==1 && Choice==1) {
          Choice=2;
        } else if (key=='w' && Scenario==1 && Choice==2) {
          Choice=1;
        } else if (key==primaryKey && Scenario==1 && Choice==1) {
          if (Ennemies.size()==1) {
            choice=0;
            autoAttack();
          } else if (Ennemies.size()==2) {
            Scenario=12;
            choseTarget=true;
            Choice=firstNotDead();
          } else if (Ennemies.size()==3) {
            Scenario=10;
            choseTarget=true;
            Choice=firstNotDead();
          } else {
            Scenario=11;
            choseTarget=true;
            Choice=firstNotDead();
          }
        } else if (key==primaryKey && Scenario==1 && Choice==2) {
          Scenario=2;
          Choice=1;
        } else if (key==secondaryKey && Scenario==1) {
          Scenario=0;
          Choice=1;
        }
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //scenario 2
        else if (key=='s' && Scenario==2 && Choice==1) {
          Choice=2;
        } else if (key=='s' && Scenario==2 && Choice==2) {
          Choice=3;
        } else if (key=='s' && Scenario==2 && Choice==3) {
          Choice=4;
        } else if (key=='w' && Scenario==2 && Choice==4) {
          Choice=3;
        } else if (key=='w' && Scenario==2 && Choice==3) {
          Choice=2;
        } else if (key=='w' && Scenario==2 && Choice==2) {
          Choice=1;
        } else if (key==primaryKey && Scenario==2 && Choice==1) {
          //Skill 1
        } else if (key==primaryKey && Scenario==2 && Choice==2) {
          //Skill 2
        } else if (key==primaryKey && Scenario==2 && Choice==3) {
          //Skill 3
        } else if (key==primaryKey && Scenario==2 && Choice==4) {
          //Skill 4
        } else if (key==secondaryKey && Scenario==2) {
          Scenario=1;
          Choice=1;
        }
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        //chosing items
        else if (key=='s' && Scenario==9 && Choice==1 && currentItemPosition+Choice<ItemHolder.size()) {
          Choice=2;
        } else if (key=='s' && Scenario==9 && Choice==2 && currentItemPosition+Choice<ItemHolder.size()) {
          Choice=3;
        } else if (key=='s' && Scenario==9 && Choice==3 && currentItemPosition+Choice<ItemHolder.size()) {
          Choice=4;
        } else if (key=='s' && Scenario==9 && Choice==4 && currentItemPosition+Choice<ItemHolder.size()) {
          currentItemPosition+=1;
        } else if (key=='w' && Scenario==9 && Choice==4) {
          Choice=3;
        } else if (key=='w' && Scenario==9 && Choice==3) {
          Choice=2;
        } else if (key=='w' && Scenario==9 && Choice==2) {
          Choice=1;
        } else if (key=='w' && Scenario==9 && Choice==1 && currentItemPosition+Choice>1) {
          currentItemPosition-=1;
        } else if (key==secondaryKey && Scenario==9) {
          Scenario=0;
          Choice=1;
        }
        //------------------------------------------------------------------------------------------------------------------------
        // auto attacking 2 ennemies
        else if (key=='s' && Scenario==12 && Choice==1 && Ennemies.get(1).Alive==true) {
          Choice=2;
        } else if (key=='w' && Scenario==12 && Choice==2 && Ennemies.get(0).Alive==true) {
          Choice=1;
        } else if (key==primaryKey && Scenario==12 && Choice==1) {
          choice=0;
          autoAttack();
        } else if (key==primaryKey && Scenario==12 && Choice==2) {
          choice=1;
          autoAttack();
        } else if (key==secondaryKey && Scenario==12) {
          Scenario=1;
          Choice=1;
          choseTarget=false;
        }
        //-----------------------------------------------------------------------------------------------------------------------
        // auto attacking 3 ennemies
        else if (key=='s' && Scenario==10 && Choice==1 && Ennemies.get(1).Alive==true) {
          Choice=2;
        } else if (key=='s' && Scenario==10 && Choice==1 && Ennemies.get(1).Alive==true) {
          Choice=3;
        } else if (key=='s' && Scenario==10 && Choice==2 && Ennemies.get(2).Alive==true) {
          Choice=3;
        } else if (key=='w' && Scenario==10 && Choice==3 && Ennemies.get(1).Alive==true) {
          Choice=2;
        } else if (key=='w' && Scenario==10 && Choice==3 && Ennemies.get(0).Alive==true) {
          Choice=1;
        } else if (key=='w' && Scenario==10 && Choice==2 && Ennemies.get(0).Alive==true) {
          Choice=1;
        } else if (key==primaryKey && Scenario==10 && Choice==1) {
          choice=0;
          autoAttack();
        } else if (key==primaryKey && Scenario==10 && Choice==2) {
          choice=1;
          autoAttack();
        } else if (key==primaryKey && Scenario==10 && Choice==3) {
          choice=2;
          autoAttack();
        } else if (key==secondaryKey && Scenario==10) {
          Scenario=1;
          Choice=1;
          choseTarget=false;
        }
        //-----------------------------------------------------------------------------------------------------------------------
        // auto attacking 4 ennemies
        else if (key=='s' && Scenario==11 && Choice==1 && Ennemies.get(1).Alive==true) {
          Choice=2;
        } else if (key=='s' && Scenario==11 && Choice==1 && Ennemies.get(2).Alive==true) {
          Choice=3;
        } else if (key=='s' && Scenario==11 && Choice==1 && Ennemies.get(3).Alive==true) {
          Choice=4;
        } else if (key=='s' && Scenario==11 && Choice==2 && Ennemies.get(2).Alive==true) {
          Choice=3;
        } else if (key=='s' && Scenario==11 && Choice==2 && Ennemies.get(3).Alive==true) {
          Choice=4;
        } else if (key=='s' && Scenario==11 && Choice==3 && Ennemies.get(3).Alive==true) {
          Choice=4;
        } else if (key=='w' && Scenario==11 && Choice==4 && Ennemies.get(2).Alive==true) {
          Choice=3;
        } else if (key=='w' && Scenario==11 && Choice==4 && Ennemies.get(1).Alive==true) {
          Choice=2;
        } else if (key=='w' && Scenario==11 && Choice==4 && Ennemies.get(0).Alive==true) {
          Choice=1;
        } else if (key=='w' && Scenario==11 && Choice==3 && Ennemies.get(1).Alive==true) {
          Choice=2;
        } else if (key=='w' && Scenario==11 && Choice==3 && Ennemies.get(0).Alive==true) {
          Choice=1;
        } else if (key=='w' && Scenario==11 && Choice==2 && Ennemies.get(0).Alive==true) {
          Choice=1;
        } else if (key==primaryKey && Scenario==11 && Choice==1) {
          choice=0;
          autoAttack();
        } else if (key==primaryKey && Scenario==11 && Choice==2) {
          choice=1;
          autoAttack();
        } else if (key==primaryKey && Scenario==11 && Choice==3) {
          choice=2;
          autoAttack();
        } else if (key==primaryKey && Scenario==11 && Choice==4) {
          choice=3;
          autoAttack();
        } else if (key==secondaryKey && Scenario==11) {
          Scenario=1;
          Choice=1;
          choseTarget=false;
        }
      } else {
        if (showFlea==true) {
          showFlea=false;
          Scenario=20;
          autoAttack();
        } else if (showDamage==true) {
          showDamage=false;
          autoAttack();
        } else if (showDefense==true) {
          showDefense=false;
          Scenario=20;
          autoAttack();
        } else {
          autoAttack();
        }
      }
    } else if (FightState==1) {
      Ennemies.clear();
      TurnOrder.clear();
      once=true;
      countdown=50;
      gameState = 3;
    } else if (FightState==2) {//win
      for (int i=0; i<Ennemies.size (); i++) {
        gold+=Ennemies.get(i).gold;
        totalExp+=Ennemies.get(i).experience;
      }
      Ennemies.clear();
      TurnOrder.clear();
      int alive=0;
      for (int i=0; i<Party.size (); i++) {
        if (Party.get(i).Alive) {
          alive+=1;
        }
      }
      for (int i=0; i<Party.size (); i++) {
        if (Party.get(i).Alive) {
          Party.get(i).experience+=(totalExp/alive);
          Party.get(i).levelCheck();
        }
      }
      if (leveling==false) {
        once=true;
        countdown=50;
        gameState = 3;
      } else {
        FightState=3;
        Choice=2;
        checkWhoToLevel();
      }
    } else if (FightState==3) {
      if (key=='s' && Choice==2) {
        Choice=3;
      } else if (key=='s' && Choice==3) {
        Choice=4;
      } else if (key=='w'&& Choice==4) {
        Choice=3;
      } else if (key=='w' && Choice==3) {
        Choice=2;
      } else if (key==primaryKey && Choice==2) {
        personToLevel.strength++;
        personToLevel.hp+=10;
        personToLevel.currentHP=personToLevel.hp;
        personToLevel.levelDifference--;
        personToLevel=null;
        checkWhoToLevel();
      } else if (key==primaryKey && Choice==3) {
        personToLevel.agality++;
        personToLevel.levelDifference--;
        personToLevel.hp+=10;
        personToLevel.currentHP=personToLevel.hp;
        personToLevel=null;
        checkWhoToLevel();
      } else if (key==primaryKey && Choice==4) {
        personToLevel.intellect++;
        personToLevel.levelDifference--;
        personToLevel.hp+=10;
        personToLevel.currentHP=personToLevel.hp;
        personToLevel=null;
        checkWhoToLevel();
      }
    }
  }
}
