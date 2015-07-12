#!/usr/bin/env perl

use strict;
use warnings;

my @numbers = (2..51);
open my $output, '>', 'numbers.txt' or die $!;

print $output '=IF(C1=\"M\",B1,\"0\")';

foreach my $num (@numbers) {
  print $output " + IF(C$num=\"M\",B$num,\"0\")";
}

close $output or die $!;
