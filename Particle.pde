

class Particle {
    PVector pos, vel;
    float speed;
    float myLife;
    int mySize;
    int col;
    boolean active = true;
    int mode;

    Particle(int mode_, PVector p, PVector vl, int c, int life, float speed, int pSize, float r1, float r2) {
        pos = new PVector(p.x, p.y);
        myLife = life * random(.5, 1.5);
        col = color((random(-10, 10)+c)%255, 255, 255);
        float v = random(r1,r2) * speed;
        vel = new PVector(v, v);
        vel.rotate(random(0, 2*PI));
        vel.add(vl);
        mySize=pSize;
        mode = mode_;

    }

    boolean draw() {
        vel.mult(.98);
        
        switch(mode) {
          case 0:
            vel.x+= -0.02;
            break;
          case 1:
             vel.y+= 0.02;
            break;
          case 2:
            vel.y+= -0.02;
            break;
          case 3:
            vel.x+= 0.02;
            break;
        }
        
    //    vel.y+=gravity;
        pos.add(vel);
        myLife--;
        if (myLife <1) {
            active = false;
        }
        drawEllipse();

        return active;
    }

    void drawEllipse() {  
        if (random(0, 100) < 3 && myLife < 40) fill(255); else fill(col, myLife);    //flashes at the end of life
        pushMatrix();
        translate(pos.x, pos.y);
        ellipse(0, 0, mySize, mySize);
        fill(90, 100, 100);
        if (random(0, 100) < 5) ellipse(random(-2, 2), random(5, 20), 2, 2);    //sparkles
        popMatrix();
    }
}