import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
PImage prevFrame, prevDiff;


Boolean BACKGROUND_SUBTRACTION = false;   //Enable background subtraction
Boolean EROSION = false;                  // Enable erode FX
Boolean DILATION = false;                 // Enable dilate FX
Boolean BLUR_FX = false;                  // Enable blurring
int BLEND_MODE = LIGHTEST;                // SCREEN (256) | LIGHTEST (8)
//   Use LIGHTEST blend mode to see only moving spirits
//   Use SCREEN blend mode to see spirits and background


void setup() {
  size(640, 480, OPENGL);

  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  //opencv.useColor();
  video.start();
  //opencv.loadImage(video);
  prevFrame = new PImage(width, height, RGB);
  prevDiff = new PImage(width, height, RGB);
  prevFrame.set(0, 0, 0);
  prevDiff.set(0, 0, 0);

  if (BACKGROUND_SUBTRACTION) opencv.startBackgroundSubtraction(5, 2, 0.5);

  println("Screen int ", SCREEN, "LIGHTEST int ", LIGHTEST);
}

void draw() {
  video.read();
  opencv.loadImage(video);
  if (BACKGROUND_SUBTRACTION) opencv.updateBackground();

  PImage orig = opencv.getSnapshot();

  opencv.dilate(); // Creates better outlines of static objects between diffed frames
  opencv.blur(8); // Creates better outlines of static objects between diffed frames

  opencv.diff(prevFrame);

  if (BLUR_FX) {
    opencv.blur(20);
  }

  if (DILATION) {
    opencv.dilate();
    opencv.dilate();
    opencv.dilate();
  }

  if (EROSION) {
    opencv.erode();
    opencv.erode();
    opencv.erode();
  }

  PImage output1 = opencv.getSnapshot();
  output1.blend(prevDiff, 0, 0, video.width, video.height, 0, 0, video.width, video.height, BLEND_MODE);


// Messing around with inverting light/dark...
//  opencv.loadImage(output1);
//  opencv.invert();
//  opencv.adaptiveThreshold(300, 1);
//
//  PImage output = opencv.getSnapshot();
//  image(output, 0, 0 );
  
  image(output1, 0, 0 );
  
  
  // Save frame & diff output for next frame cycle
  prevFrame = orig;
  prevDiff = output1;
}

// Haven't found a use for this event yet; just leaving it here as a reminder
//void captureEvent(Capture c) {
//  //c.read();
//}

