#!/usr/bin/env perl

use strict;
use warnings;
use diagnostics;

use POSIX;			# for floor/ceiling calculations

my $trials = $ARGV[0] // '';	# unpack

unless (@ARGV <= 2 && $trials =~ m/^\d+$/)
  {
    print "Usage: $0 <trials> <max>\n";
    exit;
  }

my %results;

foreach my $x (1..$trials) {
  my $max = $ARGV[1] // 100; # Allow user modification of max, 100 if not specified
  my $number = int(rand($max))+1;
  my $min = 1;
  my $guess = int $max/2;
  my $count = 1;

  while ($guess != $number) {
    if ($guess > $number) {
      $max = $guess;
      $guess = floor(($guess + $min)/2);
    } elsif ($guess < $number) {
      $min = $guess;
      $guess = ceil(($guess + $max)/2);
    }

    $count++;
  }
  $results{$count}++;
}

my @sortedKeys = sort {$a <=> $b} (keys %results);

foreach my $y (@sortedKeys) {
  my $perc = sprintf "%.3f", $results{$y} / $trials * 100;
  print "$y - $results{$y} $perc \%\n";
}
