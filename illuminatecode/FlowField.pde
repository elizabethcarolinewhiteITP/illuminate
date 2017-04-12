
class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; 
  int resolution; 
  float zoff = 0;
  FlowField(int r) {
    resolution = r;
    //resolution /= 2;

    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    //noiseSeed((int)random(10000));
  }

  void update() {
    // Reseed noise so we get a new flow field every time
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(xoff, yoff, zoff), 0, 1, 0, TWO_PI*3);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        PVector v1 = new PVector(cos(theta), sin(theta));

        float x = i*resolution;
        float y = j*resolution;
        
        PVector v4 = tracker.getPos();
        
        //PVector v2 = new PVector(v4.x*2.2 - x, v4.y*2.2 - y);
        PVector v2 = new PVector(v4.x*2.2 - x, v4.y*2 - y);
        v2.normalize();
        
        PVector v3 = new PVector(v2.x+v2.x,v1.y+v2.y);
        v3.normalize();
        
        //field[i][j] = v3.mult(10);
        field[i][j] = v3;
        
        //if (j < 3*(rows/4)) {
        //  field[i][j] = v3.mult(2);
        //}

        yoff += 0.05;
      }
      xoff += 0.05;
    }
    zoff += 0.001;
  }

  // Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*resolution, j*resolution, resolution-2);
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x, y);
    stroke(0);
    // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    rotate(v.heading());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].get();
  }
}