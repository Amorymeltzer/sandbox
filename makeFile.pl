#!/usr/bin/env perl

use strict;
use warnings;
my $path = "/Users/amorymeltzer/Documents/perl/sandbox/";

open (my $data, '>', "$path"."madeFile.txt") or die $!;

foreach (@ARGV)
{
    print $data "$_";
}
