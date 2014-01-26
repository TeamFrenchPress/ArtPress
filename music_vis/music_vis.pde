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
DropdownList d1;

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

String[] songs = {"Eye of the Tiger","Carry on my Wayward Son", "Burn", "Crystallize", "Demons", "Everybody Talks", "St. Jimmy"};
String[] songMP3s = {"tiger.mp3","wayward.mp3","burn.mp3","crystallize.mp3","demons.mp3","everybodytalks.mp3","jimmy.mp3"};
AudioPlayer[] songFiles = new AudioPlayer[songMP3s.length];
//220 green blue

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
  
  myPort = new Serial(this,"COM4",9600);
  myPort.bufferUntil('\n');
 
  cp5 = new ControlP5(this);
  
  frameRate( 30 );
  smooth();
  
  d1 = cp5.addDropdownList("songSelection")
          .setPosition(20, 450)
          .setSize(200,200)
          .setId(-5)
          ;
  customize(d1);
  
  CColor g = new CColor();
  
  //PFont pfont = createFont("ACaslonPro-Bold",16,true); // use true/false for smooth/no-smooth
  //ControlFont font = new ControlFont(pfont,16);
 /* g.setActive(color(180));
  g.setBackground(color(200));
  g.setForeground(color(220));*/

  colorMode(RGB);
  g.setActive(color(75));
  g.setBackground(color(50));
  g.setForeground(color(0));
  colorMode(HSB,360,100,100);
  
  cp5.addButton("Play")
    .setBroadcast(false)
    .setPosition(240,470)
    .setSize(48,20)
    .setValue(0)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;  
    
  cp5.addButton("Pause")
    .setBroadcast(false)
    .setPosition(290,470)
    .setSize(48,20)
    .setValue(1)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  cp5.addButton("Stop")
    .setBroadcast(false)
    .setPosition(340,470)
    .setSize(48,20)
    .setValue(1)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;
    
  cp5.addButton("Robert's Button")
    .setBroadcast(false)
    .setPosition(20,650)
    .setSize(80,20)
    .setValue(0)
    .setId(-1)
    .setColor(g)
    .setBroadcast(true)
    ;  
    
  cp5.addButton("Michael's Button")
    .setBroadcast(false)
    .setPosition(120,650)
    .setSize(80,20)
    .setValue(0)
    .setId(-1)
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
    ((Button)(cp5.getController("Seizure"))).captionLabel().style().marginLeft = 15;
  
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
    
    
  PFont pfont2 = createFont("Arial",16,true); // use true/false for smooth/no-smooth
  ControlFont font2 = new ControlFont(pfont2,14);
  
  cp5.getController("50%")
     .getCaptionLabel()
     .setFont(font2)
     .toUpperCase(false)
     ;
     
  cp5.getController("100%")
     .getCaptionLabel()
     .setFont(font2)
     .toUpperCase(false)
     ;
  cp5.getController("Fade")
     .getCaptionLabel()
     .setFont(font2)
     .toUpperCase(false)
     
     ;
   
  cp5.getController("Flash")
     .getCaptionLabel()
     .setFont(font2)
     .toUpperCase(false)
     ;
   
  cp5.getController("Multi")
     .getCaptionLabel()
     .setFont(font2)
     .toUpperCase(false)
     ;
  
  cp5.getController("Seizure")
     .getCaptionLabel()
     .setFont(font2)
     .toUpperCase(false)
     ;
     
    
  /*cp5.addCheckBox("CheckBox")
    .setPosition(100,200)
    .setSize(20,20)
    .addItem("Light Graffiti Mode",0);
    ;
 */
    
} 

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(230));
  ddl.setItemHeight(25);
  ddl.setBarHeight(23);
  ddl.captionLabel().set("choose a song");
  ddl.captionLabel().style().marginTop = 7;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  for(int i=0;i<7;i++){
    ddl.addItem(songs[i],i);
  }
  //ddl.addItems(songs);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
  
}

public void controlEvent(ControlEvent c) {
  if (c.isController())
  {
    println("event from controller : "+c.getController().getValue()+" from "+c.getController());
  if(c.getController().getId()>=0)
  {
   chue=c.getController().getId();
   colorMode(RGB,255,255,255);
   int[] background = HSVtoRGB(chue,int(csat/2),cbright);
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
  }
  else if (c.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+c.getGroup().getValue()+" from "+c.getGroup());
       song = songFiles[int(c.getGroup().getValue())];
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
  background(backgroundColor);
  noStroke();
  colorMode(RGB,255);
  textSize(24);
  PFont title;
  PFont mainFont;
  
  fill(255);
  title = loadFont("HarlowSolid-42.vlw");
  textFont(title);
  text("ArtPress", 450, 50);
  mainFont = loadFont("ACaslonPro-Bold-24.vlw");
  textFont(mainFont);
  text("mode:", 20, 30); 
  text("saturation:", 20, 160); 
  text("color:", 20, 290); 
  text("song:",20,415);
  
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
  
  void setSource(AudioPlayer a)
  {
    source.removeListener(this);
    source = a;
    source.addListener(this);
  }
}
