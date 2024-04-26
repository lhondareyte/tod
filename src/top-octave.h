#include <avr/io.h>
#include <stdlib.h>
#include <stdint.h>

void divider(void);

#if defined __AVR_ATtiny4__
extern void setExtClk(void);
#endif
