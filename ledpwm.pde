// Pi approximation
// (C) 2010 Jacob Good
// License: MIT (included in LICENSE.txt)
//
// Note: This demonstrates the use of PWM
//       on the IXM platform. It uses PWM
//       to cycle through RGB color values.
//
//       Take into consideration that the PWM
//       on this chip sits at about 50hz, but
//       20,000 usecs in width is a 100% duty cycle.
//       Hence the rgbPWM conversion 0-255 to 0-20,000.

// Grab the PWM pins
const int redPin = PWM_BODY_RGB_RED_PIN;
const int greenPin = PWM_BODY_RGB_GREEN_PIN;
const int bluePin = PWM_BODY_RGB_BLUE_PIN;

// Start at (255,0,0)
int redVal   = 255;
int greenVal = 1;
int blueVal  = 1;

int i = 0;
int wait = 30;

void setup() {
	// Start PWM and set up pins
	PWMStart();
	PWMSetMode(redPin,PWM_SINGLE_EDGE);
	PWMSetMode(greenPin,PWM_SINGLE_EDGE);
	PWMSetMode(bluePin,PWM_SINGLE_EDGE);
}

u32 rgbPWM(u32 rgb)
{
	return (20000 * rgb)/255;
}

void loop() {
	i += 1;
	if (i < 255)
	{
	  redVal   -= 1;
	  greenVal += 1;
	  blueVal   = 1;
	}
	else if (i < 509)
	{
	  redVal    = 1;
	  greenVal -= 1;
		blueVal  += 1;
	} 
	else if (i < 763)
	{
	  redVal  += 1;
	  greenVal = 1;
	  blueVal -= 1;
	}
	else
	{
	  i = 1;
	}
	
	// Set the pulse widths and tell the first two to queue.
	// The last one triggers them all to be executed at the same time.
	PWMSetWidth(redPin,rgbPWM(redVal),false); // queue it up
	PWMSetWidth(greenPin,rgbPWM(greenVal),false); // queue it up
	PWMSetWidth(bluePin,rgbPWM(blueVal),true); // let 'er rip
	
	delay(wait);
}

#define SFB_SKETCH_CREATOR_ID B36_4(j,a,k,e)
#define SFB_SKETCH_PROGRAM_ID B36_6(l,e,d,p,w,m)
#define SFB_SKETCH_COPYRIGHT_NOTICE "MIT 2010 Jacob Good"