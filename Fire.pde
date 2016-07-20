

class Fire {
  PVector pos, vel;
  color col;
  int fireType;
  boolean active = true;
  int myLife;
  int myH;
  int mode;
  float mySpeed;
  float myR1, myR2;

  Fire(float x, float y, int type, color c, int h, float speed, int life, float r1, float r2, int mode_) {

    
    myLife = life;
    col = c;
    fireType = type;
    myH=h;
    mySpeed=speed;
    myR1=r1;
    myR2=r2;
    mode = mode_;
    switch(mode) {
      case 0:
        pos = new PVector(0, height/2);
        vel = new PVector(1, 0);
        break;
      case 1:
        pos = new PVector(width/2, height - y);
        vel = new PVector(0, -2);
        break;
      case 2:
        pos = new PVector(width/2, 0);
        vel = new PVector(0, 1);
        break;
      case 3:
        pos = new PVector(width, height/2);
        vel = new PVector(-1, 0);
        break;
    }
  }

  boolean draw() {
    if (pos.x > height + 200 || 
      pos.x < 0 ||
      pos.y > width + 200 ||
      pos.y < -200) active = false;    //if out of the screen
    myLife--;
    if (myLife <0) {
      for (int i=0; i<250; i++) {
        //int mode_, PVector p, PVector vl, int c, int life, float speed, int pSize, float r1, float r2)
        particles.add(new Particle(mode, pos, vel, myH, 200, mySpeed, int(random(0, 10)), myR1, myR2));
      }
      active = false;
    }
    pos.y+=random(-1, 1);
    pos.x+=random(-1, 1);
    if (mode == 1) {
      vel.y+=gravity;
    }
    pos.add(vel);
    drawEllipse();

    return active;
  }

  void drawEllipse() {
      fill(col, myLife);
      pushMatrix();
      translate(pos.x, pos.y);
      rect(0, 0, 4, 10);
      fill(62, 100, 100);
      if (random(0, 100) < 5) ellipse(random(-2, 2), random(5, 20), 2, 2);    //sparkles
      popMatrix();
  }
}