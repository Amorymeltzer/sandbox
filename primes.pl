#!/usr/bin/env perl

use strict;
use warnings;

my $truth = 0; # To evaluate primality and store first factor

print "List or Number?\n";
my $choice = <>; # User choice for a full list or number
while ($choice !~ m/[ln]/io)
{
    print "Try again\n";
    $choice = <>;
}

if ($choice =~ m/n/i) # Test one number
{
    print "Test what number? ";
    my $number = <>;
    primeTest($number);
    print "First factor: $truth\n" if $truth != 0;
    if ($truth == 0) {print "Prime!\n"} else {print "Not Prime :(\n"}
}

open(my $out, '>primes.txt');
if ($choice =~ m/l/i) # The whole list up to that number
{
    print "Stop at what number? ";
    my $number = <>;
#    my $time = time;
    foreach my $x (2..$number)
    {
	$truth = 0;
	primeTest($x);
#	print $out "$x\n" if $truth == 0;
	print $out "$x\n" if $truth == 0;
    }
#    $time = time - $time;
#    print "$time seconds\n";
}

#########################################################
# Subroutines
#########################################################

# Test for primes
sub primeTest
{
    my $max = shift(@_);
    foreach my $y (2..sqrt($max))
    {
	$truth = $max/$y if $max%$y == 0;
	last if $max%$y == 0;
    }
}
