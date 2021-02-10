#!/usr/bin/env perl
#
# Copyright (c) 2020 Luc HONDAREYTE
# All rights reserved.
# Desc. : Assembly source code generator for one divider
#

use warnings;
use strict;
my $cost  = 5;               # I/O cost 4 cycles in loop -> see @footer
                             # ldi cost 1 cycle

my $loop = 20;               # wait loop = 20 cycles
my $divider = shift ;
my $counter = int(( $divider - $cost ) / $loop ) ;
my $padding = $divider - ( $counter * $loop ) - $cost + 1 ; 
#my $debug = "TRUE";
my $debug = "FALSE";

if ( not defined $divider ) {
	print "Usage : genedivider.pl <num> \n";
	exit 1;
}

my $header   = <<EOH;
#include <avr/io.h>
#define temp r17
#define counter r16
.global divider

divider:
	; 1 cycle
	ldi counter, $counter 

wait:
	; counter x 20 cycles
	nop
	nop
	nop
	nop
	nop

	nop
	nop
	nop
	nop
	nop

	nop
	nop
	nop
	nop
	nop

	nop
	nop
	dec counter          
	brne wait

EOH

my $footer = <<EOF;

	; Toggle output
	; https://hackaday.com/2011/07/09/hardware-xor-for-output-pins-on-avr-microcontrollers/
	ldi temp, 0xff              ; 1 cycle
	out _SFR_IO_ADDR(PINB),temp ; 1 cycle
	rjmp divider                ; 2 cycles

EOF

print STDOUT "$header";

if ( $debug eq 'TRUE') {
	my $total = $padding + 5 + ($counter * 20) - 1 ;
	print STDERR "Total cycles : $total - Expected : $divider - Padding : $padding\n";
}

#
# nop padding generation
print STDOUT ("\t; nop padding ($padding nops)\n");
while  ($padding) {
	print STDOUT ("\tnop\n");
	$padding = $padding - 1;
}

print STDOUT "$footer";
