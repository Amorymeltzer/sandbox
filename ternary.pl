#!/usr/bin/env perl
# ternary.pl by Amory Meltzer
# Practice the ternary operator ?

use strict;
use warnings;
use diagnostics;

my $n = 2;

if (@ARGV && $ARGV[0] =~ /^\d+$/)
{
    $n = $ARGV[0];
}

printf "I have %d dog%s.\n", $n,($n == 1) ? "" : "s";
