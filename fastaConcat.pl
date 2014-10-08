#!/usr/bin/env perl
# fastaConcat.pl by Amory Meltzer 2012.11.09
# Concatenate fasta lines without dealing with all that hash shit

use strict;
use warnings;

my $seq = "";
my $head = "";
open (my $in, "<$ARGV[0]") or die $!;

while (<$in>)
{
    chomp;
    if (/^>/x)
    {
	print "$head$seq\n";
	$seq = "";
	$head = $_."\n";
    }    
    else
    {
	$seq.=$_;
	next until m/^>/;
    }
}
