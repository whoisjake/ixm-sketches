// Distributed Pi approximation
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

#define BLACK 0x00
#define RED 0x01
#define GREEN 0x02
#define BLUE 0x04
#define WHITE RED | GREEN | BLUE
#define IS_RED(x) (x & RED)
#define IS_GREEN(x) (x & GREEN)
#define IS_BLUE(x) (x & BLUE)

#define SLAVE 's'
#define MASTER 'm'

void buttonClick ( void (*handler)() , u8 waitTime) {
	if (buttonDown()) {
    while (buttonDown()) {
      delay(waitTime);
    }
		(*handler)();
  }
}

void buttonClick ( void (*handler)() ) { buttonClick(*handler,50); }

void setCenter(u8 color) {
	ledOff(BODY_RGB_RED_PIN);
	ledOff(BODY_RGB_BLUE_PIN);
	ledOff(BODY_RGB_GREEN_PIN);
	
	if (IS_RED(color) != 0) { ledOn(BODY_RGB_RED_PIN); }
	if (IS_BLUE(color) != 0) { ledOn(BODY_RGB_BLUE_PIN); }
	if (IS_GREEN(color) != 0) { ledOn(BODY_RGB_GREEN_PIN); }
}

const u32 RADIUS = 1000;
bool master,slave,calculating,finished;
u32 pointsInCircle,pointsSoFar,maxPoints,masterFace;

void startCalculating() {
	pointsInCircle = 0;
	pointsSoFar = 0;
	maxPoints = 10000;
	finished = false;
	calculating = true;
	slave = true;
	master = false;
}

bool isPointInCircle(u32 xCoord, u32 yCoord)
{
	u32 square_dist = pow(xCoord,2) + pow(yCoord,2);
	return square_dist <= pow(RADIUS,2);
}

void performCalculationStep() {
	setCenter(BLACK);
	if (pointsSoFar % 10 == 0) { setCenter(GREEN); }
	
	u32 xCoord = random(1,RADIUS);
	u32 yCoord = random(1,RADIUS);
	bool inCircle = isPointInCircle(xCoord,yCoord);
	if (inCircle) { pointsInCircle++; }
	pointsSoFar++;
	
	calculating = (pointsSoFar != maxPoints);
	finished = (pointsSoFar == maxPoints);
}

void checkResults() {
	finished = ((maxPoints > 0) && (pointsSoFar == maxPoints));
	calculating = !finished;
}

void becomeMaster() {
	setCenter(RED);
	
	slave = false;
	master = true;
	calculating = true;
	pointsInCircle = 0;
	pointsSoFar = 0;
	maxPoints = 0;
	println("r");
	println("s");
}

void handleIntent(u8 * packet) {
	if (master) {
		maxPoints += 10000;
	}
}

void handleSlave(u8 * packet) {
	if (!master) {
		masterFace = packetSource(packet);
		facePrintln(masterFace,"i");
		startCalculating();
	}
}

void handleReset(u8 * packet) {
	slave = master = false;
	calculating = false;
}

void handleFinished(u8 * packet) {
	if (master) {
		u32 circleCount = 0;
		u32 points = 0;
		packetScanf(packet,"f%d/%d\n",&circleCount,&points);
		pointsInCircle += circleCount;
		pointsSoFar += points;
	}
}

void setup() {
	Body.reflex('i',handleIntent);
	Body.reflex('s',handleSlave);
	Body.reflex('r',handleReset);
	Body.reflex('f',handleFinished);
}

void loop() {
	buttonClick(becomeMaster);
	
	if (calculating)
	{
		if (master) { checkResults(); }
		else if (slave) { performCalculationStep(); }
	}
	
	if (finished)
	{
		if (master) {
			setCenter(WHITE);
			double pi = 4.0 * ((double)pointsInCircle/maxPoints);
			facePrintf(NORTH,"Ratio: %d/%d\n",pointsInCircle,maxPoints);
			facePrintf(NORTH,"Calcuated: %f\n",pi);
			facePrintf(NORTH,"Accuracy: %f%%\n", (((pi/M_PI) * 100.0)) - 100.0);
		}
		else if (slave) {
			setCenter(WHITE);
			facePrintf(masterFace,"f%d/%d\n",pointsInCircle,pointsSoFar);
		}
		finished = false;
	}
}

#define SFB_SKETCH_CREATOR_ID B36_4(j,a,k,e)
#define SFB_SKETCH_PROGRAM_ID B36_6(d,i,s,t,p,i)
#define SFB_SKETCH_COPYRIGHT_NOTICE "MIT 2010 Jacob Good"