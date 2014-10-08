#!/usr/bin/env perl

use strict;
use warnings;

my @array = ("A,B");
my @ray = (@array,"CDEFG");

my $test = "HI";
@ray = (@ray,$test);
#my ($m, @l) = @ray;

foreach my $x (@ray)
{
    print "$x\n";
}

print scalar @ray;
print "\n";
print scalar @ray -1;
print "\n";
