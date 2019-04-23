# Max/Realsense Installation Guide
Make sure you have downloaded the most recent version of Processing from [the website](https://processing.org/download/)
(this has been tested with version 3.5.3)

Open Processing and select the Sketch drop down menu, followed by 
Import Library and then Add Library

Search _realsense_ and install the _Intel RealSense_ library by Florian Bruggiser

Then search _osc_ and install the _oscP5_ library by Andreas Schlegel

Restart Processing

Open the OSCreceiver.maxpat

Open the RealSenseOSCxyz.pde

Run the Processing sketch

The Processing sketch finds the average location in a collection of pixels within a min and max threshold and then sends that location and its distance from the camera to Max.

Use the up and down arrow keys while the sketch is open to change the threshold.

The Max patch will receive the coordinates and separate them out into individual values for use in your patch. Received values will depend on the input you are using. 
