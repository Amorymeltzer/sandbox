#!/usr/bin/env perl

use strict;
use warnings;

my $file = 'input.csv';
my ($line, $field1, $field2, $field3, $field4);

open F, $file || die "Could not open $file!";

while ($line = <F>) {
  ($field1,$field2,$field3,$field4) = split /,/, $line;
  print "$field1 : $field2 : $field3 : $field4";
}
print "\n";

close F;
