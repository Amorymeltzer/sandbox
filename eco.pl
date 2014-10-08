#!/usr/bin/env perl

use strict;
use warnings;

#================================================================
#
# Summary: This program takes a protein database, converts it
#          to fasta if it is not already formatted properly,
#          and then prints out specific protein sequences in
#          the desired fasta format.
#
# Programmer: Amory Meltzer
#
# Date Last Modified:10/15/08
# 10/08/2008 -- Started program
# 10/11/2008 -- Finished program
#
#===============================================================


my $filename = "ecoprot.txt"; # declare the initial protein database
my $acc = ""; # store accession numbers
my $noMatches = 0; # count positive matches

# open first set of files to read/write from/to
open (my $raw, '<', $filename) or die $!;
open (my $cleaned, '>', "fasta_$filename") or die $1;

# if the database is NOT in fasta format,
# go through it and properly format it.
while (my $nextWord = <$raw>)
{
    chomp($nextWord);
    if ($nextWord =~ m/^>/g)
    {
	print $cleaned "\n$nextWord\n";
    }
    else
    {
	print $cleaned "$nextWord";
    }
}
print $cleaned "\n";

close ($raw);
close ($cleaned);

# prepare files for final output
open (my $fasta, '<', "fasta_$filename") or die $1;
open (my $output, '>', "garrett_$filename") or die $1;

# using (new) fasta database, parse it for the sequence matches of interest
# store the accession number and, pending corresponding protein match
# print both to an output file

while (my $nextWord =<$fasta>)
{
    chomp($nextWord);
    if ($nextWord =~ m/^>/g)
    {
	$acc = $nextWord; # store accession number for potential use
    }

    if (($nextWord =~ m/^.SE.*/g) or ($nextWord =~ m/.*SE$/g))
    {
	$noMatches++;
        #if a match, print accession number and protein sequence
	print $output "$acc\n$nextWord\n";
	#$acc =""; # clear
    }
}

# keep track of the progress
if ($noMatches == 0)
{
    print "Sorry, but no matches were found\n.";
}
else
{
    print "Found $noMatches matches.  Please see the file named \"garrett_$filename\" for your list of applicable sequences.\n";
}
close ($fasta);
close ($output);
