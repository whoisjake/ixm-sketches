// Pi approximation
// (C) 2010 Jacob Good
// License: MIT (included in LICENSE.txt)
// 
// Notes: A simple way to approximate PI is to enclose a
//        circle inside of a square, with the center points
//        on each of the edges of the square are points on the
//        circle. Then randomly distribute points within the square.
//        You can then approximate the area ratio by taking the number
//        of points within the circle divided by the total number of points.
//        
//        To approximate pi:
//        area_sq = 2r * 2r = 4r^2
//        area_circle = PI*r^2
//        PI = 4 * (area_circle/area_sq)
//
//        For large numbers of points:
//        PI = 4 * (number of points in circle / number of points)

#include <math.h>

#define BLACK 0x00
#define RED 0x01
#define GREEN 0x02
#define BLUE 0x04
#define WHITE RED | GREEN | BLUE
#define IS_RED(x) (x & RED)
#define IS_GREEN(x) (x & GREEN)
#define IS_BLUE(x) (x & BLUE)

void setCenter(u8 color) {
	ledOff(BODY_RGB_RED_PIN);
	ledOff(BODY_RGB_BLUE_PIN);
	ledOff(BODY_RGB_GREEN_PIN);
	
	if (IS_RED(color) != 0) { ledOn(BODY_RGB_RED_PIN); }
	if (IS_BLUE(color) != 0) { ledOn(BODY_RGB_BLUE_PIN); }
	if (IS_GREEN(color) != 0) { ledOn(BODY_RGB_GREEN_PIN); }
}

const u32 RADIUS = 1000;
const double MAX_POINTS = 10000.0;
bool calculating = false;
bool finished = false;
u32 pointsInCircle,pointsSoFar;

void startCalculating() {
	pointsInCircle = 0;
	pointsSoFar = 0;
	finished = false;
	calculating = true;
}

bool isPointInCircle(u32 xCoord, u32 yCoord)
{
	u32 square_dist = pow(xCoord,2) + pow(yCoord,2);
	return square_dist <= pow(RADIUS,2);
}

void performCalculationStep() {
	setCenter(GREEN);
	u32 xCoord = random(1,RADIUS);
	u32 yCoord = random(1,RADIUS);
	bool inCircle = isPointInCircle(xCoord,yCoord);
	if (inCircle) { pointsInCircle++; }
	pointsSoFar++;
	
	calculating = (pointsSoFar != MAX_POINTS);
	finished = (pointsSoFar == MAX_POINTS);
}

void setup() {
}

void loop() {
	
	if (buttonDown()) { startCalculating(); }
	
	// Let's perform steps so we don't miss any messages.
	if (calculating) { performCalculationStep(); }
	
	if (finished) {
		setCenter(WHITE);
		double pi = 4.0 * ((double)pointsInCircle/MAX_POINTS);
		facePrintf(NORTH,"Calcuated: %f\n",pi);
		facePrintf(NORTH,"Accuracy: %f%%\n", (((pi/M_PI) * 100.0)) - 100.0);
		finished = false; // print once and wait for next attempt
	}
}

#define SFB_SKETCH_CREATOR_ID B36_4(j,a,k,e)
#define SFB_SKETCH_PROGRAM_ID B36_2(p,i)
#define SFB_SKETCH_COPYRIGHT_NOTICE "MIT 2010 Jacob Good"