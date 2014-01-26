import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.util.*;
import processing.serial.*;

Capture video;
OpenCV opencv;
Serial myPort;
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Integer> curveColors = new ArrayList<Integer>();
color winning;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  myPort = new Serial(this,"COM9",9600);
  //myPort.wr
  video.start();
}
boolean drawnow = false;
int locx,locy;
int mod = 25;

void draw() {
  
  opencv.loadImage(video);
  image(video, 0, 0); 
  if(drawnow){
  PVector loc = opencv.max();

  locx = int(loc.x);
  locy = int(loc.y);
 
  //rect(100,100,25,25);
  ArrayList<PVector> tests = new ArrayList<PVector>();
 // println(opencv.setROI(100,100,25,25));
  //println(opencv.max());
  if(opencv.setROI(locx-mod-150,locy-75,150,150)){
  //println(opencv.max());
  PVector tempone = opencv.max();
  tempone.x += locx-mod-150;
  tempone.y += locy-75;
  tests.add(tempone);
  opencv.releaseROI();
  }
  
  if(opencv.setROI(locx+mod,locy-75,150,150)){
  //println(opencv.max());
  PVector tempone = opencv.max();
  tempone.x += locx+mod;
  tempone.y += locy-75;
  tests.add(tempone);
  opencv.releaseROI();
  }
  
  if(opencv.setROI(locx-75,locy-150-mod,150,150)){
  //println(opencv.max());
  PVector tempone = opencv.max();
  tempone.x += locx-75;
  tempone.y += locy-150-mod;
  tests.add(tempone);
  opencv.releaseROI();
  }
  if(opencv.setROI(locx-75,locy+mod,150,150)){
  //println(opencv.max());
  PVector tempone = opencv.max();
  tempone.x += locx-75;
  tempone.y += locy+mod;
  tests.add(tempone);
  opencv.releaseROI();
  }
  
 //println(opencv.max());
  float highest = 0.0;
  PVector second = new PVector();
  for(PVector v : tests)
  {
   if((abs(v.x - loc.x) < 75) && (abs(v.y - loc.y) < 75) && (brightness(get(int(v.x),int(v.y))) > highest) && !(v.equals(loc)))
   {
    highest =  brightness(get(int(v.x),int(v.y)));
    second = v;
   }
   else
   {
   // println("ELSEWAT"); 
   }
  }
  println(second);
  int secondx = int(second.x);
  int secondy = int(second.y);
  fill(0);
  stroke(0);
  ellipse(secondx,secondy,8,8);
 
  
  ellipse(locx,locy,8,8);
  strokeWeight(2);
  if(winning != color(red(color(get(int(loc.x),int(loc.y+15)))),green(color(get(int(loc.x),int(loc.y+15)))),blue(color(get(int(loc.x),int(loc.y+15))))))
  {
   winning = color(red(color(get(int(loc.x),int(loc.y+15)))),green(color(get(int(loc.x),int(loc.y+15)))),blue(color(get(int(loc.x),int(loc.y+15)))));  
  }
 
  for(int p=0; p<points.size(); p++)
  {   
    if(points.size() > p+1){
       stroke(int(curveColors.get(p)));
       fill(int(curveColors.get(p)));
       //ellipse(points.get(p).x, points.get(p).y, 8, 8);
      line(points.get(p).x, points.get(p).y, points.get(p+1).x,points.get(p+1).y);
       //draw soicles in between them
    }
  }
  
  points.add(new PVector(loc.x,loc.y));
  curveColors.add(winning);
  //stroke(winning);
  
  }
}
void keyPressed()
{
  switch(key){
  case 'c': points.clear(); curveColors.clear();
  default: drawnow = !drawnow; 
  }
 
}
void captureEvent(Capture c) {
  c.read();
}
