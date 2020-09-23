#!/usr/bin/env perl
#
# Copyright (c) 2020 Luc HONDAREYTE
# All rights reserved.
# Desc. : Assembly source code generator for one divider
#

use warnings;
use strict;
my $offset  = 4;           # I/O cost 4 cycles in loop -> see @footer
my $divider = shift ;

if ( not defined $divider ) {
	print "Usage : genedivider.pl <num> \n";
	exit 1;
}

my $header   = <<EOH;
#include <avr/io.h>
#define temp r17
.global divider
	
divider:

EOH

my $footer = <<EOF;

	; Toggle output
	; https://hackaday.com/2011/07/09/hardware-xor-for-output-pins-on-avr-microcontrollers/
	ldi temp, 0xff              ; 1 cycle
	out _SFR_IO_ADDR(PINB),temp ; 1 cycle
	rjmp divider                ; 2 cycles
EOF

print STDOUT "$header";

#
# nop generation
$divider = $divider - $offset + 1;
while  ($divider) {
	print STDOUT ("\tnop\n");
	$divider = $divider - 1;
}

print STDOUT "$footer";
