#!/usr/bin/env perl
# eloRate.pl by Amory Meltzer
# Quick and dirty ranking via Elo
## Implement correct percentage
## http://fivethirtyeight.com/datalab/introducing-nfl-elo-ratings/
## Pr(A) = 1 / (10^(-ELODIFF/400) + 1)

use strict;
use warnings;
use diagnostics;

use Getopt::Std;
use English qw( -no_match_vars);
use Term::ANSIColor;

# Parse commandline options
my %opts = ();
getopts('hdk:', \%opts);
usage() if $opts{h};

# k can be changed to tweak sensitivity.  higher k = more sensitive to recents
my $k = $opts{k} || 42;
if ($k !~ /^\d+$/) {
  print "k must be an integer\n";
  exit 1;
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


# Jut in case
my $error = 0;
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

  if (!$opts{d}) {
    system 'clear';
  }

  if ($error) {
    print colored ['red'], "$rating was not a valid entry, the last round was skipped\n\n";
    $error = 0;
  }

  print "Rate these two items.\n";
  print "Press A to select the left one, L for the right one.  S to skip, Q to quit.\n\n";

  if ($opts{d}) {
    print colored ['blue'],"$item1 ($scoreHash{$item1}, $ea1)";
    print ' or ';
    print colored ['blue'],"$item2 ($scoreHash{$item2}, $ea2)\n";
  } else {
    print colored ['blue'],"$item1";
    print ' or ';
    print colored ['blue'],"$item2\n";
  }

  $rating = <STDIN>;
  chomp $rating;
  next if $rating eq 's' or $rating eq 'S';
  last if $rating eq 'exit' || $rating eq 'q' || $rating eq 'Q' || $rating eq 'quit';

  if ($rating eq 'a' || $rating eq 'A') {
    eloScore($item1,$item2,$ea1,$ea2);
  } elsif ($rating eq 'l' || $rating eq 'L') {
    eloScore($item2,$item1,$ea2,$ea1);
  } else {
    $error = 1;
    next;
  }

  if ($opts{d}) {
    print "$item1:\t$scoreHash{$item1}\n";
    print "$item2:\t$scoreHash{$item2}\n";
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

  $scoreHash{$win} += $k*(1-$eaw);
  $scoreHash{$los} += $k*(0-$eal);

  if ($opts{d}) {
    print "\nWon: $win\tLost: $los\n";
    print "$win:\t$scoreHash{$win}\n";
    print "$los:\t$scoreHash{$los}\n";
  }
}


#### Usage statement ####
# Use POD or whatever?
# Escapes not necessary but ensure pretty colors
# Final line must be unindented?
sub usage {
  print <<"USAGE";
Usage: $PROGRAM_NAME [-hd] [-k 42] list.csv
      -d Show points and predictions while scoring
      -k Provide a specific k, default is 42
      -h Print this message
USAGE
  exit;
}
