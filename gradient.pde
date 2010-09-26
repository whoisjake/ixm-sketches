// Simple Gradient
// (C) 2010 Jacob Good
// License: MIT (included in LICENSE.txt)
// 
// Notes: This demonstrates a gradient based on distance from the center.
//        Each IXM cell responds to a click and sets itself as center,
//        broadcasting it's event and passing around distance calculations,
//        out over the graph. Each cell then turns on a set of LEDs to
//        indicate it's *shortest* distance from the center.

u32 shortestDistance;

void setRed() {
	ledOn(BODY_RGB_RED_PIN);
	ledOff(BODY_RGB_BLUE_PIN);
	ledOff(BODY_RGB_GREEN_PIN);
}

void setBlue() {
	ledOff(BODY_RGB_RED_PIN);
	ledOn(BODY_RGB_BLUE_PIN);
	ledOff(BODY_RGB_GREEN_PIN);
}

void setGreen() {
	ledOff(BODY_RGB_RED_PIN);
	ledOff(BODY_RGB_BLUE_PIN);
	ledOn(BODY_RGB_GREEN_PIN);
}

void setWhite() {
	ledOn(BODY_RGB_RED_PIN);
	ledOn(BODY_RGB_BLUE_PIN);
	ledOn(BODY_RGB_GREEN_PIN);
}

void setBlack() {
	ledOff(BODY_RGB_RED_PIN);
	ledOff(BODY_RGB_BLUE_PIN);
	ledOff(BODY_RGB_GREEN_PIN);
}

void branchGradient( u32 sourceFace, u32 distance ) {
	if (sourceFace != NORTH) facePrintf(NORTH,"g%d\n",distance);
	if (sourceFace != SOUTH) facePrintf(SOUTH,"g%d\n",distance);
	if (sourceFace != EAST) facePrintf(EAST,"g%d\n",distance);
	if (sourceFace != WEST) facePrintf(WEST,"g%d\n",distance);
}

void branchReset( u32 sourceFace ) {
	if (sourceFace != NORTH) facePrintf(NORTH,"r\n");
	if (sourceFace != SOUTH) facePrintf(SOUTH,"r\n");
	if (sourceFace != EAST) facePrintf(EAST,"r\n");
	if (sourceFace != WEST) facePrintf(WEST,"r\n");
}

void handleGradient( u8 * packet ) {
	u32 distance;
	packetScanf(packet,"g%d\n",&distance);
	
	if (distance >= shortestDistance) return;
	
	shortestDistance = distance;
	
	if (distance == 1) setBlue();
	else if (distance == 2) setGreen();
	else if (distance == 3) setWhite();
	
	branchGradient(packetSource(packet), distance + 1);
}

void resetSelf() {
	setBlack();
	shortestDistance = U32_MAX;
}

void handleReset( u8 * packet) {
	resetSelf();
	branchReset(packetSource(packet));
}

void stealGradient() {
	println("r");
	delay(500);
	resetSelf();
	setRed();
	branchGradient(0,1);
}

void setup() {
	resetSelf();
	Body.reflex('g', handleGradient);
	Body.reflex('r', handleReset);
}

void loop() {
	if (buttonDown()) {
		stealGradient();
	} 
}