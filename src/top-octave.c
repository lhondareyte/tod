/*
 * SPDX-License-Identifier: MIT
 *
 * Copyright (c) 2018-2024 Luc HONDAREYTE
 *
 */
#include "top-octave.h"

int main (void) {

#if defined __AVR_ATtiny4__
	setExtClk();
#else
	CLKPR=0x00;        // no prescaler (1:1)
#endif
	DDRB=0xff;
	divider();
	return 0;
}
