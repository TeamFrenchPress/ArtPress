import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.awt.Rectangle;


Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  image(video, 0, 0); 
  opencv.updateBackground();
  
  opencv.dilate();
  opencv.erode();
  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  //ArrayList<color> maxes = new ArrayList<color>(
  
  
  for (Contour contour : opencv.findContours(true,true)) {
    Rectangle r = contour.getBoundingBox();
    if((r.width * r.height) < 144)
     {
      continue; 
     }
     
     opencv.setROI(r.x,r.y,r.width,r.height);
    // maxes.add(opencv.max());
     //color a = get(int(opencv.max().x),int(opencv.max().y));
     //color(0,0);
    
    //maxes[0].
     //maxes.add(get(opencv.max().x,opencv.max().y));
     if(r.contains((opencv.max().x),(opencv.max().y)))
    {
     println("clapmoar ", r.x, r.y, opencv.max().x, opencv.max().y); 
     rect(r.x,r.y,r.width,r.height);
    }
     opencv.releaseROI();
  /*  if(r.contains((opencv.max().x),(opencv.max().y)))
    {
     println("clapmoar ", r.x, r.y, opencv.max().x, opencv.max().y); 
     rect(r.x,r.y,r.width,r.height);
    }*/
    
    //contour.draw();
    //c.draw();
    //contour.draw();
    //rect(
    //rect(contour.getBoundingBox().getX(), contour.getBoundingBox().getY(), contour.getBoundingBox().getWidth(), contour.getBoundingBox().getHeight());
    //Rectangle r = new Rectangle(contour.);
   // r.
    //rect(float(contour.getBoundingBox().getX()), float(contour.getBoundingBox().getY()), float(contour.getBoundingBox().getWidth()), float(contour.getBoundingBox().getHeight()));
    //rect(r.x,r.y,r.width,r.height);
  }
 
 /* PVector loc = opencv.max();
  println(loc);
  stroke(255, 0, 0);
  strokeWeight(4);
  noFill();
  ellipse(loc.x, loc.y, 10, 10);*/
}

void captureEvent(Capture c) {
  c.read();
}
