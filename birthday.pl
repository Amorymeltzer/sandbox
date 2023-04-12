#!/usr/bin/env perl
# birthday.pl by Amory Meltzer
# Calculate birthday paradox/problem stuff

use strict;
use warnings;
use English;

# Subroutine signatures without warnings
use 5.036;

use Getopt::Long;
my %config = (days=>365, number=>23);
GetOptions(\%config, 'days|d=i', 'number|n=i', 'percent|p=i', 'help' => \&usage);

use POSIX qw(ceil);

if ($config{percent}) {
  if ($config{percent} >= 100 || $config{percent} < 1) {
    say 'Percent must be between 1 and 99, inclusive';
    exit 1;
  }
  say people($config{days}, $config{percent});
} else {
  printf "%.2f%%\n", birthday($config{days}, $config{number});
  # printf "%.2f%%\n", estimated($config{days}, $config{number});
}

######## SUBROUTINES ########

# The actual equation for probability, simplified
sub birthday ($base, $sel) {
  return 100*(1-(1/$base**$sel)*factorial($base, $sel));
}
# How many eg people for a given probability?
sub people ($base, $prob){
  # Naive attempt at 42%->0.42, guaranteed by the i=integer aspect of Getopt::Long
  $prob = $prob/100;
  # I think this is right?  Probably some issues at high values of p
  return ceil sqrt(2*$base*log(1/(1-$prob)));
}

sub factorial ($base, $sel) {
  use List::Util qw(reduce);
  return reduce { $a * $b } $base-$sel+1..$base;
}
# Simplified estimate, useful in theory for bigguns
sub estimated ($base, $sel) {
  return 100*(1-(exp -($sel**2)/(2*$base)))
}

#### Usage statement ####
# Use POD or whatever?
# Escapes not necessary but ensure pretty colors
# Final line must be unindented?
sub usage {
  print <<"USAGE";
Usage: $PROGRAM_NAME [-hnpd]
      -n Specify the number of people in a room.  Default 23.
      -p Specify a percent (1-99) for which to calculate the number of people required.
      -d Specify the number days from which to choose.  Default 365.
      -h Print this message
USAGE
  exit;
}
