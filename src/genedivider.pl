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
my $d_loop = 4;              # default wait loop duration in cycles
my $io_cost = 3;             # 2 cycles to toggle pins  + final rjmp

my $divider = shift ;
my $loop = shift ;

my $_div = $divider ;        # Demi period
my $counter;
my $padding;
my $debug = "FALSE";
my $parity = "TRUE";
my $t = 0;
my $total = 0;

if ( not defined $divider ) {
	die "Usage : genedivider.pl <count> [loop]\n";
}

if ( not defined $loop ) {
	$loop = $d_loop;
}

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


if ( $divider % 2 ) {
	$parity = "FALSE";
}

$_div = int( $divider / 2 );
$counter = int( $_div / $loop );

if ( $counter < 2 ) {
	die "Error : counter underflow.\n";
}

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
	$l = $l - $io_cost;
	while ( $l ) {
		print STDOUT "\tnop\n";
		$l--;
	}
	print STDOUT "\n\tdec counter\n\tbrne loop_0\n\n";
	#
	# nop padding generation
	print STDOUT ("\t; Padding ($p nops)\n");
	while  ( $p ) {
		print STDOUT ("\tnop\n");
		$p--;
	}
}

if ( $debug eq 'TRUE') {
	$total = (( $counter * $loop ) + $padding + $io_cost ) * 2 ;
	if ( $parity eq 'FALSE' ) {
		$total++;
	}
	print STDERR "\nTotal cycles : $total - Expected : $divider";
}

print STDOUT "$Header";
print STDOUT "\tldi counter, $counter\n";
print STDOUT "loop_0:\n\t;counter x $loop cycles\n";
WaitGeneration();
print STDOUT "$Toggle";
print STDOUT "\tldi counter, $counter\n";
if ( $parity eq "FALSE" ) {
	print STDOUT "\n\t; fix parity\n\tnop\n";
}
print STDOUT "\n\trjmp loop_0                ; 2 cycles\n";
