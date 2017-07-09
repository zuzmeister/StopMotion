# StopMotion
## About
Simple but working Sketch helping to generate stopmotion films by capturing images from an usb-webcam. I quickly wrote it for a [StopMotion-Workshop for kids](http://kinderunikunst2017.tommachtalles.net/) because there weren't many free/working/easy2use Applications around. There's a lot to improve, but it's working.    

The program captures jpeg-images and saves them under `/%ProgramDir%/data/images/%timestamp%/`.
**Use the MovieMaker (Processing>Tools>MovieMaker) to generate a QuickTime-Movie file out of it.**  

**Runs on:** Win/Mac/Linux. 
**Written in:** Processing.  

## Featuring
+ Onion Skinning [(wikipedia)](https://en.wikipedia.org/wiki/Onion_skinning)
+ Auto-Saving

## Not Featuring
+ Movie Export (instead: use the [MovieMaker-Tool](https://youtu.be/ud1WQgQzFWU?t=2m8s) provided by Processing or a Video-Editor)
+ Anything exceeding the absolute minimum.

## Keyboard Controls
`space` = take picture   
`esc` = quit  
`LEFT` = switch to next camera source **(version: StopMotion_v_2017-07-08.pde)**  
`RIGHT` = switch to last camera source **(version: StopMotion_v_2017-07-08.pde)**  

## install/run
+ plug an USB-WebCam into your computer
+ download processing: http://processing.org and run it
+ install library "video | gstreamer-based video library for Processing." (Tools>add Tolls>Libraries)
+ run sketch (or export it)

## Plattforms
Successfully run on...
+ Win (win7)
+ Mac
+ Linux (Ubuntu)

## If Processing tells you that gstreamer is missing (ubuntu)
Terminal > `sudo apt-get install libgstreamer0.10-0`
