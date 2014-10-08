#!/usr/bin/env perl

use strict;
use warnings;

my $number = int(rand(100))+1;
my ($count,$guess) = (0,0);

print "Guess?\n";
while ($guess != $number)
{
    $guess = <>;
    print "Bigger\n" if $guess < $number;
    print "Smaller\n" if $guess > $number;
    print "Yup!\n" if $guess == $number;
    $count++;
}
print "$count\n";
