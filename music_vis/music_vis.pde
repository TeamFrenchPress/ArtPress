import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import processing.serial.*;
import ddf.minim.*;
import java.lang.Object;
import java.awt.Color;
Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Serial myPort;


int br=0;
boolean a=true;
String mode = "brightsat";

int chue=180;
int csat=50;
int cbright=100;

void setup()
{
  size(640, 480);
  minim = new Minim(this);
  frameRate( 30 );
  smooth();
  song = minim.loadFile("wayward.mp3", 2048);
 
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
 
  beat.setSensitivity(100);
  bl = new BeatListener(beat, song); 
 
  myPort = new Serial(this,"COM4",9600);
  myPort.bufferUntil('\n');
  delay(3000);
  song.play();
  
}
void draw()
{
  
  rect(0,0,100,100);
  rect(100,0,100,100);
  rect(200,0,100,100);
  rect(300,0,100,100);
  rect(400,0,100,100);
  rect(500,0,100,100);
  colorMode(HSB,360,100,100);
  
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

void send(float h, float s, float v)
{
  colorMode(RGB,255,255,255);
  int[] rgb = HSVtoRGB(h,s,v);
    if(myPort.available()>0) a=myPort.read()==97;
    if(a)
    {
      myPort.write(byte(0xa5));
      myPort.write(byte(0xff));
      myPort.write(byte(int(rgb[0])));
      myPort.write(byte(int(rgb[1])));
      myPort.write(byte(int(rgb[2])));
      a=false;
    }
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
