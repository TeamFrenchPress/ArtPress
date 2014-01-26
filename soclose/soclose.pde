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
  //myPort = new Serial(this,"COM9",9600);
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
  PVector aux = new PVector();
  for(PVector v : tests)
  {//(abs(v.x - loc.x) < 75) && (abs(v.y - loc.y) < 75) &&(abs(v.x - loc.x) < 100) && (abs(v.y - loc.y) < 100) &&
   if((brightness(get(int(v.x),int(v.y))) > highest))
   {
    highest =  brightness(get(int(v.x),int(v.y)));
    aux = v;
   }
   else
   {
   // println("ELSEWAT"); 
   }
  }
  //println(second);
  
  
  
  float locbackupx = loc.x;
  float locbackupy = loc.y;
  PVector hax = new PVector();
  hax = PVector.sub(loc,aux);
  hax.normalize();
  hax.mult(7);
  //println(loc);
  loc.add(hax);

  locx = int(loc.x);
  locy = int(loc.y);
  //ellipse(int(aux.x),int(aux.y),8,8);
  //opencv.setROI(locx,locy,19,19);
  //println(loc);
  //println(locx,locy);
  //
  /*color demoncolor = color(red(247),green(247),blue(247));
  color fuckthisshit = color(red(246),green(246),blue(246));
  color slickblack = color(red(0),green(0),blue(0));*/
  color nextcolor = color(red(color(get(int(loc.x),int(loc.y)))),green(color(get(int(loc.x),int(loc.y)))),blue(color(get(int(loc.x),int(loc.y)))));
  if(loc.x >= 0 && loc.y >= 0){
 // println(red(color(get(int(loc.x),int(loc.y)))),green(color(get(int(loc.x),int(loc.y)))),blue(color(get(int(loc.x),int(loc.y)))));
  ////ellipse(locx,locy,8,8);
    strokeWeight(2);
    
    if(winning != nextcolor)//nextcolor != opencv.in && nextcolor != slickblack  && winning != nextcolor)
    {
      println(red(color(get(int(loc.x),int(loc.y)))),green(color(get(int(loc.x),int(loc.y)))),blue(color(get(int(loc.x),int(loc.y)))));
      winning = color(red(color(get(int(loc.x),int(loc.y)))),green(color(get(int(loc.x),int(loc.y)))),blue(color(get(int(loc.x),int(loc.y)))));
    }
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
  
  points.add(new PVector(locbackupx,locbackupy));
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
