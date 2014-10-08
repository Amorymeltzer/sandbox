#!/usr/bin/env perl -l
# newLine.pl by Amory Meltzer
# test out new line option, see -l on hashbang

use strict;
use warnings;
use diagnostics;

die "You need to specify a file.\nStopped" unless @ARGV == 1;
open (my $file, '<', $ARGV[0]) or die $1;
while (<$file>)
{
    chomp; # should be no newline if -l so nothing changes here, but if no -l, everybody on one line
    print;
}
close $file;
