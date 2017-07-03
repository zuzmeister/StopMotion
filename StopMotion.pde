import processing.video.*;

Capture cam;
int camX = 1280;
int camY = 1024;
PImage oldImg;
float offset = 0;
int count = 0;

int year = year();
int month = month();
int day = day();
int hour = hour();
int minute = minute();
int second = second();
String date= year+"-"+month+"-"+day+"_"+hour+"-"+minute+"-"+second;

void setup() {
  fullScreen();
  //size(1280, 1024);
  noStroke();

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }  
  
  //oldImg initialisieren...wird eine reine weiße fläche.
  
  oldImg = createImage(camX, camY, RGB);
  oldImg.loadPixels();
  for (int i = 0; i < oldImg.pixels.length; i++) {
    oldImg.pixels[i] = color(100, 100, 100); 
  }
  oldImg.updatePixels();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  if(count!=0)
  {
    tint(255, 127);
    image(oldImg, 0, 0);
  }
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void keyPressed() {
  int keyIndex = -1;
  if (key == ' ') {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
    cam.save(dataPath("")+"/"+date+"/images/"+nf(count,5)+".jpg");
    oldImg.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
    oldImg.updatePixels();
    
    ///saveFrame("/Users/zuzi/images/captured-####.jpg");
    ++count;
  }
}
