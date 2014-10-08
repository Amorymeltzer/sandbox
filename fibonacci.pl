#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV == 1 && $ARGV[0] =~ m/^\d+$/)
{
    print "How many? (2+)\n";
    print "$0 <howmany>\n";
    exit;
}
my $count = $ARGV[0];

my $track = 2;

my $first = 1;
my $second = 1;

print "$first\n$second\n";

while ($track < $count)
{
    my $store = $first + $second;
    my $fib = $store/$second;
    print "$store\t$fib\n";
    $first = $second;
    $second = $store;
    $track++;
}
