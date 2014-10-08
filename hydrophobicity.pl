#!/usr/bin/env perl

use strict;
use warnings;


#####################################################################
# BIOL/CMPU-353
# Fall 2008
# Final Project
#
# Due: Mon, Dec. 15
#
# Written by: Amory Meltzer
#
# Description:
#   This program reads a FASTA-formatted file of amino acid
#   sequences and uses the primary structure to predict hydrophobic
#   transmembrane (TM) domains that exist within the folded
#   structure of the final polypeptide.
#
#############################################################


########


# Filename of a (multi)FASTA-formatted file containing desireud
# protein sequences
#  my $inputSeq = "multiFASTA.txt";
#my $inputSeq = "ns2.txt";
my $inputSeq = $ARGV[0];

open (my $source, "<$inputSeq") || die $!;

# Create corresponding arrays for accessions and sequences
my (@aaSeqs,@accessions);
while (my $nextWord = <$source>)
{
    chomp($nextWord);
    if ($nextWord =~ m/^>/g)
    {
	# Array the accessions...
	@accessions = (@accessions,$nextWord);
    }
    else
    {
	# And array the actual sequences
	@aaSeqs = (@aaSeqs,$nextWord);
    }
}

close($source); # clean up!


# User-defined variables
my $domainLength = 20; # Number of amino acids to cross the membrane
my $threshold = 24; # Threshold level for hydrophobicity score
my $outputName = "domainPrediction.txt"; # Output filename

# Global variables
open (my $output, ">", "$outputName") || die $!;
my ($seqLength,$aaSeq,$accession);
my ($index,$lock);
my @chunk;
my %hydroPlot;
my %chunkMatches;
my $matches = 0;


my $seqNumber = @accessions-1; # Use zero-based indexing
# For each given sequence...
foreach my $k (0..$seqNumber)
{
    $aaSeq = $aaSeqs[$k]; # store the current sequence...
    $accession = $accessions[$k]; # store the current accession...
    $seqLength = length($aaSeq);  # calculate the sequence length...
    print "$accession\n";         # and begin the output
    print $output "$accession\n";

    # Construct the hash table relating amino acids
    # to their respective hydropathy index values
    buildHydroPlot();

    # Build a hash storing all sequences of the predetermined
    # domain length that have a total hydropathy index score
    # above the given threshold
    populateChunkMatches();

    my $matchNumber = 0; # Keep final count

    # Number of potential matching domains, used as indices
    # in the next step (one-based indexing)
    my $matchCount = "". keys(%chunkMatches);

    # Iterate through each potential TM region
    foreach my $key (1..$matchCount)
    {
	no warnings;

	# If there is a new hydrophobic domain far enough
	# away from the indexing point...
	if ($chunkMatches{$key}[0] - $index > $domainLength)
	{
	    if ($lock > 0)
	    {
		$matchNumber++; # increment the final count...

		# And print the old one!
		print $output "@{$chunkMatches{$lock}}\n";
	    }
	    # set the current (new) domain as the new index
	    $index = $chunkMatches{$key}[0];
	    $lock = $key;
	}
	# If it's just a nearby domain, but with a higher score...
	elsif ($chunkMatches{$key}[3] > $chunkMatches{$lock}[3])
	{
	    # replace the old index, just as before
	    $index = $chunkMatches{$key}[0];
	    $lock = $key;
	}
	# If it doesn't have a higher score, ignore it!
	else # if ($chunkMatches{$key}[3] <= $chunkMatches{$lock}[3])
	{
	}
	use warnings;
    }

    # Print the remaining, unprinted domain...
    print $output "@{$chunkMatches{$lock}}\n\n";

    # And report the number of matches
    $matchNumber++;
    print "-> Found $matchNumber match(es).\n\n";
    print $output "Found $matchNumber match(es).\n\n";

    # Reinitialize important values for the next iteration
    ($index,$lock) = (-$domainLength,0);
    %chunkMatches = ();
    @chunk = ();
}

close($output);

print "Please see the file named $outputName in this directory ";
print "for the full, verbose list of results.\n";


#==================================================================#

# Subroutine to construct the hydropathy index hash table
sub buildHydroPlot
{
    while (my $in=<DATA>)
    {
	chomp($in);                # Gobble the newline...
	my @residue = split (" ",$in); # Split each line of data,
	my $value = pop(@residue); # Popping out the score value
	my $res = shift(@residue); # And shifting out the amino acid
	$hydroPlot{$res} = $value;
    }
}


# Subroutine that, using the above hash scoring table,
# splits an  amino acid sequence into individual peptides,
# and scores each one individually, returning the  overall score
sub computeHydroScore
{
    my @piece = split(//,shift(@_));
    my $hydroScore = 0;
    foreach my $aa(@piece)
    {
	$hydroScore += $hydroPlot{$aa};
    }
    return $hydroScore;
}


# Creates a table of overlapping putative TM domains
sub populateChunkMatches
{
    $matches = 0;

    # At every position along the sequence...
    foreach my $i (0..$seqLength-$domainLength)
    {
	# Take a chunk out...
	$chunk[$i] = substr($aaSeq,$i,$domainLength);
	# And score it
	my $hydroScore = computeHydroScore($chunk[$i]);

	# If the score is high, store it
	if ($hydroScore > $threshold)
	{
	    $matches++;
	    $chunkMatches{$matches} = [($i+1,$chunk[$i],$i+$domainLength,$hydroScore)];
	}
    }
}



## The lines below do not represent Perl code, and are not
## examined by the compiler.  Rather, they are a list of hydropathy
## index scores published by Kyte and Doolittle (1982) and are
## read in by the subroutine buildHydroPlot as <DATA>.
__END__
A 1.8
R -4.5
N -3.5
D -3.5
C 2.5
Q -3.5
E -3.5
G -0.4
H -3.2
I 4.5
L 3.8
K -3.9
M 1.9
F 2.8
P -1.6
S -0.8
T -0.7
W -0.9
Y -1.3
V 4.2
