#!/usr/bin/env perl
# musicRate.pl by Amory Meltzer
# Facemash/chess-ranking analogue for rankingmusic
## Implement correct percentage
## http://fivethirtyeight.com/datalab/introducing-nfl-elo-ratings/
## Pr(A) = 1 / (10^(-ELODIFF/400) + 1)

use strict;
use warnings;
use diagnostics;

use Term::ANSIColor;

my %scoreHash;
my @songList;
my ($rand1,$rand2,$song1,$song2,$rating,$ea1,$ea2); # make global

# Build a hash storing current tracks, any scores
open my $data, '<', 'trackTest.txt' || die $!;
while (<$data>) {
  chomp;
  my @line = split /\t/;
  $scoreHash{$line[0]} = $line[1] // 1400;
  @songList = (@songList,$line[0]);
}
close $data || die $!;

# Start the scoring process, these are just needed once
system 'clear';
print "Rate these two songs.  A for the left one, L for the right one\n";

# Loop through 'em all
my $length = keys %scoreHash;
my $infinite = -1;
while ($infinite !=0) {
  $rand1 = int(rand($length));
  $rand2 = int(rand($length));

  # Can't compare a song to itself
  while ($rand1 == $rand2) {
    $rand2 = int(rand($length-2))+1;
  }

  ($song1,$song2) = ($songList[$rand1],$songList[$rand2]);
  eloPred();
  print colored ['red'],"$song1 ($scoreHash{$song1}, $ea1)";
  print ' or ';
  print colored ['red'],"$song2 ($scoreHash{$song2}, $ea2)\n";

  $rating = <>;
  chomp $rating;
  # system 'clear';
  if ($rating eq 'a') {
    eloScore($song1,$song2,$ea1,$ea2);
    $scoreHash{$song1}++;
    print "$song1:\t$scoreHash{$song1}\n";
  } elsif ($rating eq 'l') {
    eloScore($song2,$song1,$ea2,$ea1);
    $scoreHash{$song2}++;
    print "$song2:\t$scoreHash{$song2}\n";
  } elsif ($rating eq 'exit' || $rating eq 'q' || $rating eq 'quit') {
    last;
  }
}

print "\n";

open my $out, '>', 'trackTest.txt' || die $!;
# Sort by key value, high->low, a->z
foreach my $key (sort {$scoreHash{$b} <=> $scoreHash{$a} || $a cmp $b} (keys %scoreHash)) {
  print "$key\t$scoreHash{$key}\n";
  print $out "$key\t$scoreHash{$key}\n";
}
close $out || die $!;

sub eloPred
  {
    # wiki: Elo rating system, keep to two decimals
    $ea1 = (int(100/(1 + 10**(($scoreHash{$song2} - $scoreHash{$song1})/400))))/100;
    $ea2 = (int(100/(1 + 10**(($scoreHash{$song1} - $scoreHash{$song2})/400))))/100;
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
