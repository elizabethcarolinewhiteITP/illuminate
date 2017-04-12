class KinectTracker {
  // Depth threshold
  int threshold = 1003;
  // Raw location
  PVector loc;
  // Interpolated location
  PVector lerpedLoc;
  // Depth data
  int[] depth;
  // What we'll show the user
  PImage display;
  KinectTracker() {
    kinect.initDepth();
    kinect.enableMirror(false);
    display = createImage(kinect.width, kinect.height, ARGB);
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    depth = kinect.getRawDepth();
    isJump = true;
    if (depth == null) return;
    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        int offset =  x + y*kinect.width;
        int rawDepth = depth[offset];

        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;

          if (y > jumpHeight) {
            isJump = false;
          }
        }
      }
    }
    //println(isJump);
    if (count != 0) {
      loc = new PVector(sumX/count, sumY/count);
    }
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect.getDepthImage();
    if (depth == null || img == null) return;
    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        int offset = x + y * kinect.width;
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        if (rawDepth < threshold) {
          display.pixels[pix] = color(255, 0, 0);
        } else {
          display.pixels[pix] = img.pixels[offset];
        }
      }
    }
    display.updatePixels();
    image(display, 0, 0, displayWidth, displayHeight);
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}