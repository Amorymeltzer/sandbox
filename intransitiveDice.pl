#!/usr/bin/env perl

use strict;
use warnings;

my $trials = $ARGV[0] // ""; # unpack

unless (@ARGV == 1 && $trials =~ m/^\d+$/)
{
    print "Usage: $0 <trials>\n";
    exit;
}

my %diceData; # hold the results

# individual dice
my @a = (3,5,7);
my @b = (2,4,9);
my @c = (1,6,8);

for my $x (1..$trials)
{
    my ($intA,$intB,$intC) = (int(rand(3)),int(rand(3)),int(rand(3)));
    $diceData{"a"}++ if $a[$intA] > $b[$intB];
    $diceData{"b"}++ if $b[$intB] > $c[$intC];
    $diceData{"c"}++ if $c[$intC] > $a[$intA];
}

my @sortedKeys = sort keys %diceData;

foreach my $number (@sortedKeys)
{
    # 3 decimal spaces
    my $percentage = sprintf "%.3f", $diceData{$number}/$trials*100;
    print "$number - $diceData{$number}\t$percentage \%\n";
}
