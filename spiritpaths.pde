import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
PImage prevFrame, prevDiff;


Boolean BACKGROUND_SUBTRACTION = false;   //Enable background subtraction
Boolean EROSION = false;                  // Enable erode FX
Boolean DILATION = false;                 // Enable dilate FX
int BLUR_FX = 0;                  // Enable blurring
int BLEND_MODE = LIGHTEST;                // SCREEN (256) | LIGHTEST (8)
//   Use LIGHTEST blend mode to see only moving spirits
//   Use SCREEN blend mode to see spirits and background
int BRIGHTNESS = 0;
int TRAILS = 0;


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


  opencv.diff(prevFrame);

  if (BLUR_FX > 0) {
    opencv.blur(BLUR_FX);
  } else {
    BLUR_FX = 0;
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

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      BRIGHTNESS++;
      println("BRIGHTNESS: ", BRIGHTNESS);
    } else if (keyCode == DOWN) {
      BRIGHTNESS--;
      println("BRIGHTNESS: ", BRIGHTNESS);
    } else if (keyCode == LEFT) {
      TRAILS--;
      println("TRAILS: ", TRAILS);
    } else if (keyCode == RIGHT) {
      TRAILS++;
      println("TRAILS: ", TRAILS);
    }
  } else {
    println("KEYVAL: ", key);
    if (key == 'b') {
      BACKGROUND_SUBTRACTION = !BACKGROUND_SUBTRACTION;
      if (BACKGROUND_SUBTRACTION) opencv.startBackgroundSubtraction(5, 2, 0.5);
      println("bg sub: ", key, BACKGROUND_SUBTRACTION);
    } else if (key == 'e') {
      EROSION = !EROSION;
      println("erosion: ", EROSION);
    } else if (key == 'd') {
      DILATION = !DILATION;
      println("dilation: ", DILATION);
    } else if (key == 'w') {
      BLUR_FX++;
      println("BLUR_FX: ", BLUR_FX);
    } else if (key == 's') {
      BLUR_FX--;
      println("BLUR_FX: ", BLUR_FX);
    }
}
  // B : toggle background capture
  // E : toggle erosion
  // D : toggle dilation
  // 1 : blend mode 1: LIGHTNESS
  // 2 : blend mode 2: SCREEN
}


// Haven't found a use for this event yet; just leaving it here as a reminder
//void captureEvent(Capture c) {
//  //c.read();
//}

