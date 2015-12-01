public class collision{
  int x;
  int y;
  public collision(int _x, int _y) {
    this.x = _x;
    this.y = _y;
  }
}
public class interaction{
  int x;
  int y;
  int state;
  public interaction(int _x, int _y, int _state) {
    this.x = _x;
    this.y = _y;
    this.state = _state;
  }
}
public class battleZone{
  int x;
  int y;
  int type;
  int rate;
  public battleZone(int _x, int _y, int _type, int _rate) {
    this.x = _x;
    this.y = _y;
    this.type = _type;
    this.rate = _rate;
  }
}

