#!/usr/bin/env perl -w
#
# Desc. : Assembly source code generator for one divider
#

use strict;
my $offset  = 5;           # I/O cost 5 cycles in loop -> see @footer
my $count   = 8;           # Indentation loop count
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
	ldi temp, 0b11111111
	out PORTB, temp
loop:
EOH

my $footer = <<EOF;
	
	; Toggle output
	subi temp, 1    ; 2 cycles
	out PORTB, temp ; 1 cycles
	rjmp loop       ; 2 cycles
EOF

print STDOUT "$header";

#
# nop generation
$divider = $divider - $offset;
while  ($divider) {
	if ( $count % 8 ) {
		print STDOUT ("nop; ");
	}
	else {
		print STDOUT ("\n\tnop; ");
	}
	$divider = $divider - 1;
	$count = $count - 1;
	if ( $count == 0 ) {
		$count = 8;
	}
}

print STDOUT "$footer";
