/***
StopMotion Maker
date:    2017-07-08 bis 2018-11-20
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

/*
Änderungen zur letzten Version:
 # Frames werden nicht mehr "Data"-Folder gespeichert, weil dieser Folder innerhalb des *.app-Paketes liegt (schwierig zu finden für N00bs)
 # Kameras werden nun "im Kreis" durch-iteriert (wenn man am Ende der Kameraliste ankommt, wird wieder zur ersten Kamera gesprungen)
 # Es werden nur mehr Kameramodi unterstützt, die 30fps unterstützen. Alle anderen werden übersprungen.
 # "Debug-Text" am Bildschirm wird nun korrekt (nicht verschwommen/zerfranst dargestellt)
 # Es gibt kein/e Ghosting/Artefakte veralteten Bildinformationen mehr.
*/

/**
DAS HIER SOLLTE ICH VIELLEICHT VORHER LESEN... 
--> https://processing.org/reference/libraries/video/Capture.html

Tutorials: 
https://www.youtube.com/watch?v=WH31daSj4nc

wer .start() aufruft, sollte auch .stop() machen.
alles stoppen, wenn programm beendet wird (void stop())

bzgl. "run code on exit":
https://forum.processing.org/one/topic/run-code-on-exit.html

Ansonsten:
Zur Sicherheit einfch mal  System.gc(); und  Runtime.getRuntime().gc(); regelmäßig aufrufen.
*/

import processing.video.*;

boolean DEBUG = true;
int programmstatus = 0;

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

PFont font; // wird benötigt, um Schriftart zu laden
PGraphics screenreset;

void setup() {
    //fullScreen();
    size(1280, 1024);
    background(250);
  noStroke();
  //lade schriftart, zum Anzeigen von Debug-Infomationen
  font = createFont("Dialog-24.vlw",24,true);
  
  screenreset = createGraphics(width, height);
  screenreset.beginDraw();
  screenreset.background(51);
  screenreset.endDraw();
  
  // hier code einfügen, damit schon während dem "info-Text" die Kameramodi angezeigt werden...
}

void draw() {
  /* zeige Informationen bei Programmstart an...*/
  switch(programmstatus){
    default:
      hauptProgramm();
      break;
    case 0:
      infoText();
      break;
    case 1:
      loading();
      programmstatus++;
      break;
    
  }
}

void hauptProgramm(){
  /* Hauptprogrammteil */
  if(cameras == null) //wenn noch nicht initialisiert...
  { 
    initializeCameras();
    background(51);
  }
  else{
    if(cam != null){   // wenn die camera lesbar...lese camera aus
      if (cam.available() == true) {
        cam.read();
      }
      image(screenreset,0,0); // **g a n z e n** Bildschirm mit $Hintergrundfarbe (grau) füllen, damit kein "ghosting"/keine Artefakte (zuvor ausgegebener Bildinformationen) dargestellt werden. 
      image(cam, 0, 0); // gib camera auf Bildschirm aus...
      if(count!=0)  // wenn davor schon ein Frame gespeichert wurde....
      {
        tint(255, 127);
        image(oldImg, 0, 0);  // ...überlagere ausgabe mit zuletzt aufgenommenem Frame
      }
      // The following does the same, and is faster when just drawing the image
      // without any additional resizing, transformations, or tint.
      //set(0, 0, cam);
      
      showDebugInfo("Camera: "+camIndex+" \t"+ cameras[camIndex] +"\nImage: "+count);
      System.gc();
      Runtime.getRuntime().gc();
    }
  }
}

void keyPressed() {
  if(programmstatus<2){
    programmstatus++;
  }
  else
  {
    if (key == ' ') {
      //do{
        if (cam.available() == true) {
          cam.read();
        }
          try{
            image(cam, 0, 0);
            cam.save(sketchPath()+"/Captured_Frames/"+date+"/"+nf(count,5)+".jpg");
            println("Image Captured......"+sketchPath("")+"/"+date+"/"+nf(count,5)+".jpg");
            oldImg.copy(screenreset,0,0, width, height, 0, 0, screenreset.width, screenreset.height); // **g a n z e s** oldImg mit $Hintergrundfarbe (grau) füllen, damit kein "ghosting"/keine Artefakte (zuvor ausgegebener Bildinformationen) dargestellt werden.
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
        background(51);   // nicht notwendig?
        switchToNextCam();
      }
      if (keyCode == LEFT) {
        background(51); // nicht notwendig?
        switchToPreviousCam();
      }
    }
  }
}

void switchToNextCam(){
  switchToNextCam(camIndex);
}

void switchToNextCam(int index){
  int nextCam = -1;
  if(index>=cameras.length)
    index=-1;
  for(int i=index+1;i<cameras.length;i++){
    if(cameras[i].substring(cameras[i].length()-2).equals("30"))
    {
      nextCam = i;
      break;
    }
  }
  if(nextCam==-1)
    switchToNextCam(-1);
  else
    switchToCam(nextCam);
}

void switchToPreviousCam(){
  switchToPreviousCam(camIndex);
}

void switchToPreviousCam(int index){
  int nextCam = -1;
  if(index<=0)
    index=cameras.length;
  for(int i=index-1;i>=0;i--){
    if(cameras[i].substring(cameras[i].length()-2).equals("30"))
    {
      nextCam = i;
      break;
    }
  }
  if(nextCam!=-1)
    switchToCam(nextCam);
}

void switchToCam(int i){
  if(i<0)
    camIndex=0;
  else if(i>=cameras.length)
    camIndex= cameras.length - 1;
  else
    camIndex=i;
  try{
    //if(cam!=null)
    cam.stop();
    cam = null;
    System.gc();
    cam = new Capture(this, cameras[camIndex]);
    cam.start();
    println("\n\n-------------");
    println("Switching to Camera: cameras["+camIndex+"] ......"+cameras[camIndex]);
  }catch(Exception e){
    println("-------ERROR------ An error occurred switching the camera.");
  }
}

void stop(){
  cam.stop();  
}

void initializeCameras(){
  cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available to capture video.");
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
    
    //switchCam(camIndex); //aktiviere
    cam = new Capture(this, cameras[camIndex]);
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

void warteSchleife(){
  do{}
  while(!keyPressed);
}

void loading(){
  background(51);
  fill(250);
  showDebugInfo("loading...");
}

void infoText(){
  background(250);
  fill(51);
  showDebugInfo("Hello and Welcome!\nThis is a little program to help you shoot stopmotion films.\n\n1. Plug-In your USB-Webcam\n2. Select your Camera by using the ARROW KEYS ('←' and '→')\n3. Hit SPACEBAR to capture a frame.\n\n\n\nPRESS ANY KEY TO CONTINUE...");
  fill(230, 100, 100);
  textSize(16);
  text("Hint: Check message-console for available cameras",40,700);
  
}

void showDebugInfo(String text){
  if(DEBUG){
    textFont(font);
    textAlign(LEFT);
    text(text,40,40);
  }
}
