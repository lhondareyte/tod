#include "top-octave.h"

int main (void) {

#if defined (__AVR_ATtiny13__) || defined (__AVR_ATtiny13a__)
	CLKPR=0x00;        // no prescaler (1:1)
#endif

#if defined __AVR_ATtiny4__
	CLKMSR=0b00000010; // external clock
	CLKPSR=0x00;       // no prescaler (1:1)
#endif
	divider();
	return 0;
}
