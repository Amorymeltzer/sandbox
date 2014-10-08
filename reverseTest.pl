#!/usr/bin/env perl

use strict;
use warnings;

$_ = "\ndlrow ,olleH";
print "$_\n";
print reverse;
print scalar reverse;

my @test = ("a","b","","c");
print "@test\n";
print scalar @test."\n";
@test = reverse @test;
print "@test\n";
