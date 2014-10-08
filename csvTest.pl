#!/usr/bin/env perl

use strict;
use warnings;

open (my $output, ">csv.csv") || die $1;

my $comma;
my $value = "20,5";
my $test = "\"20,5\"";

print $output "$value,$test\n";
fixComma($value);
print $output "$value";


sub fixComma
{
    $_[0] =~ m/(.*),(.*)/i;
    $value = "\"$1,$2\"";
    return $value;
}
