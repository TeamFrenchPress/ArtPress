import processing.serial.*;
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

boolean[][][] voxels;
color[][][] voxelColors;

void setup()
{
  size(1024,768, P3D);
  port = new Serial(this, "COM7", 9600);
  port.bufferUntil('\n');
  float fov = PI/3;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*20.0);
  //perspective(fov, float(width)/float(height),0.0f, 500f);
  
  voxels = new boolean[gridSize][gridSize][gridSize];
  voxelColors = new int[gridSize][gridSize][gridSize];
}

void draw()
{
  background(0,0,0);
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
  
  //camera(/*voxelSize * (gridSize + 1)*/ -voxelSize * 3, /*voxelSize * (gridSize + 1)*/ -voxelSize * 4, voxelSize * (gridSize + 5), (gridSize/2) * voxelSize, (gridSize/2) * voxelSize, (gridSize/2) * voxelSize, 0, 1, 0);
  camera(cos(gridRotX) * sin(gridRotY) * -ballRadius + halfFullSize,
         cos(gridRotY) * ballRadius + halfFullSize,
         sin(gridRotX) * sin(gridRotY) * -ballRadius + halfFullSize,
         halfFullSize, halfFullSize, halfFullSize,
         0, 1, 0);
  
  /*int end = int(gridSize * voxelSize);
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
          fill(voxelColors[x][y][z]);
          translate(x * voxelSize, y * voxelSize, z * voxelSize);
          box(voxelSize);
        }
        else if (x % 3 == 0 && y % 3 == 0 && z % 3 == 0)
        {
          /*noFill();
          translate(x * voxelSize, y * voxelSize, z * voxelSize);
          box(voxelSize);*/
        }
        
        popMatrix();
      }
    }
  }
  
  noFill();
  stroke(255, 0, 0);
  
  if (gridX >= 0 && gridX < gridSize && gridY >= 0 && gridY < gridSize && gridZ >= 0 && gridZ < gridSize)
  {
    pushMatrix();
    translate(gridX * voxelSize, gridY * voxelSize, gridZ * voxelSize);
    box(voxelSize);
    popMatrix();
  
    voxels[gridX][gridY][gridZ] = true;
    voxelColors[gridX][gridY][gridZ] = color(255 - int(float(gridX) / gridSize * 255), int(float(gridY) / gridSize * 255), 255 - int(float(gridZ) / gridSize * 255));
  }
  
  popMatrix();
  
  //println("x: " + gridRotX + "\t, y: " + gridRotY);
}

void serialEvent (Serial port)
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
    float tmpY = handY * cos(-gridRotY) - handDist * sin(-gridRotY);
    float tmpZ = handY * sin(-gridRotY) + handDist * cos(-gridRotY);
    
    handX = tmpZ * cos(gridRotX) + tmpX * cos(gridRotX);
    handY = tmpY;
    handDist = tmpZ * cos(gridRotX) - tmpX * cos(gridRotX);*/
    
    println("(" + handX + ", " + handY + ", " + handDist + ")");
    
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
      
      gridX = int(handX / voxelSize) + (gridSize/2);
      gridY = int(handY / voxelSize) + (gridSize/2);
      gridZ = int(handDist / voxelSize) - gridSize;
      
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
        
        prevRotX = x1;
        prevRotY = y1;
      }
      
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

void keyPressed()
{
  
}
