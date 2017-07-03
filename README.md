# StopMotion
Win/Mac/Linux. Written in Processing. Simple but working Sketch helping to generate stopmotion films by capturing images from a usb-webcam.  
Programm takes jpeg-images and saves them under `/%ProgramDir%/data/images/%timestamp%/`

# Keyboard Controls
spacebar = take picture  
esc = quit)

# install/run
+ download processing: http://processing.org
+ install library "video | gstreamer-based video library for Processing." (Tools>add Tolls>Libraries)
+ run sketch / export it

# Plattforms
Tested it on...
+ Win (win7)
+ Mac
+ Linux (Ubuntu)

# If Processing tells you that gstreamer is missing
Terminal > `sudo apt-get install libgstreamer0.10-0`
