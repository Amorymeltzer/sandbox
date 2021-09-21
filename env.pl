#!/usr/bin/env perl
# env by Amory Meltzer
# Environment stuff

use strict;
use warnings;
use diagnostics;

print "$ENV{LOGNAME}\n";
print "$ENV{USER}\n";
print getpwuid($<)."\n";
my @asd = (getpwuid($<));
print "@asd\n";

use English;

my $home =  $ENV{HOME}
  // $ENV{LOGDIR}
  // (getpwuid($UID))[7]
  // die "You're homeless!\n";

use Data::Dumper;

print Dumper(\%ENV);
