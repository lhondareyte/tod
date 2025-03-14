## Top Octave Frequency generator

An  attempt to build a top octave divider. This can also be used to make any static prescaler.

## Restrictions

### DC Characteristics

Original MOSTEK chips require a supply voltage of ~15v (Max 16v). Input clock voltage must be between 0v and Vss -1v min. To avoid this, a TTL compatible master clock is include in schematic (Typical clock frequency is 2.00024 MHz).

### Duty cycle

MOSTEK chips differs in their number of dividers and duty cycle :

* MK50240 : 50% - 13 dividers (239 to 478)
* MK50241 : 30% - 13 dividers (239 to 478)
* MK50242 : 50% - 12 dividers (239 to 451)

This emulation only generate a (almost) 50% duty cycle. Thereby,  MK50241 model is not supported since the timbre will be affected. 

## Power consumption

Original MOSTEK chips sink 24mA@15V : 0.36w Typ. (Max 37mA@15V = 0.56W). You need 13 attiny4/13 to emulate a MK50240 (12 for a MK50242). Total power consumption for 13 ATtiny13 is about 30mA@5V (Not include clock circuitry).

## TODO

* Support 30% duty cycle

## Other use

The script `genedivider.pl` can be use to generate assembly code for any static prescaler. For example, to build a `by 42` prescaler:

    ./genedivide.pl 42 > divide.S


If an overflow/underflow occurs you can try to adjust `$loop` variable:

    ./genedivide.pl 10000 200 > divide.S

Warning, the script do not check the generated code size.
