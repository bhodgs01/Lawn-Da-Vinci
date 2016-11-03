// Lawn Da Vinci
// By Blake Hodgson
/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <blake@kcproto.com> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return.   Blake Hodgson
 * ----------------------------------------------------------------------------
 */

#include <RCSwitch1.h> // 433 mhz rf library (https://github.com/sui77/rc-switch)
RCSwitch mySwitch = RCSwitch(); //initiate 433mhz rf.
int IN1; // Input1 coming from the RC remote.
int ledPin = 13; //Relay and LED pin LED connected to Digital 13.  there are 2 relays wired to this pin that allow the top pin of channel 2 and 3 of the remote to pass through.
int POWER = 0;  //Stores the value of the 433mhz remote.  0= off and 1= on.

void setup(){ 
    Serial.begin(9600); //Begin Serial communication.
    mySwitch.enableReceive(0);  // Receiver on interrupt 0 => that is pin #2.  
    pinMode(ledPin, OUTPUT); //Initialize LED Pin.
    digitalWrite(ledPin, LOW); //Turns off 
    pinMode(5, INPUT); // Set input pins that check for a good signal.  This is wired to the top of channel 1 on the remote.
  }

void loop(){
   // This part of the code is for the optional keyfob.  It is one extra level of safety and can add security to your mower.
   if( mySwitch.getReceivedValue() == 1394007) {  // this is the value received from the 433mhz remote
     delay(1000);
     mySwitch.resetAvailable();
     digitalWrite(13, HIGH); // Trigger relays on.
     Serial.println ("activated");
     POWER = 1;
   } else if ( mySwitch.getReceivedValue() == 1394004) { 
     delay(1000);
     mySwitch.resetAvailable();
     Serial.println ("deactivated");
     POWER = 0;
     digitalWrite(13, LOW);  // Kill the motors
   }
   if (POWER == 1){  // This part of the code checks for a good signal. 
    IN1 = pulseIn(5, HIGH, 50000); // Read pulsewidths.
    Serial.print("input pulse: "); 
    Serial.println(IN1); // // Print the values.
   }
    if (IN1>1300) digitalWrite(13, HIGH); else digitalWrite(13, LOW);   // you might want to change this value based off of your remote.  At this threshold, if I push left on the right joystick, it trips the relays.  
 }
 
