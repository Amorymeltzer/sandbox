#!/usr/bin/env perl

use strict;
use warnings;
use diagnostics;

my $trials = $ARGV[0] // "";

unless (@ARGV == 1 && $trials =~ m/^\d+$/)
{
    print "Usage: $0 <trials>\n";
    exit;
}

my %diceData;

for my $x (1..$trials)
{
    my $result = int(rand(6)) + int(rand(6)) + 2;
    $diceData{$result}++;
}

my @sortedKeys = sort {$a <=> $b} (keys %diceData);

foreach my $number (@sortedKeys)
{
    # 3 decimal spaces
    my $percentage = sprintf "%.3f", $diceData{$number}/$trials*100;
    print "$number - $diceData{$number} $percentage \%\n";
}
