/*
   Copyright (c) 2018 Luc HONDAREYTE
   All rights reserved.
 */
#include "top-octave.h"

int main (void) {

#if defined __AVR_ATtiny4__
	setExtClk();
	CLKPSR=0x00;       // no prescaler (1:1)
#else
	CLKPR=0x00;        // no prescaler (1:1)
#endif
	DDRB=0xff;
	divider();
	return 0;
}
