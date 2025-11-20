;
; SPDX-License-Identifier: MIT
;
; Copyright (c) 2024 Luc Hondareyte
;

#if defined __AVR_ATtiny4__
#include <avr/io.h>

.global setExtClk

setExtClk:
	push r16
        ; external clock
	ldi r16, 0xd8  ; see datasheet §5.9.1
	out CCP, r16
	ldi r16, 0x02
	out CLKMSR, r16
        ; no prescaler
	ldi r16, 0xd8  ; see datasheet §5.9.1
	out CCP, r16
	ldi r16, 0x00
	out CLKPSR, r16
	pop r16
#endif
