// Pi approximation
// (C) 2010 Jacob Good
// License: MIT (included in LICENSE.txt)
// 
// Notes: This demonstrates a distributed PI calculation.
//        A simple way to approximate PI is to enclose a
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

const u32 RADIUS = 1000;
u32 points;

bool pointsInCircle(u32 radius, u32 xCoord, u32 yCoord)
{
	u32 square_dist = pow(xCoord,2) + pow(yCoord,2);
	return square_dist <= pow(radius,2);
}

void startCalculation() {
	u32 circleCount = 0;
	u32 xCoord, yCoord;
	bool inCircle;
	
	for (u32 x = 0; x < points; x++) {
		xCoord = random(1,RADIUS);
		yCoord = random(1,RADIUS);
		inCircle = pointsInCircle(RADIUS,xCoord,yCoord);
		if (inCircle)
		{
			circleCount++;
		}
	}
	
	double pi = 4.0 * ((double)circleCount/(double)points);
	facePrintf(NORTH,"%f\n",pi);
	ledOn(BODY_RGB_RED_PIN);
	ledOn(BODY_RGB_BLUE_PIN);
	ledOn(BODY_RGB_GREEN_PIN);
}

void resetSelf(u32 num) {
	points = num;
}

void setup() {
	resetSelf(100000);
}

void loop() {
	if (buttonDown()) {
		startCalculation();
	} 
}

#define SFB_SKETCH_CREATOR_ID B36_4(j,a,k,e)
#define SFB_SKETCH_PROGRAM_ID B36_2(p,i)
#define SFB_SKETCH_COPYRIGHT_NOTICE "MIT 2010 Jacob Good"