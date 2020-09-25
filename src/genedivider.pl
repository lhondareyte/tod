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
my $nop = $divider - ( $counter * $loop ) - $cost + 1 ; 
#my $nop = $divider - ( $counter * 2 ) - $cost - 1 ; 

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

#my $total = $nop + 5 + ($counter * 20);
#print STDERR "Total cycles : $total - Padding : $nop \n";
#
# nop generation
print STDOUT ("\t; nop padding ($nop nops)\n");
while  ($nop) {
	print STDOUT ("\tnop\n");
	$nop = $nop - 1;
}

print STDOUT "$footer";
