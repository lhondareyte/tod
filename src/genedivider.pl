#!/usr/bin/env perl -w
use strict;
#my @dividers = (451, 426, 402, 379, 358, 338, 319, 301, 284, 268, 253, 239);
my $offset  = 5;
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

	subi temp, 1    ; 2 cycles
	out PORTB, temp ; 1 cycles
	rjmp loop       ; 2 cycles
EOF

$divider = $divider - $offset;
my $count   = 8;

print STDOUT "$header";

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
