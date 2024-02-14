#!/usr/bin/env perl
# weirdOr.pl by Amory Meltzer 2012.11.08

use 5.010;
use strict;
use warnings;

my $one = '1';
my $two = '2';
my $onse;

#defined($one) // $two;
#$one // $two;
my $nun = $onse // $two; # $onse if defined, $two if not
print "$nun\n";

my $tre = 0;

$tre ||= 3; # original value if true, new if not
$tre++;
print "$tre\n";
