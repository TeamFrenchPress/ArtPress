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

int gridX = -1, gridY = -1, gridZ = -1;

int spin;

boolean[][][] voxels; 

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
  
  camera(0, 0, 0, (gridSize/2), (gridSize/2), (gridSize/2), 0, 1, 0);
  
  for (int x = 0; x < voxels.length; x++)
  {
    for (int y = 0; y < voxels[0].length; y++)
    {
      for (int z = 0; z < voxels[0][0].length; z++)
      {
        if (voxels[x][y][z])
        {
          pushMatrix();
          translate(x * voxelSize, y * voxelSize, z * voxelSize);
          //rotateY((spin / 20f));
          box(voxelSize);
          popMatrix();
        }
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
    voxels[gridX][gridY][gridZ] = true;
  
  popMatrix();
  
  spin++;
}

void serialEvent (Serial port)
{
  String s = port.readString();
  s = trim(s);
  //println(s);
  String[] coords =split(s, ',');
  if (coords.length>1)
  {
    x1 = Integer.parseInt(coords[1]);
    y1 = Integer.parseInt(coords[2]);
    size1 = Integer.parseInt(coords[3])*5;
  }
  else
  {
    size1=0;
    size2=0;
  }
  if (coords.length >4)
   {
    x2 = Integer.parseInt(coords[5]);
    y2 = Integer.parseInt(coords[6]);
    size2 = Integer.parseInt(coords[7])*5;
    
    int dx = x2 - x1;
    int dy = y2 - y1;
    float distance = sqrt(dx*dx + dy*dy);
    float angle = radsPerPixel * distance / 2;
    float headDist = (ledDistance / 2) / tan(angle);
    
    float ptX = (x1 + x2) * 0.5f;
    float ptY = (y1 + y2) * 0.5f;
    
    float headX = sin(radsPerPixel * (ptX - 512)) * headDist;
    
    float relativeVerticalAngle = (ptY - 384) * radsPerPixel;
    float headY = sin(relativeVerticalAngle) * headDist;
    
    println("(" + headX + ", " + headY + ", " + headDist + ")");
    
    gridX = int(headX / voxelSize) + (gridSize/2);
    gridY = int(headY / voxelSize) + (gridSize/2);
    gridZ = int(headDist / voxelSize) - gridSize/2;
  }
  else 
  {
    size2=0;
  }
}
