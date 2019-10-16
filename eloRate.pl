#!/usr/bin/env perl
# eloRate.pl by Amory Meltzer
# Quick and dirty ranking via Elo
## Implement correct percentage
## http://fivethirtyeight.com/datalab/introducing-nfl-elo-ratings/
## Pr(A) = 1 / (10^(-ELODIFF/400) + 1)

use strict;
use warnings;
use diagnostics;

use English qw( -no_match_vars);
use Term::ANSIColor;

if (@ARGV != 1) {
  print "Usage: $PROGRAM_NAME list.csv\n";
  exit;
}

my $file = $ARGV[0];
my @list;
my %scoreHash;
my ($rand1,$rand2,$item1,$item2,$rating,$ea1,$ea2); # make global

# Build a hash storing current items, any scores
open my $data, '<', "$ARGV[0]" || die $ERRNO;
while (<$data>) {
  chomp;
  my @line = split /,/;
  $scoreHash{$line[0]} = $line[1] // 1400;
  @list = (@list,$line[0]);
}
close $data || die $ERRNO;

# Start the scoring process, these are just needed once
system 'clear';
print "Rate these two items.  A for the left one, L for the right one\n";

# Loop through 'em all
my $length = scalar keys %scoreHash;
my $infinite = -1;
while ($infinite !=0) {
  $rand1 = int rand $length;
  $rand2 = int rand $length;

  # Can't compare something to itself
  while ($rand1 == $rand2) {
    $rand2 = int rand $length;
  }

  ($item1,$item2) = ($list[$rand1],$list[$rand2]);
  eloPred();
  print colored ['red'],"$item1 ($scoreHash{$item1}, $ea1)";
  print ' or ';
  print colored ['red'],"$item2 ($scoreHash{$item2}, $ea2)\n";

  $rating = <STDIN>;
  chomp $rating;
  # system 'clear';
  if ($rating eq 'a') {
    eloScore($item1,$item2,$ea1,$ea2);
    $scoreHash{$item1}++;
    print "$item1:\t$scoreHash{$item1}\n";
  } elsif ($rating eq 'l') {
    eloScore($item2,$item1,$ea2,$ea1);
    $scoreHash{$item2}++;
    print "$item2:\t$scoreHash{$item2}\n";
  } elsif ($rating eq 'exit' || $rating eq 'q' || $rating eq 'quit') {
    last;
  }
}

print "\n";

open my $out, '>', "$file" || die $ERRNO;
# Sort by key value, high->low, a->z
foreach my $key (sort {$scoreHash{$b} <=> $scoreHash{$a} || $a cmp $b} (keys %scoreHash)) {
  print "$key\t$scoreHash{$key}\n";
  print $out "$key,$scoreHash{$key}\n";
}
close $out || die $ERRNO;


### SUBROUTINES
sub eloPred {
  # wiki: Elo rating system, keep to two decimals
  $ea1 = (int(100/(1 + 10**(($scoreHash{$item2} - $scoreHash{$item1})/400))))/100;
  $ea2 = (int(100/(1 + 10**(($scoreHash{$item1} - $scoreHash{$item2})/400))))/100;
}

sub eloScore {
  my $win = shift @_;
  my $los = shift @_;
  my $eaw = shift @_;
  my $eal = shift @_;

  # k=32, can be changed to tweak sensitivity.  higher k = more sensitive to recents
  $scoreHash{$win} += 32*(1-$eaw);
  $scoreHash{$los} += 32*(0-$eal);

  print "Won: $win\tLost: $los\n";
}
