#!/usr/bin/env perl
#
# SPDX-License-Identifier: MIT
#
# Copyright (c) 2020-2024 Luc HONDAREYTE
# 
# Desc. : Assembly source code generator for one divider
#

use warnings;
use strict;
my $loop = 4;               # wait loop duration in cycles
my $io_cost = 3;             # 2 cycles to toggle pins  + final rjmp
my $divider = shift ;
my $_div = $divider ;        # Demi period
my $counter;
my $padding;
my $debug = "FALSE";
my $parity = "TRUE";
my $n = 0;
my $t = 0;
my $total = 0;

my $Header = <<EOH;
;
; Automatically generated assembly code, do not edit
;
; SPDX-License-Identifier: MIT
;
; Divider by $divider
;
#include <avr/io.h>
#define temp r17
#define counter r16
.global divider

divider:

EOH

my $Toggle = <<EOF;

	; Toggle output
	; https://hackaday.com/2011/07/09/hardware-xor-for-output-pins-on-avr-microcontrollers/
	ldi temp, 0xff              ; 1 cycle
	out _SFR_IO_ADDR(PINB),temp ; 1 cycle

EOF

if ( not defined $divider ) {
	print "Usage : genedivider.pl <num> \n";
	exit 1;
}

if ( $divider % 2 ) {
	$parity = "FALSE";
}

$_div = int( $divider / 2 );
$counter = int( $_div / $loop );

# Prevent padding underflow
$counter--;            

if ( $loop <= $io_cost ) {
	die "Error : loop variable is too low\n";
}

if ( $counter > 255 ) {
	die "Error : counter overflow ($counter).\n";
}

$padding = ($_div - ( $counter * $loop )) - $io_cost; 

if ( $padding < 0 ) {
	die "Error : padding underflow ($padding) .\n";
}

#
# Wait loop generation
#
sub WaitGeneration {
	my $l = $loop;
	my $p = $padding;
	print STDOUT "\tldi counter, $counter\n";
	print STDOUT "wait_$n:\n\t;counter x $loop cycles\n";
	$l = $l - $io_cost;
	while ( $l ) {
		print STDOUT "\tnop\n";
		$l--;
	}
	print STDOUT "\n\tdec counter\n\tbrne wait_$n\n\n";
	#
	# nop padding generation
	print STDOUT ("\t; Padding ($p nops)\n");
	while  ( $p ) {
		print STDOUT ("\tnop\n");
		$p--;
	}
	$n++;
}

if ( $debug eq 'TRUE') {
	$total = (( $counter * $loop ) + $padding + $io_cost ) * 2 ;
	if ( $parity eq 'FALSE' ) {
		$total++;
	}
	print STDERR "\nTotal cycles : $total - Expected : $divider";
}

print STDOUT "$Header";
WaitGeneration();
print STDOUT "$Toggle";
WaitGeneration();
if ( $parity eq "FALSE" ) {
	print STDOUT "\n\t; fix parity\n\tnop\n";
}
print STDOUT "$Toggle";
print STDOUT "\n\trjmp divider                ; 2 cycles\n";
