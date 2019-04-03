/* This example is based on Florian Bruggisser's examples for his 
RealSense for Processing library

OSC functionality is from the oscP5 examples by Andreas Schleger

Inspiration from Daniel Schiffman's average point hand tracking with Kinect
https://www.youtube.com/watch?v=Kr4s5sLoROY&list=PLRqwX-V7Uu6ZMlWHdcy8hAGDy6IaoxUKf&index=4

Elias Berkhout, Interactive Media Lab
UNSW Art & Design
*/

import ch.bildspur.realsense.*;
import oscP5.*;
import netP5.*;

// instantiate realsense camera
RealSenseCamera camera = new RealSenseCamera(this);

// create net address for osc
NetAddress myRemoteLocation;

// assign min and max thresholds for area of focus
int minThresh = 300;
int maxThresh = 600;

// variables for averaging out location values
int currentSample = 0;
int sampleSize = 16;

void setup()
{
  size(640, 480);

  // width, height, fps, depth-stream, color-stream
  camera.start(640, 480, 30, true, true);
  
  // send the osc messages on port 12345
  myRemoteLocation = new NetAddress("127.0.0.1", 12345);
}

void draw(){
  background(0);
  
  // read frames
  camera.readFrames();
  camera.createDepthImage(minThresh, maxThresh);

  // show color image
  image(camera.getDepthImage(), 0, 0);
  
  // create variables for finding pixels of interest
  int skip = 3;
  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;
  float z = 0;
  for (int x = 0; x < width; x+=skip){
    for (int y = 0; y < height; y+=skip){
    z = camera.getDepth(x, y);
    
    // if the depth reading of pixels is within
    // minThresh and maxThresh, draw rectangles there
    if (z > minThresh && z < maxThresh){
       fill(200, 0, 200);
       rect(x, y, skip, skip);
       sumX += x;
       sumY += y;
       totalPixels++;
       }
    }
  }
  
  // create variables to find the central point of pixels of interest
  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  float avgZ = 0;
  float[] vals = new float[sampleSize];

  // average those values
  if(currentSample == sampleSize) currentSample = 0;
    vals[currentSample] = z;
    for(int i = 0; i < sampleSize; i++){
      avgZ += vals[i];
    }
    avgZ/=sampleSize;
  
  // draw a circle at the centre of the pixels
  fill(0, 150, 255);
  ellipse(avgX, avgY, 20, 20);
  
  // send values to the OSCsend function below
  OSCsend(avgX, avgY, avgZ);
  
  // increase current sample variable for averaging
  currentSample++;
  
  // display some other info
  fill(255);
  //color(255);
  text("threshold: " + minThresh + "  " +  "framerate: " + int(frameRate) + "  " +
    "UP increase threshold, DOWN decrease threshold", 100, 470);
 
}

void keyPressed(){
  
  // up and down arrows to increase/decrease threshold
  if(key == CODED){
     if(keyCode == UP){
       minThresh +=5;
       maxThresh +=5;
     }
     else if(keyCode == DOWN){
       minThresh -=5;
       maxThresh -=5;
       }
    }
}

void OSCsend(float x, float y, float z) {
  // create the osc message
  OscMessage myOscMessage = new OscMessage("/xyz");
  
  // add coordinates to osc message
  myOscMessage.add(x);
  myOscMessage.add(y);
  myOscMessage.add(z);
  
  // send the OscMessage to the remote location. 
  OscP5.flush(myOscMessage,myRemoteLocation);
}
