#!/usr/bin/env perl

use strict;
use warnings;

my $dollar = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
my @letters = split (//, $dollar);
foreach my $acid (@letters)
{
    print "$acid\n";
}

my $jerk = shift(@letters);
print "$jerk\n";
