#!/usr/bin/env perl

use strict;
use warnings;

open (my $primes, '<primes.txt');

my $count = 1;
for (<$primes>)
{
    chomp;
    my $value = 2**$_ - 1;
    print "$count\t$_\t$value\n";
    $count++;
}
