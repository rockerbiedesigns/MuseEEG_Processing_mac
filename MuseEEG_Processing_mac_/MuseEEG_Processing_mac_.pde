///////////////////////////
//                       //
//THIS IS THE MAC VERSION//
//                       //
///////////////////////////
//
//For Mac, install the Muse Monitor App on your phone.
//In Muse monitor, go to setting and set Port to 7000.
//Set ip to IPv4 on computer (ipconfig in command prompt)
//or run this sketch and check IP addressing in print line.
//If readings from Muse Monitor do not appear while sketch is
//running, try changing the Port to 5000 in both this sketch
//(labelled below) and in Muse Monitor.
//

import netP5.*;
import oscP5.*; //OSC library
import processing.serial.*; //Serial library

OscP5 oscp5; //New OSC object
Serial Arduino; //Arduino object

//Container variables for converting RAW readings to Strings
String EEG_alphaWave_conv;
String EEG_betaWave_conv;
String EEG_gammaWave_conv;
String EEG_deltaWave_conv;

//Container variables for incoming RAW data from Muse headband
float EEG_gammaWave; //concentration
float EEG_alphaWave; //mellow
float EEG_betaWave; //excitement
float EEG_deltaWave; //rest

void setup()
{
  oscp5 = new OscP5(this, 7000); //OSC readings from port 7000. (NOTE: as stated above, change to 5000 if no readings appear)
  String portA = Serial.list()[0]; //Serial opens first available COM for Arduino. Can delete if not required
}

void draw()
{ 
  //Converts data to String for future development (if needed)
  EEG_alphaWave_conv = nf((float)EEG_alphaWave, 0, 2);
  EEG_betaWave_conv = nf((float)EEG_betaWave, 0, 2);
  EEG_gammaWave_conv = nf((float)EEG_gammaWave, 0, 2);
  EEG_deltaWave_conv = nf((float)EEG_deltaWave, 0, 2);
  
  print(EEG_alphaWave_conv + "=Alpha, ");
  print(EEG_betaWave_conv + "=Beta, ");
  print(EEG_gammaWave_conv + "=Gamma, ");
  println(EEG_deltaWave_conv + "=Delta");
}

void oscEvent(OscMessage theMessage) {
  //Grabs Muse Monitor data through Open Sound Control (OSC)
  
  //Print the address and typetag of the message to the console below
  //println("OSC Message received! The address pattern is " + theMessage.addrPattern() + ". The typetag is: " + theMessage.typetag());
  //typetag is 'dddd' (PC) which is a double variable
  //typetage is 'f' (Mac thru musemonitor) which is float variable
  
  if (theMessage.checkAddrPattern("/muse/elements/gamma_absolute") == true ) {
    EEG_gammaWave = theMessage.get(0).floatValue();
    //println below tests if EEG_gammaWave is receiving data. Uncomment for troubleshooting
    //println("Your attention is at: "+ EEG_gammaWave);
  }

  if (theMessage.checkAddrPattern("/muse/elements/alpha_absolute") == true ) {
    EEG_alphaWave = theMessage.get(0).floatValue();
  }

  if (theMessage.checkAddrPattern("/muse/elements/beta_absolute") == true ) {
    EEG_betaWave = theMessage.get(0).floatValue();
  }

  if (theMessage.checkAddrPattern("/muse/elements/delta_absolute") == true ) {
    EEG_deltaWave = theMessage.get(0).floatValue();
  }
  //println's below tests if EEG is connected and what typetag the RAW data is received as. Uncomment for troubleshooting
  //println(theMessage.addrPattern() + ":");
  //println(theMessage.typetag());
}
