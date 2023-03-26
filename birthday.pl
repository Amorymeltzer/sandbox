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
GetOptions(\%config, 'days|d=i', 'number|n=i', 'help' => \&usage);

printf "%.2f%%\n", birthday($config{days}, $config{number});

######## SUBROUTINES ########

# The actual equation for probability, simplified
sub birthday ($base, $sel) {
  return 100*(1-(1/$base**$sel)*factorial($base, $sel));
}

sub factorial ($base, $sel) {
  use List::Util qw(reduce);
  return reduce { $a * $b } $base-$sel+1..$base;
}


#### Usage statement ####
# Use POD or whatever?
# Escapes not necessary but ensure pretty colors
# Final line must be unindented?
sub usage {
  print <<"USAGE";
Usage: $PROGRAM_NAME [-hnd]
      -n Specify the number of people in a room.  Default 23.
      -d Specify the number days from which to choose.  Default 365.
      -h Print this message
USAGE
  exit;
}
