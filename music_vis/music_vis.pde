import controlP5.*;

import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import processing.serial.*;
import ddf.minim.*;

import java.awt.Frame;

import gab.opencv.*;
import processing.video.*;
import java.util.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Serial myPort;

String com="COM9";

ControlP5 cp5;
ColorPicker cp;
DropdownList d1;

boolean havePort=true;
int br=0;
boolean a=true;
String mode="Fade";
boolean paintbrush=false;
String s_song="tiger.mp3";
color backgroundColor=130;

int chue=360;
int csat=100;
int cbright=100;
int cnt=0;

int[] queuedSendColor;

String[] songs = {"Eye of the Tiger","Carry on my Wayward Son", "Burn", "Crystallize","Don't Stop Believin'", "Demons", "Everybody Talks", "St. Jimmy","You're Gonna Go Far Kid","Zelda"};
String[] songMP3s = {"tiger.mp3","wayward.mp3","burn.mp3","crystallize.mp3","dontstopbelievin.mp3","demons.mp3","everybodytalks.mp3","jimmy.mp3","gofarkid.mp3","Zelda.mp3"};
AudioPlayer[] songFiles = new AudioPlayer[songMP3s.length];
//220 green blue

Draw3DFrame draw3dFrame;
LightGraffitiFrame lightGraffitiFrame;

void setup()
{
  colorMode(HSB,360,100,100);
  size(650, 700);
  
  minim = new Minim(this);

  for(int i=0;i<songFiles.length;i++)
  {
    songFiles[i]=minim.loadFile(songMP3s[i],2048);
  }
  song=songFiles[0];
  //song = minim.loadFile("tiger.mp3", 2048);
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);
  bl = new BeatListener(beat, song); 
  if(havePort){
  myPort = new Serial(this,com,9600);
  myPort.bufferUntil('\n');}
 
  cp5 = new ControlP5(this);
  
   
  frameRate( 30 );
  smooth(); 
  cp5.setControlFont(new ControlFont(createFont("AgencyFB-Reg-28", 13), 13));
  
  PFont pfont;
  pfont = loadFont("AgencyFB-Reg-28.vlw");
  ControlFont font = new ControlFont(pfont);
  
  d1 = cp5.addDropdownList("songSelection")
          .setPosition(20, 450)
          .setSize(300,150)
          .setId(-5)
          ;
  customize(d1);
  
  CColor g = new CColor();
  
  colorMode(RGB);
  g.setActive(color(75));
  g.setBackground(color(50));
  g.setForeground(color(0));
  colorMode(HSB,360,100,100);
  
  cp5.addButton("Play")
    .setBroadcast(false)
    .setPosition(20,620)
    .setSize(60,35)
    .setValue(0)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;  
    
  cp5.addButton("Pause")
    .setBroadcast(false)
    .setPosition(90,620)
    .setSize(60,35)
    .setValue(1)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  cp5.addButton("Stop")
    .setBroadcast(false)
    .setPosition(160,620)
    .setSize(60,35)
    .setValue(1)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  cp5.addButton("Draw3D")
    .setBroadcast(false)
    .setPosition(425,460)
    .setSize(175,60)
    .setValue(0)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;  
    
  cp5.addButton("Light Graffiti")
    .setBroadcast(false)
    .setPosition(425,545)
    .setSize(175,60)
    .setValue(0)
    .setId(-69)
    .setColor(g)
    .setBroadcast(true)
    ;  
    cp5.addButton("Fade")
    .setBroadcast(false)
    .setColor(g)
    .setPosition(20,45)
    .setSize(90,90)
    .setValue(1)
    .setId(-1)
    .setBroadcast(true)
    ;  
    ((Button)(cp5.getController("Fade"))).captionLabel().style().marginLeft = 20;
  
  cp5.addButton("Flash")
    .setBroadcast(false)
    .setColor(g)
    .setPosition(120,45)
    .setSize(90,90)
    .setValue(1)
    .setId(-1)
    .setBroadcast(true)
    ;  
    ((Button)(cp5.getController("Flash"))).captionLabel().style().marginLeft = 20;
    
  
  cp5.addButton("Multi")
    .setBroadcast(false)
    .setColor(g)
    .setPosition(220,45)
    .setSize(90,90)
    .setValue(1)
    .setId(-1)
    .setBroadcast(true)
    ;  
    ((Button)(cp5.getController("Multi"))).captionLabel().style().marginLeft = 23;
    
   
  cp5.addButton("Seizure")
    .setBroadcast(false)
    .setColor(g)
    .setPosition(320,45)
    .setSize(90,90)
    .setValue(1)
    .setId(-1)
    .setBroadcast(true)
    ;  
    ((Button)(cp5.getController("Seizure"))).captionLabel().style().marginLeft = 10;
  
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
    
    CColor rg = new CColor();
    colorMode(RGB);
    rg.setActive(color(0,255,0));
    rg.setBackground(color(0,220,0));
    rg.setForeground(color(0,200,0));
    
   cp5.addButton("ON")
    .setBroadcast(false)
    .setPosition(490,637)
    .setSize(25,30)
    .setValue(1)
    .setId(-1)
    .setColor(rg)
    .setBroadcast(true)
    ;
    
    rg.setActive(color(255,0,0));
    rg.setBackground(color(220,0,0));
    rg.setForeground(color(200,0,0));
    
   cp5.addButton("OFF")
    .setBroadcast(false)
    .setPosition(515,637)
    .setSize(25,30)
    .setValue(1)
    .setId(-1)
    .setColor(rg)
    .setBroadcast(true)
    ;
    
    colorMode(HSB,360,100,100);
   //font.setSize(10);

     
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
    
  g.setActive(color(80));
  g.setBackground(color(100));
  g.setForeground(color(120));
  
  cp5.addButton("100%")
    .setBroadcast(false)
    .setPosition(120,175)
    .setSize(90,90)
    .setValue(1)
    .setId(-100)
    .setColor(g)
    .setBroadcast(true)
    ;
  
  
  cp5.getController("50%")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
  cp5.getController("100%")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
  cp5.getController("Fade")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
   
  cp5.getController("Flash")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
   
  cp5.getController("Multi")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
    
     ;
  
  cp5.getController("Seizure")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
  cp5.getController("Draw3D")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
  cp5.getController("Light Graffiti")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
   font.setSize(20);
     
   cp5.getController("Play")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
   cp5.getController("Pause")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
   cp5.getController("Stop")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
     
   font.setSize(17);
   cp5.getController("ON")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;  
     
   cp5.getController("OFF")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     ;
  ((Button)(cp5.getController("Draw3D"))).captionLabel().style().marginLeft = 50;
  ((Button)(cp5.getController("Light Graffiti"))).captionLabel().style().marginLeft = 40;
  ((Button)(cp5.getController("Play"))).captionLabel().style().marginLeft = 10;
  ((Button)(cp5.getController("Pause"))).captionLabel().style().marginLeft = 10;
  ((Button)(cp5.getController("Stop"))).captionLabel().style().marginLeft = 10;
}

void customize(DropdownList ddl) {
  PFont pfont;
  pfont = loadFont("AgencyFB-Reg-28.vlw");
  ControlFont font = new ControlFont(pfont);
  font.setSize(18);
  ddl.getCaptionLabel().setFont(font).toUpperCase(false);
  ddl.setBackgroundColor(color(230));
  ddl.setItemHeight(30);
  ddl.setBarHeight(25);
  ddl.captionLabel().set("choose a song");
  ddl.captionLabel().style().marginTop = 7;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  ddl.addItems(songs);
  ddl.setColorBackground(color(60));
  ddl.setColorForeground(color(220));
  ddl.setColorActive(color(150));
  
}

public void controlEvent(ControlEvent c) {
  if (c.isController())
  {
    println("event from controller : "+c.getController().getValue()+" from "+c.getController());
  if(c.getController().getId()>=0)
  {
   chue=c.getController().getId();
   colorMode(RGB,255,255,255);
   int[] background = HSVtoRGB(chue,(int)(csat/2),cbright);
   backgroundColor=color(background[0],background[1],background[2]);
  }
  else if(c.getController().getId()==-100)
  {
    csat=100;
  }
  else if(c.getController().getId()==-50)
  {
    csat=50;
  }
  else if (c.getController().getId() == -69)
  {
    LightGraffiti(1337);
  }
  }
  else if (c.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+c.getGroup().getValue()+" from "+c.getGroup());
       song = songFiles[(int)(c.getGroup().getValue())];
       bl.setSource(song);
  }
}

public void Play(int theValue) {
  song.play();
  bl.setSource(song);
}

public void Pause(int theValue) {
  song.pause();
}

public void Stop(int theValue) {
  stop();
  exit();
}

public void Fade(int theValue) {
  mode="Fade";
}

public void Flash(int theValue) {
  mode="Flash";
}

public void Multi(int theValue) {
  mode="Multi";
}

public void Seizure(int theValue) {
  mode="Seizure";
}

public void ON(int theValue){
  paintbrush=true;
  myPort.write((byte)0xa5);
  myPort.write((byte)0xff);
  myPort.write((byte)0x00);
  myPort.write((byte)0x00);
  myPort.write((byte)0x00);
}
public void OFF(int theValue){
  paintbrush=false;
}

public void Draw3D(int theValue) {
  draw3dFrame = new Draw3DFrame();
}

public void LightGraffiti(int theValue) {
  lightGraffitiFrame = new LightGraffitiFrame();
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
  int[] active = HSVtoRGB(h,(int)(csat/2),cbright);
  CColor col = new CColor();
  col.setForeground(color(foreground[0],foreground[1],foreground[2]));
  col.setBackground(color(background[0],background[1],background[2]));
  col.setActive(color(active[0],active[1],active[2]) );
  return col;
  
}/*
void paintbrushMode()
{
    colorMode(RGB,255,255,255);
    int[] rgb = HSVtoRGB(chue,csat,cbright);
    int[] rgb2 = HSVtoRGB(360,0,0);
    if(myPort.available()>0) a=myPort.read()==97;
    if(a)
    { 
      myPort.write(byte(0xa5));
      myPort.write(byte(0xfc));
      //myPort.write(byte((int)(rgb[0])));
      //myPort.write(byte((int)(rgb[1])));
      //myPort.write(byte((int)(rgb[2])));
      //myPort.write(byte(0xa5));
      //myPort.write(byte(0xfe));
      myPort.write(byte(rgb2[0]));
      myPort.write(byte(rgb2[1]));
      myPort.write(byte(rgb2[2]));
      a=false;
      while(true)
      {
       
      }
    }
 
}*/

void draw()
{
  background(backgroundColor);
  noStroke();
  colorMode(RGB,255);
  textSize(24);
  PFont title, title2, mainFont, brushFont;
  fill(255);
  brushFont = loadFont("ACaslonPro-Bold-18.vlw");
  textFont(brushFont);
  text("paintbrush mode:",446,625);
  title = loadFont("HarlowSolid-42.vlw");
  title2 = loadFont("Gabriola-20.vlw");
  textFont(title);
  text("ArtPress", 450, 50);
  textFont(title2);
  text("by Team FrenchPress",493,75);
  mainFont = loadFont("ACaslonPro-Bold-24.vlw");
  textFont(mainFont);
  text("mode:", 20, 30); 
  text("saturation:", 20, 160); 
  text("color:", 20, 290); 
  text("song:",20,415);
  
  colorMode(HSB,360,100,100);
  if(mode=="Fade")
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
  queuedSendColor = HSVtoRGB(h,s,v);
  
  fill(queuedSendColor[0],queuedSendColor[1],queuedSendColor[2]);
  
  if (draw3dFrame != null)
    draw3dFrame.getApp().setCurrentColor(color(queuedSendColor[0], queuedSendColor[1], queuedSendColor[2]));
}

int[] getHSB(String mode, int range)
{
  int[] hsb = new int[3];
  int h=chue; int s=csat; int b=cbright;
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
  else if(mode=="Flash")
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
  else if(mode=="Multi")
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
  else if(mode=="Seizure")
  {
    s=100;
    h=(int)(random(360));
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
  rgb[0]=(int)(r);
  rgb[1]=(int)(b);
  rgb[2]=(int)(g);
  return rgb;
}

void stop()
{
  song.close();
  minim.stop();
 
  super.stop();
}
 
void serialEvent (Serial port)
{
  String s = port.readString();
  s = trim(s);

  if (s.equals("D") && draw3dFrame != null)
  {
    draw3dFrame.getApp().btnDown();
    delay(5);
  }
  else if (s.equals("ND") && draw3dFrame != null)
  {
    draw3dFrame.getApp().btnUp();
    delay(5);
  }
  else
  {
    myPort.write(byte(0xa5));
    if (paintbrush)
      myPort.write(byte(0xc1));
      else
    myPort.write(byte(0xff));
    //myport.write(queuedWristbandByte);
    if (queuedSendColor != null)
    {
    myPort.write(byte((int)(queuedSendColor[0])));
    myPort.write(byte((int)(queuedSendColor[1])));
    myPort.write(byte((int)(queuedSendColor[2])));
    }
    else
    {
      myPort.write(byte(0));
      myPort.write(byte(0));
      myPort.write(byte(0));
    }
  }
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
  
  void setSource(AudioPlayer a)
  {
    source.removeListener(this);
    source = a;
    source.addListener(this);
  }
}

public class Draw3DFrame extends Frame
{
  Draw3DApp app;
  
  public Draw3DFrame()
  {
    setBounds(0, 0, 800, 600);
    app = new Draw3DApp();
    add(app);
    app.init();
    show();
  }
  
  public Draw3DApp getApp()
  {
    return app;
  }
}

public class Draw3DApp extends PApplet 
{
  Serial port;

  int x1= 0;
  int y1 =0;
  int size1 = 0;
  
  int x2= 0;
  int y2 =0;
  int size2 = 0;
  
  float radsPerPixel = QUARTER_PI / 1024f;
  float ledDistance = 34.036f; //in mm
  
  float voxelSize = 10;
  int gridSize = 20;
  
  int prevGridX = -1, prevGridY = -1, prevGridZ = -1;
  int gridX = -1, gridY = -1, gridZ = -1;
  int glitchesSkipped = 0;
  float maxDrift = voxelSize * 0.25f;
  float glitchDrift = 3f;
  int maxGlitches = 3;
  
  int rotationSafeArea = 60; //pixel border from the edge of the screen
  float rotationSpeed = QUARTER_PI * 0.01f; //radians per pixel
  
  int prevRotX = 0;
  int prevRotY = 0;
  
  float gridRotX = 0;
  float gridRotY = HALF_PI;
  
  boolean isRotating = false;
  boolean isDrawing = false;
  boolean isRemoving = false;
  
  boolean[][][] voxels;
  color[][][] voxelColors;
  
  color curColor;
  
  public Draw3DApp()
  {
    voxels = new boolean[gridSize][gridSize][gridSize];
    voxelColors = new int[gridSize][gridSize][gridSize];
  }
  
  public void setup()
  {
    size(800,600, P3D);
    port = new Serial(this, "COM11", 9600);
    port.bufferUntil('\n');
    float fov = PI/3;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    perspective(fov, (float)width/(float)height, cameraZ/10.0, cameraZ*20.0);
    //perspective(fov, (float)width/(float)height,0.0f, 500f);
  }
  
  public void draw()
  {
    background(209,209,209);
    fill(255,255,255);
    if (size1>0)
    ellipse(x1,y1,size1,size1);
    if (size2>0)
     ellipse(x2,y2,size2,size2);
    if (size1 >0 && size2>0)
    {
      stroke(0,255,0);
      line(x1,y1,x2,y2);
    }
    
    lights();
    noStroke();
    fill(255, 255, 255);
    pushMatrix();
    //translate(512, 384, 50);
    
    float halfFullSize = (gridSize/2) * voxelSize;
    float ballRadius = (gridSize/2) * voxelSize * 2 * sqrt(2);

    camera(cos(gridRotX) * sin(gridRotY) * -ballRadius + halfFullSize,
           cos(gridRotY) * ballRadius + halfFullSize,
           sin(gridRotX) * sin(gridRotY) * -ballRadius + halfFullSize,
           halfFullSize, halfFullSize, halfFullSize,
           0, 1, 0);

    /*int end = (int)(gridSize * voxelSize);
    stroke(255, 255, 255);
    line(0, 0, end, 0, 0, 0);
    line(0, 0, 0, end, 0, 0);
    line(0, 0, 0, 0, 0, end);
    line(end, 0, end, 0, 0, 0);
    line(end, 0, 0, end, 0, 0);
    line(end, 0, 0, 0, 0, end);
    line(0, end, end, 0, 0, 0);
    line(0, end, 0, end, 0, 0);
    line(0, end, 0, 0, 0, end);
    line(0, 0, end, 0, end, 0);
    line(0, 0, 0, end, end, 0);
    line(end, end, 0, 0, end, end);
    line(end, end, 0, 0, end, end);
    line(end, end, 0, 0, end, end);*/

    
    for (int x = 0; x < voxels.length; x++)
    {
      for (int y = 0; y < voxels[0].length; y++)
      {
        for (int z = 0; z < voxels[0][0].length; z++)
        {
          pushMatrix();
          //stroke(255, 255, 255);
          if (voxels[x][y][z])
          {
            noStroke();
            //fill(voxelColors[x][y][z]);
            fill(curColor);
            translate(x * voxelSize, y * voxelSize, z * voxelSize);
            box(voxelSize);
          }
          popMatrix();
        }
      }
    }
    
    noFill();
    stroke(255, 0, 0);
    pushMatrix();
    translate(gridX * voxelSize, gridY * voxelSize, gridZ * voxelSize);
    box(voxelSize);
    popMatrix();
  
    if (gridX >= 0 && gridX < gridSize && gridY >= 0 && gridY < gridSize && gridZ >= 0 && gridZ < gridSize)
    {
      //if (isDrawing)
      {
        voxels[gridX][gridY][gridZ] = true;
        /*voxelColors[gridX][gridY][gridZ] = color(255 - (int)((float)gridX / gridSize * 255), (int)((float)gridY / gridSize * 255), 255 - (int)((float)gridZ / gridSize * 255));*/
        voxelColors[gridX][gridY][gridZ] = curColor;
      }
      //else if (isRemoving)
      {
        //voxels[gridX][gridY][gridZ] = false;
      }
    }
    
    popMatrix();
    
    //println("x: " + gridRotX + "\t, y: " + gridRotY);
  }
  
  public void serialEvent (Serial port)
  {
    try
    {
    String s = port.readString();
    s = trim(s);
    //println(s);
    String[] coords =split(s, ',');
    if (coords.length >4)
    {
      x1 = Integer.parseInt(coords[1]);
      y1 = Integer.parseInt(coords[2]);
      size1 = Integer.parseInt(coords[3])*5;
      x2 = Integer.parseInt(coords[5]);
      y2 = Integer.parseInt(coords[6]);
      size2 = Integer.parseInt(coords[7])*5;
      
      isRotating = false;
      
      int dx = x2 - x1;
      int dy = y2 - y1;
      float distance = sqrt(dx*dx + dy*dy);
      float angle = radsPerPixel * distance / 2;
      float handDist = (ledDistance / 2) / tan(angle);
      
      float ptX = (x1 + x2) * 0.5f;
      float ptY = (y1 + y2) * 0.5f;
      
      float handX = sin(radsPerPixel * (ptX - 512)) * handDist;
      
      float relativeVerticalAngle = (ptY - 384) * radsPerPixel;
      float handY = sin(relativeVerticalAngle) * handDist;

      //rotate X axis
      /*float tmpX = handX;
      float tmpY = handY * cos(gridRotY) - handDist * sin(gridRotY);
      float tmpZ = handY * sin(gridRotY) + handDist * cos(gridRotY);
      
      handX = tmpZ * cos(gridRotX) + tmpX * cos(gridRotX);
      handY = tmpY;
      handDist = tmpZ * cos(gridRotX) - tmpX * cos(gridRotX);*/

      //println("(" + handX + ", " + handY + ", " + handDist + ")");
      
      int driftX = gridX - prevGridX;
      int driftY = gridY - prevGridY;
      int driftZ = gridZ - prevGridZ;
      
      float driftXZ = sqrt(driftX*driftX + driftZ*driftZ);
      float drift = sqrt(driftY*driftY + driftXZ*driftXZ);
     
      if (drift >= glitchDrift)
        glitchesSkipped++;
        
      if (drift <= maxDrift || glitchesSkipped > maxGlitches)
      {
        prevGridX = gridX;
        prevGridY = gridY;
        prevGridZ = gridZ;
        
        gridX = (int)(handX / voxelSize) + (gridSize/2);
        gridY = (int)(handY / voxelSize) + (gridSize/2);
        gridZ = (int)(handDist / voxelSize) - gridSize;
        
        /*gridX = (int)(handX / voxelSize);
        gridY = (int)(handY / voxelSize);
        gridZ = (int)(handDist / voxelSize);*/

        glitchesSkipped = 0;
      }
      else
        glitchesSkipped++;
    }
    else if (coords.length>1)
    {
      x1 = Integer.parseInt(coords[1]);
      y1 = Integer.parseInt(coords[2]);
      size1 = Integer.parseInt(coords[3])*5;
      
      size2=0;
      
      if (x1 > rotationSafeArea && x1 < width - rotationSafeArea && y1 > rotationSafeArea && y1 < height - rotationSafeArea)
      {
        if (isRotating)
        {
          gridRotX += (x1 - prevRotX) * rotationSpeed;
          gridRotY += (y1 - prevRotY) * rotationSpeed;
         
          gridRotX %= TWO_PI;
          if (gridRotY > PI)
            gridRotY = PI - 0.00001f;
          if (gridRotY < 0)
            gridRotY = 0.00001f; 
        }
        
        prevRotX = x1;
        prevRotY = y1;
        
        isRotating = true;
      }
    }
    else
    {
      size1=0;
      size2=0;
      isRotating = false;
    }
    }
    catch (Exception e)
    {
    }
  }
  
  public void keyPressed()
  {
    if (key == 32)
    {
      for (int x = 0; x < voxels.length; x++)
      {
        for (int y = 0; y < voxels[0].length; y++)
        {
          for (int z = 0; z < voxels[0][0].length; z++)
          {
            voxels[x][y][z] = false;
          }
        }
      }
    }
    
    if (key == 97)
    {
      exit();
    }
  }
  
  public void setCurrentColor(color c)
  {
    curColor = c;
  }
  
  public void btnDown()
  {
    btnUp();
    if (gridX >= 0 && gridX < gridSize && gridY >= 0 && gridY < gridSize && gridZ >= 0 && gridZ < gridSize)
    {
      if (voxels[gridX][gridY][gridZ])
        isRemoving = true;
      else
        isDrawing = true;
    }
    else
    {
      isDrawing = true;
    }
    
    println(isRemoving + ", " + isDrawing);
  }
  
  public void btnUp()
  {
    isDrawing = false;
    isRemoving = false;
    
  }
}

public class LightGraffitiFrame extends Frame
{
  LightGraffitiApp app;
  
  public LightGraffitiFrame()
  {
    setBounds(0, 0, 640, 480);
    app = new LightGraffitiApp();
    add(app);
    app.init();
    show();
  }
  
  public LightGraffitiApp getApp()
  {
    return app;
  }
}

public class LightGraffitiApp extends PApplet
{
  Capture video;
OpenCV opencv;
Serial myPort;
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Integer> curveColors = new ArrayList<Integer>();
ArrayList<Integer> intervals = new ArrayList<Integer>();
color winning;

void setup() {
  //size(1280, 720);
  size(640,480);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  //myPort = new Serial(this,"COM9",9600);
  //myPort.wr
  video.start();
}
boolean drawnow = false;
int locx,locy;
int mod = 35;

void draw() {
  
  opencv.loadImage(video);
  image(video, 0, 0); 
  if(drawnow){
  
  //filter(ERODE);
  // filter(POSTERIZE,180);
  filter(DILATE);
  filter(ERODE);
 //filter(POSTERIZE,240);
  PVector loc = opencv.max();
  if(brightness(get(int(loc.x),int(loc.y))) < 230)
  {
    drawHistory();
    return;
  }
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
  //noFill();
  //troke(0);
  //fill(0);
 /* rect(locx-20-150,locy-75,150,150);
  rect(locx+20,locy-75,150,150);
  rect(locx-75,locy-150-20,150,150);
  rect(locx-75,locy+20,150,150);*/
 //println(opencv.max());
  float highest = 0.0;
  PVector aux = new PVector();
  for(PVector v : tests)
  {//(abs(v.x - loc.x) < 75) && (abs(v.y - loc.y) < 75) &&(abs(v.x - loc.x) < 100) && (abs(v.y - loc.y) < 100) &&
   //println(abs(v.x - loc.x), abs(v.y - loc.y));
   if((abs(v.x - loc.x) >5 || abs(v.y - loc.y) > 5) && (brightness(get(int(v.x),int(v.y))) > highest))
   {
    highest =  brightness(get(int(v.x),int(v.y)));
    aux = v;
   }
   else
   {
     //this.draw();
   // println("ELSEWAT"); 
   }
  }
  //println(second);
  
  
  
  float locbackupx = loc.x;
  float locbackupy = loc.y;
  
  PVector hax = new PVector();
  hax = PVector.sub(loc,aux);
  hax.normalize();
  hax.mult(5);
  //println(loc);
  loc.add(hax);

  locx = int(loc.x);
  locy = int(loc.y);
  if(points.size()>0)
  {
    if (dist(loc.x,loc.y, points.get(points.size()-1).x,points.get(points.size()-1).y) > dist(aux.x,aux.y, points.get(points.size()-1).x,points.get(points.size()-1).y))
    {
      PVector tempy = new PVector();
      tempy = loc;
      loc = aux;
      aux = tempy;
    }
  }
  
 // ellipse(int(aux.x),int(aux.y),8,8);
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
  
  //ellipse(locx,locy,8,8);
    strokeWeight(8);
    
    if(winning != nextcolor)//nextcolor != opencv.in && nextcolor != slickblack  && winning != nextcolor)
    {
      //println(red(color(get(int(loc.x),int(loc.y)))),green(color(get(int(loc.x),int(loc.y)))),blue(color(get(int(loc.x),int(loc.y)))));
      winning = color(red(color(get(int(loc.x),int(loc.y)))),green(color(get(int(loc.x),int(loc.y)))),blue(color(get(int(loc.x),int(loc.y)))));
      
    }
    
  }
  drawHistory();
  
  points.add(new PVector(locbackupx,locbackupy));
  //olor test = color(red(winning),green(winning),blue(winning),alpha(winning)-1);
  curveColors.add(winning);
  intervals.add((Integer)(millis()));
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

void drawHistory()
{
    for(int p=0; p<points.size(); p++)
  {   
    if(points.size() > p+1){
       stroke(int(curveColors.get(p)));
       fill(int(curveColors.get(p)));
       //ellipse(points.get(p).x, points.get(p).y, 8, 8);
      if(intervals.get(p+1)-intervals.get(p) < 1000)
      {
        strokeWeight(8);
        line(points.get(p).x, points.get(p).y, points.get(p+1).x,points.get(p+1).y);
      }

    }
  }
}
}
