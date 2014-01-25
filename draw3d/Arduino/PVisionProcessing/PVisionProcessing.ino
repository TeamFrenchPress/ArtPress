// Example of using the PVision library for interaction with the Pixart sensor on a WiiMote
// This work was derived from Kako's excellent Japanese website
// http://www.kako.com/neta/2007-001/2007-001.html

// Steve Hobley 2009 - www.stephenhobley.com

#include <Wire.h>
#include <PVision.h>

PVision ircam;
byte result;

void setup()
{
  Serial.begin(9600);
  ircam.init();
}

void loop()
{
   
  result = ircam.read();
  
  if (result & BLOB1)
  {
    Serial.print("BLOB1:,");
    Serial.print(ircam.Blob1.X);
    Serial.print(',');
    Serial.print(ircam.Blob1.Y);
    Serial.print(',');
    Serial.print(ircam.Blob1.Size);
  }
  if (result & BLOB2)
  {
    if (!(result & BLOB1))
    {
      Serial.print("BLOB1:,");
    Serial.print("0");
    Serial.print(',');
    Serial.print("0");
    Serial.print(',');
    Serial.print("0");
    }
    Serial.print(",BLOB2:,");
    Serial.print(ircam.Blob2.X);
    Serial.print(',');
    Serial.print(ircam.Blob2.Y);
    Serial.print(',');
    Serial.print(ircam.Blob2.Size);
  }
  
  Serial.println("");

  // Short delay...
  delay(100);
  

}
