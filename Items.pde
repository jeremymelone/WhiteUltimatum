//basic item, has name and ID
class Item {
  private String name;
  private int price;
  private boolean Bound;
  
  public Item(String n) {
    name = n;
    price = 0;
    Bound = false;
  }
  public int getPrice(){
    return this.price;
  }
  public void setPrice(int p){
    this.price = p;
  }
  public String getname() { 
    return this.name;
  }
    public Boolean isBound() { 
    return this.Bound;
  }
    public void setBound(boolean b) { 
    this.Bound = b;
  }
}

//armour has armour rating and speed rating, armour rating is the
//ability to stop attacks, and speed is a multiplier that is multiplied
//by a characters base speed to determine their movement for each turn
//just an idea for how movement could work
class Armour extends Item {
  int armourRating;
  float speedRating;

  public Armour(String n, int a, float s) {
    super(n);
    armourRating = a;
    speedRating = s;
    this.setPrice(a+(int)s);
  }

  public int getArmourRating() { 
    return this.armourRating;
  }
  public float getSpeedRating() { 
    return this.speedRating;
  }
}

//weapons have damage and accuracy, when attacks happen, generate random
//float from 0-1, if it is lower that accuracy it is a hit: this way
//a higher accuracy will make you more likely to hit
class Weapon extends Item {
  private int damage;
  private float accuracy;

  public Weapon(String n, int d, float a) {
    super(n);
    damage = d;
    accuracy = a;
    this.setPrice(d+(int)a*10);
  }

  public int getDamage() { 
    return this.damage;
  }
  public float getAccuracy() { 
    return this.accuracy;
  }
}

//potions, there can be different potions in your inventory, and we just change the 
//quantity whenever we use/get them
class Potion extends Item {
  private int health;
  private int quantity;

  public Potion(String n, int h, int q) {
    super(n);
    health = h;
    quantity = q;
  }

  public int getHealth() { 
    return this.health;
  }
  public int getQuantity() { 
    return this.quantity;
  }

  public void usePotion() { 
    quantity--;
  }
}
