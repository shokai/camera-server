import processing.video.*;

Capture camera;
PImage img;

void setup(){
    size(320, 240); // width, height
    camera = new Capture(this, width, height, 12); // 12fps
}

void draw(){
    image(camera, 0, 0);
    saveFrame("camera.jpg"); // capture
    delay(1000);
}

void captureEvent(Capture camera){
    camera.read();
}
