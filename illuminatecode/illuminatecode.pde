///////////
//  March 15, 2017
//  Code after 2nd Session with dancers
//  
//  Changes include:
//  Restart vehicles every time dancers scape  
//  Press k to toggle between kinect view     
//
/////////////

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

KinectTracker tracker;
Kinect kinect;
ArrayList<PVector> v4Pos; 
FlowField flowfield;

ArrayList<Vehicle> vehicles;

PVector v4;

int counter;
int jumpHeight; 
boolean isJump = false;
boolean previousState = false;
boolean showTracker=false;

void setup() {
  //size(1000, 600, P2D);
  //fullScreen(P2D);
  noCursor();
  fullScreen(P2D, 1);

  v4Pos = new ArrayList<PVector>();

  kinect = new Kinect(this);
  tracker = new KinectTracker();

  flowfield = new FlowField(10);
  flowfield.update();
  vehicles = new ArrayList<Vehicle>();

  jumpHeight = kinect.height - kinect.height/7; 

  createParticles();
  //for (int i = 0; i < 10000; i++) {
  //  //PVector start = new PVector(width/2,height/2);
  //  PVector start = new PVector(random(width), random(height));
  //  vehicles.add(new Vehicle(start, random(2, 6), random(0.1, 0.4)));
  //}

  background(0);
}

void draw() {
  counter++;
  tracker.track();
  //if (showTracker) {
    //tracker.display();
  //}
  //flowfield.display();
  // println(isJump);
  v4 = tracker.getPos();

  noFill();
  //fill(255,0,0);
  noStroke();
  v4Pos.add(v4);
  //ellipse(v4.x*2.2, v4.y*2.2, 20, 20);
  ellipse(v4.x*2.2, v4.y/4, 20, 20);
  //println(v4Pos);




  //if (frameCount%1000 ==0) {
  //  //for(int i=0; i<v4Pos.size(); i++) {
  //  fill(0);
  //  //ellipse(v4Pos.get(i).x*2,v4Pos.get(i).y*2,100,100);
  //  rect(0, 0, displayWidth, displayHeight);
  //  //}
  //}



  //background(255);

  // Display the flowfield in "debug" mode
  //flowfield.display();
  // Tell all the vehicles to follow the flow field

  //if(isJump == false){
  flowfield.update();
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run();
  }
  //}

  if (isJump == true) {
    fill(255);
    rect(0, 0, displayWidth, displayHeight);
    createParticles();
  }

  if (previousState == true && isJump == false) {
    fill(0);
    rect(0, 0, displayWidth, displayHeight);
  }

  previousState = isJump;
}


void keyPressed() {
  //fill(0);
  //rect(0, 0, displayWidth, displayHeight);
  if (key=='k') {
    showTracker=!showTracker;
  } else {
    background(0);
  }
}

void createParticles() {
  for (int i=0; i<vehicles.size(); i++) {
    vehicles.remove(i);
  }
  //color vColor=color(random(255),random(255),random(255),3);
  //color vColor=color(random(1)*255);
  color vColor=color(255, 3);
  for (int i = 0; i < 10000; i++) {
    //PVector start = new PVector(width/2,height/2);
    PVector start = new PVector(random(width), random(height));
    vehicles.add(new Vehicle(start, random(2, 6), random(0.1, 0.4), vColor));
  }
  //println(vehicles.size());
}