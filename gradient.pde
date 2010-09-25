void setRed( void ) {
	ledOn(BODY_RGB_RED_PIN);
  ledOff(BODY_RGB_BLUE_PIN);
  ledOff(BODY_RGB_GREEN_PIN);
}

void setBlue( void ) {
	ledOff(BODY_RGB_RED_PIN);
  ledOn(BODY_RGB_BLUE_PIN);
  ledOff(BODY_RGB_GREEN_PIN);
}

void setGreen( void ) {
	ledOff(BODY_RGB_RED_PIN);
  ledOff(BODY_RGB_BLUE_PIN);
  ledOn(BODY_RGB_GREEN_PIN);
}

void setWhite( void ) {
	ledOn(BODY_RGB_RED_PIN);
  ledOn(BODY_RGB_BLUE_PIN);
  ledOn(BODY_RGB_GREEN_PIN);
}

void setBlack( void ) {
	ledOff(BODY_RGB_RED_PIN);
  ledOff(BODY_RGB_BLUE_PIN);
  ledOff(BODY_RGB_GREEN_PIN);
}

void branch( u32 sourceFace, u32 distance ) {
	if (sourceFace != NORTH) facePrintf(NORTH,"g%d\n",distance);
	if (sourceFace != SOUTH) facePrintf(SOUTH,"g%d\n",distance);
	if (sourceFace != EAST) facePrintf(EAST,"g%d\n",distance);
	if (sourceFace != WEST) facePrintf(WEST,"g%d\n",distance);
}

void setGradient( u8 * packet ) {
	u32 distance;
	packetScanf(packet,"g%d\n",&distance);
	
	setBlack();
	
	if (distance == 1) setBlue();
	else if (distance == 2) setGreen();
	else if (distance == 3) setWhite();
	
	branch(packetSource(packet), distance + 1);
}

void stealGradient(  ) {
	setRed();
	branch(0,1);
}

void setup() {
	Body.reflex('g', setGradient);
}

void loop() {
  if (buttonDown()) {
    stealGradient();
  } 
}