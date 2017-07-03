# StopMotion
Win/Mac/Linux. Written in Processing.  
Simple but working Sketch helping to generate stopmotion films by capturing images from an usb-webcam.  

Program captures jpeg-images and saves them under `/%ProgramDir%/data/images/%timestamp%/`.  

Use the MovieMaker (Processing>Tools>MovieMaker) to generate a QuickTime-Movie file out of it.

# Keyboard Controls
`space` = take picture  
`esc` = quit)

# install/run
+ download processing: http://processing.org
+ install library "video | gstreamer-based video library for Processing." (Tools>add Tolls>Libraries)
+ run sketch / export it

# Plattforms
Successfully run on...
+ Win (win7)
+ Mac
+ Linux (Ubuntu)

# If Processing tells you that gstreamer is missing
Terminal > `sudo apt-get install libgstreamer0.10-0`
