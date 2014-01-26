import controlP5.*;

import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Serial myPort;

ControlP5 cp5;
ColorPicker cp;

int br=0;
boolean a=true;
String mode = "flash";
boolean paintbrush=false;

int chue=0;
int csat=100;
int cbright=100;
//220 green blue

void setup()
{
  
  colorMode(HSB,360,100,100);
  size(640, 480);
  background(0,50,100);
  minim = new Minim(this);

 
  //myPort = new Serial(this,"COM4",9600);
  //myPort.bufferUntil('\n');
 
  cp5 = new ControlP5(this);
  
  frameRate( 30 );
  smooth();
  song = minim.loadFile("demons.mp3", 2048);
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);
  bl = new BeatListener(beat, song); 
  
  colorMode(RGB,255);
  textSize(24);
  fill(255);
  text("mode:", 10, 30); 
  text("saturation:", 20, 160); 
  text("color:", 20, 290); 

  
  colorMode(HSB,360,100,100);
  
  CColor g = new CColor();
  CColor ccol = new CColor();
  
  g.setActive(color(75));
  g.setBackground(color(50));
  g.setForeground(color(0));
  cp5.addButton("Play")
    .setBroadcast(false)
    .setPosition(240,410)
    .setSize(48,20)
    .setValue(0)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;  
    
  cp5.addButton("Pause")
    .setBroadcast(false)
    .setPosition(290,410)
    .setSize(48,20)
    .setValue(1)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  cp5.addButton("Stop")
    .setBroadcast(false)
    .setPosition(340,410)
    .setSize(48,20)
    .setValue(1)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  ccol.setActive(color(0,csat,cbright));
  
  cp5.addButton("")
    .setBroadcast(false)
    .setPosition(20,300)
    .setSize(90,90)
    .setValue(1)
    .setId(5)
    .setColor(setCCol(5))
    .setBroadcast(true)
    ;
    
  cp5.addButton(" ")
    .setBroadcast(false)
    .setPosition(120,300)
    .setSize(90,90)
    .setValue(1)
    .setId(65)
    .setColor(setCCol(65))
    .setBroadcast(true)
    ;
    
  cp5.addButton("   ")
    .setBroadcast(false)
    .setPosition(220,300)
    .setSize(90,90)
    .setValue(1)
    .setId(110)
    .setColor(setCCol(110))
    .setBroadcast(true)
    ;
    //180,220
  cp5.addButton("    ")
    .setBroadcast(false)
    .setPosition(320,300)
    .setSize(90,90)
    .setValue(1)
    .setId(180)
    .setColor(setCCol(180))
    .setBroadcast(true)
    ;
    
  cp5.addButton("     ")
    .setBroadcast(false)
    .setPosition(420,300)
    .setSize(90,90)
    .setValue(1)
    .setId(220)
    .setColor(setCCol(220))
    .setBroadcast(true)
    ;
    
  cp5.addButton("      ")
    .setBroadcast(false)
    .setPosition(520,300)
    .setSize(90,90)
    .setValue(1)
    .setId(320)
    .setColor(setCCol(320))
    .setBroadcast(true)
    ;
    
  g.setActive(color(180));
  g.setBackground(color(200));
  g.setForeground(color(220));
  cp5.addButton("50%")
    .setBroadcast(false)
    
    .setColor(g)
    .setPosition(20,175)
    .setSize(90,90)
    .setValue(1)
    .setId(-50)
    .setBroadcast(true)
    ;
    
  g.setActive(color(70));
  g.setBackground(color(90));
  g.setForeground(color(110));
  
  cp5.addButton("100%")
    .setBroadcast(false)
    .setPosition(120,175)
    .setSize(90,90)
    .setValue(1)
    .setId(-100)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  /*cp5.addCheckBox("CheckBox")
    .setPosition(100,200)
    .setSize(20,20)
    .addItem("Light Graffiti Mode",0);
    ;
 */
    
} 


public void controlEvent(ControlEvent c) {
  if(c.getController().getId()>=0)
  {
   chue=c.getController().getId();
   int[] background = HSVtoRGB(chue,int(csat/2),cbright);
   background(color(background[0],background[1],background[2]));
  }
  else if(c.getController().getId()==-100)
  {
    csat=100;
  }
  else if(c.getController().getId()==-50)
  {
    csat=50;
  }
}

public void Play(int theValue) {
  song.play();
}

public void Pause(int theValue) {
  song.pause();
}

public void Stop(int theValue) {
  stop();
  exit();
}


CColor setCCol(int h)
{
  colorMode(RGB,255,255,255);
  int[] foreground = HSVtoRGB(h,csat,cbright);
  int[]  background = HSVtoRGB(h,csat-10,cbright-20);
  int[] active = HSVtoRGB(h,csat-50,cbright);
  CColor col = new CColor();
  col.setForeground(color(foreground[0],foreground[1],foreground[2]));
  col.setBackground(color(background[0],background[1],background[2]));
  col.setActive(color(active[0],active[1],active[2]) );
  return col;
}
CColor setCCol(int h, int s)
{
  colorMode(RGB,255,255,255);
  int[] foreground = HSVtoRGB(h,csat,cbright);
  int[]  background = HSVtoRGB(h,csat-10,cbright-20);
  int[] active = HSVtoRGB(h,int(csat/2),cbright);
  CColor col = new CColor();
  col.setForeground(color(foreground[0],foreground[1],foreground[2]));
  col.setBackground(color(background[0],background[1],background[2]));
  col.setActive(color(active[0],active[1],active[2]) );
  return col;
  
}
void paintbrushMode()
{
    colorMode(RGB,255,255,255);
    int[] rgb = HSVtoRGB(chue,csat,cbright);
    int[] rgb2 = HSVtoRGB(360,0,0);
    if(myPort.available()>0) a=myPort.read()==97;
    if(a)
    {
      myPort.write(byte(0xa5));
      myPort.write(byte(0xc1));
      myPort.write(byte(int(rgb[0])));
      myPort.write(byte(int(rgb[1])));
      myPort.write(byte(int(rgb[2])));
      myPort.write(byte(0xa5));
      myPort.write(byte(0xfe));
      myPort.write(byte(rgb2[0]));
      myPort.write(byte(rgb2[1]));
      myPort.write(byte(rgb2[2]));
      a=false;
      while(true)
      {
       
      }
    }
 
}

void draw()
{
  /*rect(0,0,100,100);
  rect(100,0,100,100);
  rect(200,0,100,100);
  rect(300,0,100,100);
  rect(400,0,100,100);
  rect(500,0,100,100);*/
  colorMode(HSB,360,100,100);
  if(paintbrush)
  { 
    paintbrushMode();
  }
  else{
   if(mode=="flash")
   {

     int h=chue; int s=csat;
     if(beat.isRange(19,26,1))
     {
       br=100;
     }
     else if (br > 10)
     {
       br -= 10;
     }
     send(h, s, br);
   }
  else
  {
    int range;
    if(beat.isRange(1,5,1)) //range 1
    {
      range=1;
      int[] hsb = getHSB(mode, range);
      send(hsb[0],hsb[1],hsb[2]);
    }
    else if(beat.isRange(6,9,1)) //range 2
    {
      range=2;
      int[] hsb = getHSB(mode, range);
      send(hsb[0],hsb[1],hsb[2]);
    }
    else if(beat.isRange(10,15,1)) //range 3
    {
      range=3;
      int[] hsb = getHSB(mode, range);
      send(hsb[0],hsb[1],hsb[2]);
    }
    else if(beat.isRange(16,20,1)) //range 4
    {
      range=4;
      int[] hsb = getHSB(mode, range);
      send(hsb[0],hsb[1],hsb[2]);
    }
    else if(beat.isRange(21,26,1)) //range 5
    {
      range=5;
      int[] hsb = getHSB(mode, range);
      send(hsb[0],hsb[1],hsb[2]);
    }
  }
}
}

void send(float h, float s, float v)
{
  colorMode(RGB,255,255,255);
  int[] rgb = HSVtoRGB(h,s,v);
    /*if(myPort.available()>0) a=myPort.read()==97;
    if(a)
    {
      myPort.write(byte(0xa5));
      myPort.write(byte(0xff));
      myPort.write(byte(int(rgb[0])));
      myPort.write(byte(int(rgb[1])));
      myPort.write(byte(int(rgb[2])));
      a=false;
    }*/
    fill(rgb[0],rgb[1],rgb[2]);
}

int[] getHSB(String mode, int range)
{
  int[] hsb = new int[3];
  int h=chue; int s=csat; int b=cbright;
  //50, purple, 180, blue
  if(mode=="brightsat")
  {
      b=100;
      s=50;
      switch(range){
        case 1: b-=80; s+=20; break;
        case 2: b-=60; s+=15; break;
        case 3: b-=40; s+=10; break;
        case 4: b-=20; s+=5; break;
        case 5: break;
      }
  }  
  else if(mode=="bright")
  {
      b=100;
      switch(range){
        case 1: b-=80; break;
        case 2: b-=60; break;
        case 3: b-=40; break;
        case 4: b-=20; break;
        case 5: break;
      }
  }
  else if(mode=="hue")
  {
    h=0;
    s=100;
    switch(range){
      case 1: h+=40; break;
      case 2: h+=80; break;
      case 3: h+=120; break;
      case 4: h+=160; break;
      case 5: h+= 200; break;
      }
  }
  else if(mode=="sat")
  {
      s=100;
      switch(range){
        case 1: s-=50; break;
        case 2: b-=60; break;
        case 3: b-=70; break;
        case 4: s-=80; break;
        case 5: s-=90; break;
        }
  }
  else if(mode=="random")
  {
    s=100;
    h=int(random(360));
  }
  
  hsb[0]=h; hsb[1]=s; hsb[2]=b;
  return hsb;
}


int[] HSVtoRGB(float h, float s, float v)
{
  s/=100;
  v/=100;
  float c,x,m,r=0,g=0,b=0;
  
  int[] rgb = new int[3];
  c=v*s;
  x=c*(1-abs((h/60)%2-1));
  m=v-c;
  if(0<=h && h<60)
  {
    r=c+m;
    g=x+m;
    b=0+m;
  }
  else if(60<=h && h<120)
  {
    r=x+m;
    g=c+m;
    b=0+m;
  }
  else if(120<=h && h<180)
  {
    r=0+m;
    g=c+m;
    b=x+m;
  }
  else if(180<=h && h<240)
  {
    r=0+m;
    g=x+m;
    b=c+m;
  }
  else if(240<=h && h<300)
  {
    r=x+m;
    g=0+m;
    b=c+m;
  }
  else if(300<=h && h<360)
  {
    r=c+m;
    g=0+m;
    b=x+m;
  }
  r*=255;
  g*=255;
  b*=255;
  rgb[0]=int(r);
  rgb[1]=int(b);
  rgb[2]=int(g);
  return rgb;
}

void stop()
{
  song.close();
  minim.stop();
 
  super.stop();
}
 
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
 
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
 
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
 
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}
