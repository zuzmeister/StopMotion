/***

StopMotion Maker

date:    2017-07-08
author:  t.zuber

# Press Space to Take a Picture
# Press CURSOR-LEFT / CURSOR-RIGHT to switch the Camera


## wechseln der Kameras (bzw. KameraModi) nun mit Pfeiltasten möglich
## noch kleine Bugs vorhanden :/

## Um aus den *.jpeg Bildern einen Film zu erzeugen...
(wenn noch nicht installiert: installiere ffmpeg)

+ öffne Terminal  
+ $ cd %APPDIR%/app/%AUFNAHMEDATUM%/
+ $ ffmpeg -r 8 -f image2 -i %05d.jpg -vcodec libx264 -crf 25  -pix_fmt yuv420p output.mp4

***/

import processing.video.*;

Capture cam = null;
String[] cameras = null;
int camX = 1280;
int camY = 1024;
PImage oldImg; // Zuletzt aufgenommener/gespeicherter Frame. Wird im Hintergrund angezeigt, zwecks Onion-Skinning.

float offset = 0; //obsolet? 

int count = 0; // Anzahl der Bilder, die aufgezeichnet/gespeichert wurden.
int camIndex = 0; // Adresse der Kamera-Quelle, die am Bildschirm ausgegeben werden soll 

/// Timestamp - beginn
int year = year();
int month = month();
int day = day();
int hour = hour();
int minute = minute();
int second = second();
String date= year+"-"+month+"-"+day+"_"+hour+"-"+minute+"-"+second;
//// end

void setup() {
  fullScreen();
  noStroke();

  cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Number of available cameras: "+cameras.length+"\n");
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println("cameras["+i+"] ......"+cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    /**
    cameras[X] --> anstelle von X die Zahl für die gewünschte Kamera (und deren Resolution) eintragen (siehe Output in der Konsole)
    **/
    
    switchCam(camIndex); //aktiviere 
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
  if (key == ' ') {
    //do{
      if (cam.available() == true) {
        cam.read();
      }
        try{
          image(cam, 0, 0);
          cam.save(dataPath("")+"/"+date+"/"+nf(count,5)+".jpg");
          println("Image Captured......"+dataPath("")+"/"+date+"/"+nf(count,5)+".jpg");
          oldImg.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
          oldImg.updatePixels();
          ++count;
        }catch(Exception e){
          println("-------An Error Occurred Capturing/Saving an Image ---------");
        }
    //}while(repeat<50); 
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      switchCam(camIndex+1);
    }
    if (keyCode == LEFT) {
      switchCam(camIndex-1);
    }
  }
}

void switchCam(int i){
  if(i<0)
    camIndex=0;
  else if(i>=cameras.length)
    camIndex= cameras.length - 1;
  else
    camIndex=i;
  try{
    cam = null;
    cam = new Capture(this, cameras[camIndex]);
    cam.start();
    println("\n\n-------------");
    println("Switching to Camera: cameras["+camIndex+"] ......"+cameras[camIndex]);
  }catch(Exception e){
    println("-------ERROR------ An error occurred switching the camera.");
  }
}