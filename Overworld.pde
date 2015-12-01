int overworldX = 0;
int overworldY = 0;
char dir = 'd';
boolean canMove = true;
boolean isMoving = false;
int characterState = 0; 
int zone = 1;
int charselected = 0;
int invselected = 1;
int itemselected = 0;
/*
Zone List 
 0 == feild;
 1 == town;
 */
int interactionState = 0;
boolean charChanged = true;
ArrayList<collision> collisions = new ArrayList<collision>();
ArrayList<interaction> interactions = new ArrayList<interaction>();
ArrayList<battleZone> battleZones = new ArrayList<battleZone>();
boolean paused = false;
int pausedMenu = 0;
ArrayList<String> pauseMenuOptions = new ArrayList<String>();
public void Overworld() {
  if (paused) {
    pausedMenu();
  } else {
    movement();
    display();
    if (charChanged) {
      imageZoom(character);
      charChanged=false;
    }
    image(character, width/2, height/2-48);
    if (debug) {
      println(overworldX + ',' + overworldY);
    }
    if (interactionState>0) {
      Dialog.get(interactionState).create();
    } else if (interactionState<0) {
      switch(interactionState) {
      case -1:
        zone = 1;
        zoneChange.rewind();
        zoneChange.play();
        overworldX=0;
        overworldY=0;
        break;
      case -2:
        zone = 0;
        zoneChange.rewind();
        zoneChange.play();
        overworldX=0;
        overworldY=0;
        break;
      }
      interactionState = 0;
      canMove = true;
    }
  }
}
public void display() {
  switch(zone) {
    //Overworld
  case 0: 
    if (player!=overworld) {
      player.pause();
      player=overworld;
      player.rewind();
      player.play();
    }
    if (!player.isPlaying()) { 
      player.rewind();
      player.play();
    }
    collisions.clear();
    interactions.clear();
    battleZones.clear();
    //Draws World Map
    for (int x = -10; x<20; x++) {
      for (int y = -10; y<20; y++) {
        if (overworldX+(64*x)<0||overworldX+(64*x)>width||overworldY+(64*y)<-32||overworldY+(64*y)>height+32) {
        } else {
          if (y<-4||y>11||x<-4||x>13) {
            image(water, overworldX+(64*x), overworldY+(64*y));
            image(water, overworldX+(64*x)+32, overworldY+(64*y));
            image(water, overworldX+(64*x)+32, overworldY+(64*y)+32);
            image(water, overworldX+(64*x), overworldY+(64*y)+32);
            collision tmp = new collision (overworldX+(64*x), overworldY+(64*y));
            collisions.add(tmp);
          } else if (y==-4||y==11||x==-4) {
            image(mound, overworldX+(64*x), overworldY+(64*y));
            collisions.add(new collision (overworldX+(64*x), overworldY+(64 *y)));
          } else {
            image(grass, overworldX+(64*x), overworldY+(64*y));
            battleZones.add(new battleZone(overworldX+(64*x), overworldY+(64*y), 1, 20));
          }
        }
      }
    }
    //Overlay Objects
    //Credits
    image(npc1, overworldX, overworldY-128);
    collisions.add(new collision (overworldX, overworldY-128));
    collisions.add(new collision (overworldX, overworldY-160));
    interactions.add(new interaction (overworldX, overworldY-128, 1));
    //Battle
    image(npc2, overworldX+128, overworldY-128);
    collisions.add(new collision (overworldX+128, overworldY-128));
    collisions.add(new collision (overworldX+128, overworldY-160));
    interactions.add(new interaction (overworldX+128, overworldY-128, 2));
    //Town
    image(sign, overworldX-64*3, overworldY);
    collisions.add(new collision (overworldX-64*3, overworldY));
    interactions.add(new interaction (overworldX-64*3, overworldY, -1));
    break;
    //Town
  case 1: 
    if (player!=town) {
      player.pause();
      player=town;
      player.rewind();
      player.play();
    }
    if (!player.isPlaying()) { 
      player.rewind();
      player.play();
    }
    collisions.clear();
    interactions.clear();
    battleZones.clear();
    for (int x = -10; x<20; x++) {
      for (int y = -10; y<20; y++) {
        if (overworldX+(64*x)<0||overworldX+(64*x)>width||overworldY+(64*y)<-32||overworldY+(64*y)>height+32) {
        } else {
          if (y<-4||y>11||x<-4||x>13) {
            image(water, overworldX+(64*x), overworldY+(64*y));
            image(water, overworldX+(64*x)+32, overworldY+(64*y));
            image(water, overworldX+(64*x)+32, overworldY+(64*y)+32);
            image(water, overworldX+(64*x), overworldY+(64*y)+32);
            collision tmp = new collision (overworldX+(64*x), overworldY+(64*y));
            collisions.add(tmp);
          } else if (y==-4||y==11||x==-4) {
            image(grass, overworldX+(64*x), overworldY+(64*y));
            image(sandbag, overworldX+(64*x), overworldY+(64*y));
            collisions.add(new collision (overworldX+(64*x), overworldY+(64 *y)));
          } else if (y==-3) {
            if (x%2!=0) {
              image(roofTopL, overworldX+(64*x), overworldY+(64*y));
            } else {
              image(roofTopR, overworldX+(64*x), overworldY+(64*y));
            }
            collisions.add(new collision (overworldX+(64*x), overworldY+(64 *y)));
          } else if (y==-2) {
            if (x%2!=0) {
              image(roofBotL, overworldX+(64*x), overworldY+(64*y));
            } else {
              image(roofBotR, overworldX+(64*x), overworldY+(64*y));
            }
            collisions.add(new collision (overworldX+(64*x), overworldY+(64 *y)));
          } else if (y==-1) {
            if (x%2!=0) {
              image(houseTopL, overworldX+(64*x), overworldY+(64*y));
            } else {
              image(houseTopR, overworldX+(64*x), overworldY+(64*y));
            }
            if (x==6) {
              image(innSign, overworldX+(64*x), overworldY+(64*y));
            }
            collisions.add(new collision (overworldX+(64*x), overworldY+(64 *y)));
          } else if (y==0) {
            if (x%2!=0) {
              image(houseBotL, overworldX+(64*x), overworldY+(64*y));
            } else {
              image(houseBotR, overworldX+(64*x), overworldY+(64*y));
            }
            collisions.add(new collision (overworldX+(64*x), overworldY+(64 *y)));
          } else {
            image(street, overworldX+(64*x), overworldY+(64*y));
          }
        }
      }
    }
    //Overlay Objects
    //Battle Test
    /*
    image(mound, overworldX-(64*3), overworldY);
     battleZones.add(new battleZone(overworldX-(64*3), overworldY, 1, 100));
     */
    //Healing
    image(npc3, overworldX-128, overworldY);
    collisions.add(new collision (overworldX-128, overworldY));
    collisions.add(new collision (overworldX-128, overworldY-160+128));
    interactions.add(new interaction (overworldX-128, overworldY, 3));
    //Overworld
    image(sign, overworldX+64*3, overworldY);
    collisions.add(new collision (overworldX+64*3, overworldY));
    interactions.add(new interaction (overworldX+64*3, overworldY, -2));
    break;
  }
}
public boolean collisionCheck() {
  switch(dir) {
  case 'd':
    for (int i = collisions.size ()-1; i >= 0; i--) {
      if (width/2 == collisions.get(i).x&&height/2+48== collisions.get(i).y) {
        return false;
      }
    }
    break;
  case 'u':
    for (int i = collisions.size ()-1; i >= 0; i--) {
      if (width/2 == collisions.get(i).x&&height/2-80 == collisions.get(i).y) {
        return false;
      }
    }
    break;
  case 'l':
    for (int i = collisions.size ()-1; i >= 0; i--) {
      if (width/2-64 == collisions.get(i).x&&(height/2-16 == collisions.get(i).y||height/2-16-collisions.get(i).y==32||height/2-16-collisions.get(i).y==3)) {
        return false;
      }
    }
    break;
  case 'r':
    for (int i = collisions.size ()-1; i >= 0; i--) {
      if (width/2+64 == collisions.get(i).x&&(height/2-16 == collisions.get(i).y||height/2-16-collisions.get(i).y==32||height/2-16-collisions.get(i).y==32)) {
        return false;
      }
    }
    break;
  }
  return true;
}
public int battleZoneCheck() {
  for (int i = battleZones.size ()-1; i >= 0; i--) {
    if (debug) {
      println((width/2) + " Screen Mid " + (height/2-48));
      println(battleZones.get(i).x + " Battle Zone " + battleZones.get(i).y);
      println("___________________________________________________________");
    }
    if (width/2 == battleZones.get(i).x && height/2-16== battleZones.get(i).y) {
      return i;
    }
  }
  return -1;
}
public int interactionCheck() {
  switch(dir) {
  case 'd':
    for (int i = interactions.size ()-1; i >= 0; i--) {
      if (width/2 == interactions.get(i).x&&height/2+48== interactions.get(i).y) {
        return i;
      }
    }
    break;
  case 'u':
    for (int i = interactions.size ()-1; i >= 0; i--) {
      if (width/2 == interactions.get(i).x&&height/2-80 == interactions.get(i).y) {
        return i;
      }
    }
    break;
  case 'l':
    for (int i = interactions.size ()-1; i >= 0; i--) {
      if (width/2-64 == interactions.get(i).x&&(height/2-16 == interactions.get(i).y||height/2-16-interactions.get(i).y==32||height/2-16-interactions.get(i).y==3)) {
        return i;
      }
    }
    break;
  case 'r':
    for (int i = interactions.size ()-1; i >= 0; i--) {
      if (width/2+64 == interactions.get(i).x&&(height/2-16 == interactions.get(i).y||height/2-16-interactions.get(i).y==32||height/2-16-interactions.get(i).y==32)) {
        return i;
      }
    }
    break;
  }
  return -1;
}
public void movement() {
  if (canMove&&isMoving&&battleZoneCheck()!=-1&&frameCount%20==0) {
    int chance = int(random(100));
    if (chance<battleZones.get(battleZoneCheck()).rate) {
      isMoving = false;
      Ennemies.clear();
      switch(battleZones.get(battleZoneCheck()).type) {
      case 1:
        PImage OrcPic = loadImage("Orc.png");
        for (int i = int (random (1, 4)); i>0; i--) {
          int level = int(random(4, 10));
          enemy tmp = new enemy("Orc", 3, level, level, level, level*10, 0, int(random(0, 225)), level*90);
          /*
          enemy(String n, int i, int a, int s, int l, int h, int m, int g, int e) {
           this.Name=n;
           this.intellect=i;
           this.agality=a;
           this.strength=s;
           this.level=l;
           this.hp=h;
           this.currentHP=h;
           this.mana=m;
           this.currentMana=m;
           this.gold=g;
           this.PersonType="enemy";
           this.experience=e;
           }
           */
          tmp.battlePicture = OrcPic;
          Ennemies.add(tmp);
        }
        break;
      }
      gameState = 4;
    }
  }
  if (isMoving&&canMove) {
    if (frameCount%10==0) {
      switch(dir) {
      case 'd':
        charChanged=true;
        if (collisionCheck()) {
          overworldY-=32;
        } else {
          error.rewind();
          error.play();
        }
        if (characterState == 0) {
          character = spriteSheet1.get(32, 0, 32, 48);
          characterState = 1;
        } else if (characterState == 1) {
          characterState = 2;
          character = spriteSheet1.get(64, 0, 32, 48);
        } else {
          characterState = 0;
          character = spriteSheet1.get(0, 0, 32, 48);
        }
        break;
      case 'l':
        charChanged=true;  
        if (collisionCheck()) {
          overworldX+=64;
        } else {
          error.rewind();
          error.play();
        }
        if (characterState == 0) {
          character = spriteSheet1.get(32, 48, 32, 48);
          characterState = 1;
        } else if (characterState == 1) {
          characterState = 2;
          character = spriteSheet1.get(64, 48, 32, 48);
        } else {
          characterState = 0;
          character = spriteSheet1.get(0, 48, 32, 48);
        }
        break;
      case 'r':        
        charChanged=true; 
        if (collisionCheck()) { 
          overworldX-=64;
        } else {
          error.rewind();
          error.play();
        }
        if (characterState == 0) {
          character = spriteSheet1.get(32, 96, 32, 48);
          characterState = 1;
        } else if (characterState == 1) {
          characterState = 2;
          character = spriteSheet1.get(64, 96, 32, 48);
        } else {
          characterState = 0;
          character = spriteSheet1.get(0, 96, 32, 48);
        }
        break;
      case 'u':
        charChanged=true;  
        if (collisionCheck()) {
          overworldY+=32;
        } else {
          error.rewind();
          error.play();
        }
        if (characterState == 0) {
          character = spriteSheet1.get(32, 144, 32, 48);
          characterState = 1;
        } else if (characterState == 1) {
          characterState = 2;
          character = spriteSheet1.get(64, 144, 32, 48);
        } else {
          characterState = 0;
          character = spriteSheet1.get(0, 144, 32, 48);
        }
        break;
      }
    }
  }
}
public void pausedMenu() {
  background(255);
  textFont(textFont);
  fill(0);
  pauseMenuOptions.clear();
  switch(pausedMenu) {
  case 0:
    pauseMenuOptions.add("Characters");
    pauseMenuOptions.add("Inventory");
    pauseMenuOptions.add("Save");
    fill(23, 30, 193);
    rect(0, 0, width/4, height);
    for (int i = 1; i <= pauseMenuOptions.size (); i ++) {
      fill(20, 20, 20);
      if (i == optionSelected+1) 
      {
        fill(255, 0, 0);
      }
      rect(0, height*i/pauseMenuOptions.size() - height/pauseMenuOptions.size(), width/4, height/16);
      fill(255);
      textAlign(CENTER, CENTER);
      text(pauseMenuOptions.get(i - 1), width/4 - width/8, height*i/pauseMenuOptions.size() - height/pauseMenuOptions.size() + height/32);
    }
    fill(0);
    textFont(creditFont);
    text("Gold: " + gold, width/2, height/2);
    textFont(menuFont);
    break;
  case 1:
    CharScreen();
    break;
  case 2:
    Inventory();
    break;
  case 3:
    text("This feature will be avaliable" + '\n' + "a in future update", width/2, height/2);
    break;
  }
}
public void keyInputOverworld() {
  if (debug) {
    println("Overworld");
  }
  if (canMove) {
    switch(key) {
    case 'w':
      if (dir!='u') {
        dir='u';
      }
      isMoving = true;
      break;
    case 'a':
      if (dir!='l') {
        dir='l';
      }
      isMoving = true;
      break;
    case's':
      if (dir!='d') {
        dir='d';
      } 
      isMoving = true;
      break;
    case 'd':
      if (dir!='r') {
        dir='r';
      } 
      isMoving = true;
      break;
    }
    if (keyCode == ENTER) {
      menuBootEffect.rewind();
      menuBootEffect.play();
      player.pause();
      paused = true;
      canMove = false;
      optionSelected = 0;
      invselected = 1;
    }
    if (key == primaryKey) {
      if (interactionCheck()!=-1) {
        interactionState = interactions.get(interactionCheck()).state;
        canMove = false;
      }
    }
  } else {
    if (keyCode == ENTER&&paused&&pausedMenu==0) {
      player.play();
      paused = false;
      canMove = true;
    } 
    if (key == secondaryKey) {
      if (paused) {
        if (pausedMenu!=0) {
          pausedMenu=0;
          cancel.rewind();
          cancel.play();
        }
      }
      if (interactionState>0) {
        if (Dialog.get(interactionState).isDone) {
          Dialog.get(interactionState).reset();
          cancel.rewind();
          cancel.play();
          interactionState = 0;
          canMove = true;
        }
      }
    }
    if (key == primaryKey) {
      if (paused) {
        menuEffect.rewind();
        menuEffect.play();
        if (pausedMenu == 0) {
          switch(optionSelected) {
          case 0:
            pausedMenu = 1;
            optionSelected = 0;
            break;
          case 1:
            pausedMenu = 2;
            optionSelected = 0;
            invselected = 1;
            break;
          case 2:
            pausedMenu = 3;
            optionSelected = 0;
            break;
          }
        } else if (pausedMenu == 2) {
          for (int i = 1; i <= 3; i ++) {
            if (invselected == i && itemselected > 0) {
              Party.get(i-1).swapEquipped(itemselected - 1);
            }
          }
        }
      }
      if (interactionState>0) {
        if (Dialog.get(interactionState).isDone) {
          Dialog.get(interactionState).reset();
          menuEffect.rewind();
          menuEffect.play();
          canMove = true;
          if (interactionState == 1&&optionSelected == 0) {
            interactionState = 0;
            gameState = -1;
          } else if (interactionState == 2 && optionSelected == 0)
          {
            interactionState = 0;
            Ennemies.clear();

            PImage DragonPic = loadImage("Dragon.png");
            PImage OrcPic = loadImage("Orc.png");
            PImage BullyPic = loadImage("Bully.png");


            enemy Orc = new enemy("Orc", 8, 1, 2, 1, 80, 15, 0, 2000);
            enemy Bully=new enemy("Bully", 1, 1, 20, 10, 30, 50, 0, 2000);
            enemy Dragontwo=new enemy("Dragon", 10, 1, 7, 1, 1, 0, 500, 2000);
            enemy Dragon=new enemy("Dragon", 10, 10, 1, 1, 200, 0, 500, 2000);

            Dragon.battlePicture = DragonPic;
            Dragontwo.battlePicture = DragonPic;
            Orc.battlePicture = OrcPic;
            Bully.battlePicture = BullyPic;


            Ennemies.add(Orc);
            Ennemies.add(Dragon);
            Ennemies.add(Bully);
            // Ennemies.add(Dragontwo);
            interactionState = 0;
            gameState = 4;
          } else if (interactionState == 3) {
            interactionState = 0;
            for (int i = 0; i <= Party.size ()-1; i ++) {
              Party.get(i).currentHP = Party.get(i).hp;
            }
          } else {
            interactionState = 0;
          }
        }
      }
    }
    switch(key) {
    case'a':
      if (interactionState>0 && pausedMenu == 0) {
        if (Dialog.get(interactionState).isDone&&Dialog.get(interactionState).hasOptions&&optionSelected!=0) {
          optionSelected = 0;
          menuEffect.rewind();
          menuEffect.play();
        }
      } else if (pausedMenu == 2) {
        menuEffect.rewind();
        menuEffect.play();
        if (invselected < 1) {
          invselected = 1;
        }
        if (itemselected!=0) {
          itemselected = 0;
        }
      }
      break; 
    case'd':
      if (interactionState>0 && pausedMenu == 0) {
        if (Dialog.get(interactionState).isDone&&Dialog.get(interactionState).hasOptions&&optionSelected!=1) {
          optionSelected = 1;
          menuEffect.rewind();
          menuEffect.play();
        }
      } else if (pausedMenu == 2) {
        menuEffect.rewind();
        menuEffect.play();
        if (invselected < 1) invselected = 1;
        if (itemselected==0) {
          itemselected ++;
        }
      }
      break;
    case 's':
      if (paused && pausedMenu == 0) {
        menuEffect.rewind();
        menuEffect.play();
        optionSelected++;
        if (optionSelected > pauseMenuOptions.size()-1) 
        {
          optionSelected = 0;
        }
      } else if (pausedMenu == 2) {
        menuEffect.rewind();
        menuEffect.play();
        if (itemselected==0) {
          invselected ++;
        }
        if (itemselected!=0) {
          itemselected ++;
          if (itemselected > Party.get(invselected - 1).getInventory().size()) {
            itemselected = 1;
          }
        }
        if (invselected > 3) invselected = 1;
      }
      break;
    case 'w':
      if (paused && pausedMenu == 0) {
        menuEffect.rewind();
        menuEffect.play();
        optionSelected--;
        if (optionSelected < 0) {
          optionSelected = pauseMenuOptions.size()-1;
        }
      } else if (pausedMenu == 2) {
        menuEffect.rewind();
        menuEffect.play();
        if (itemselected==0) {
          invselected --;
        } else {
          itemselected--;
          if (itemselected < 0)
          {
            itemselected = Party.get(invselected - 1).getInventory().size();
          }
        }
      }
      if (invselected < 1) invselected = 3;
      break;
    }
  }
}
public void keyReleasedOverworld() {
  switch(key) {
  case 'w':
  case 'a':
  case's':
  case 'd':
    isMoving = false;
    break;
  }
}
public void CharScreen() {
  background(23, 30, 193);
  fill(0);
  line(0, height/3, width, height/3);
  line(0, height*2/3, width, height*2/3);
  textAlign(LEFT);
  for (int i = 1; i <= 3; i ++) {
    textSize(10);
    fill(0);
    if (charselected == i) fill(255, 0, 0);
    rect(25, height*(i-1)/3, 170, 30);
    fill(124, 245, 113);
    image(Party.get(i-1).battlePicture, 25, height*(i-1)/3 + 40);
    fill(255);
    text(Party.get(i-1).getname(), 30, height*(i-1)/3 + 20);
    text("Health: " + Party.get(i-1).getHealth() + "/" + Party.get(i-1).getMaxHealth(), width/4, height*(i-1)/3 + 50);
    text("Mana: " + Party.get(i-1).getMana() + "/" + Party.get(i-1).getMaxMana(), width/4, height*(i-1)/3 + 70);
    text("Inventory: " + Party.get(i-1).getInventory().size() + "/" + Party.get(i-1).getMaxInventory(), width/4, height*(i-1)/3 + 130);
    textSize(10);
    text("Weapon: " + Party.get(i-1).getWeapon().getname() + "-" + Party.get(i-1).getWeapon().getDamage() + " damage, " + Party.get(i-1).getWeapon().getAccuracy() * 100 + "% accuracy", width/4, height*(i-1)/3 + 90);
    text("Armour: " + Party.get(i-1).getArmour().getname() + "-" + Party.get(i-1).getArmour().getArmourRating() + " rating, " + Party.get(i-1).getArmour().getSpeedRating() + " speed", width/4, height*(i-1)/3 + 110);
  }
}

public void Inventory() {
  background(23, 30, 193);
  fill(0);
  line(0, height/3, width, height/3);
  line(0, height*2/3, width, height*2/3);
  textAlign(LEFT);
  for (int i = 1; i <= 3; i ++) {
    textSize(20);
    fill(0);
    if (invselected == i && itemselected == 0) fill(255, 0, 0);
    rect(25, height*(i-1)/3, 170, 30);
    fill(255, 0, 255);
    image(Party.get(i-1).battlePicture, 25, height*(i-1)/3 + 40);
    fill(255);
    text(Party.get(i-1).getname(), 30, height*(i-1)/3 + 20);
    if (i == invselected) {
      for (int j = 0; j < Party.get (i-1).getInventory().size(); j ++) {
        fill(255);
        if (itemselected == j+1) {
          if (!Party.get(i-1).getInventory().get(j).isBound()) {
            text("Price: " + Party.get(i-1).getInventory().get(j).getPrice(), width/2, 30);
          } else {
            text("SoulBound", width/2, 30);
          }
          fill(255, 0, 0);
        }
        text(Party.get(i-1).getInventory().get(j).getname(), 205, height*(i-1)/3 + 50 + 30*j);
      }
    }
  }
}
