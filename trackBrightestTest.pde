import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  image(video, 0, 0); 
  PVector loc = opencv.max();
  println(loc);
  stroke(255, 0, 0);
  strokeWeight(4);
  noFill();
  ellipse(loc.x, loc.y, 10, 10);
}

void captureEvent(Capture c) {
  c.read();
}
