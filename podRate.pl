#!/usr/bin/env perl
# podRate.pl by Amory Meltzer
# Help me pare down my pods via Elo
## Implement correct percentage
## http://fivethirtyeight.com/datalab/introducing-nfl-elo-ratings/
## Pr(A) = 1 / (10^(-ELODIFF/400) + 1)

use strict;
use warnings;
use diagnostics;

use Term::ANSIColor;

my %scoreHash;
my @podList;
my ($rand1,$rand2,$pod1,$pod2,$rating,$ea1,$ea2); # make global

# Build a hash storing current pods, any scores
open my $data, '<', 'podList.txt' || die $!;
while (<$data>) {
  chomp;
  my @line = split /\t/;
  $scoreHash{$line[0]} = $line[1] // 1400;
  @podList = (@podList,$line[0]);
}
close $data || die $!;

# Start the scoring process, these are just needed once
system 'clear';
print "Rate these two pods.  A for the left one, L for the right one\n";

# Loop through 'em all
my $length = keys %scoreHash;
my $infinite = -1;
while ($infinite !=0) {
  $rand1 = int(rand($length));
  $rand2 = int(rand($length));

  # Can't compare a pod to itself
  while ($rand1 == $rand2) {
    $rand2 = int(rand($length-2))+1;
  }

  ($pod1,$pod2) = ($podList[$rand1],$podList[$rand2]);
  eloPred();
  print colored ['red'],"$pod1 ($scoreHash{$pod1}, $ea1)";
  print ' or ';
  print colored ['red'],"$pod2 ($scoreHash{$pod2}, $ea2)\n";

  $rating = <>;
  chomp $rating;
  # system 'clear';
  if ($rating eq 'a') {
    eloScore($pod1,$pod2,$ea1,$ea2);
    $scoreHash{$pod1}++;
    print "$pod1:\t$scoreHash{$pod1}\n";
  } elsif ($rating eq 'l') {
    eloScore($pod2,$pod1,$ea2,$ea1);
    $scoreHash{$pod2}++;
    print "$pod2:\t$scoreHash{$pod2}\n";
  } elsif ($rating eq 'exit' || $rating eq 'q' || $rating eq 'quit') {
    last;
  }
}

print "\n";

open my $out, '>', 'podList.txt' || die $!;
# Sort by key value, high->low, a->z
foreach my $key (sort {$scoreHash{$b} <=> $scoreHash{$a} || $a cmp $b} (keys %scoreHash)) {
  print "$key\t$scoreHash{$key}\n";
  print $out "$key\t$scoreHash{$key}\n";
}
close $out || die $!;

sub eloPred
  {
    # wiki: Elo rating system, keep to two decimals
    $ea1 = (int(100/(1 + 10**(($scoreHash{$pod2} - $scoreHash{$pod1})/400))))/100;
    $ea2 = (int(100/(1 + 10**(($scoreHash{$pod1} - $scoreHash{$pod2})/400))))/100;
  }

sub eloScore
  {
    my $win = shift @_;
    my $los = shift @_;
    my $eaw = shift @_;
    my $eal = shift @_;

    # k=32, can be changed to tweak sensitivity.  higher k = more sensitive to recents
    $scoreHash{$win} += 32*(1-$eaw);
    $scoreHash{$los} += 32*(0-$eal);

    print "Won: $win\tLost: $los\n";
  }
