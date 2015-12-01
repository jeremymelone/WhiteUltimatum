int gold = 0;
class character {
  String Name;
  int intellect;
  int agality;
  int strength;
  int experience=0;
  int level;
  int hp;
  int currentHP;
  int mana;
  int currentMana;
  boolean Alive=true;
  boolean Defence=false;
  String PersonType;
  PImage battlePicture;
  Weapon weapon;
  Armour armour;

  //getters
  public int getHealth() { 
    return this.currentHP;
  }
  public int getMaxHealth() { 
    return this.hp;
  }
  public int getMana() { 
    return this.currentMana;
  }
  public int getMaxMana() { 
    return this.mana;
  }
  public String getname() { 
    return this.Name;
  }
  public Weapon getWeapon() {
    return this.weapon;
  }
  public Armour getArmour() {
    return this.armour;
  }
  //changing armour/weapon
  public void wearArmour(Armour a) { 
    this.armour = a;
  }
  public void weildWeapon(Weapon w) { 
    this.weapon = w;
  }

  void checkLife() {
    if (this.currentHP<=0) {
      Alive=false;
      currentHP = 0;
    }
  }
 int basicAttack() {
    float attack=this.strength*0.6+this.agality*0.3+this.intellect*0.1;
    if (this.weapon!=null){
      attack+=this.weapon.damage;
    }
    return int(attack);
  }
  void attacked(int damage) {
    //Put any changes to damage here
    if (Defence) {
      if(this.armour==null){
        this.currentHP-=damage/2;
      }
      else{
        int damageToDeal=(damage-this.armour.armourRating)/2;
        if (damageToDeal>0){
          this.currentHP-=damageToDeal;
        }
        else{
          this.currentHP-=1;
        }
      }
    } else {
      if (this.armour==null){
        this.currentHP-=damage;
      }
      else{
        int damageToDeal=damage-this.armour.armourRating;
        if (damageToDeal>0){
          this.currentHP-=damageToDeal;
        }
        else{
          this.currentHP-=1;
        }
      }
    }
    checkLife();
  }
}


class player extends character {
  int experienceToLevel;
  int levelDifference=0;
  int numItems, maxItems;
  private ArrayList<Item> inventory;
  player(String n, int i, int a, int s, int l, int h, int m, int e) {
    this.Name=n;
    this.intellect=i;
    this.agality=a;
    this.strength=s;
    this.level=l;
    this.hp=h;
    this.currentHP=h;
    this.mana=m;
    this.currentMana=m;
    this.experienceToLevel=e;
    this.PersonType="player";
    this.numItems = 0;
    this.maxItems = 15;
    this.inventory = new ArrayList<Item>();
    this.weapon = new Weapon("Fists", 5, 0.7);
    this.armour = new Armour("No Armour", 3, 10);
    this.weapon.setBound(true);
    this.armour.setBound(true);
  }
  void levelCheck() {
    while (this.experience>=this.experienceToLevel) {
      this.level++;
      this.levelDifference++;
      if (debug) {
        println("LEVEL UP");
        println(this.experience+" | "+this.experienceToLevel);
      }
      this.experienceToLevel*=1.7;
      leveling=true;
    }
  }

  public void addItem(Item i) {
    this.inventory.add(i);
  }
  public boolean tryAddItem(Item i) {
    if (numItems<maxItems) {
      this.inventory.add(i);
      return true;
    } else {
      return false;
    }
  }

  public ArrayList<Item> getInventory() {
    return this.inventory;
  }

  public int getMaxInventory() {
    return this.maxItems;
  }

  public void swapEquipped(int i) {
    if (inventory.get(i) instanceof Armour) {
      Armour temp = this.getArmour();
      this.wearArmour((Armour)inventory.get(i));
      inventory.remove(i);
      inventory.add(temp);
    } else if (inventory.get(i) instanceof Weapon) {
      Weapon temp = this.getWeapon();
      this.weildWeapon((Weapon)inventory.get(i));
      inventory.remove(i);
      inventory.add(temp);
    }
  }
}
class enemy extends character {
  int gold;
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
}
