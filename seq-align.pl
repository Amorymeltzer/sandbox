#!/usr/bin/env perl

use strict;
use warnings;
no warnings "recursion";

#====================================================================
#
# BIOL/CMPU-353: Bioinformatics
# Fall 2008
# 
# seq-align.pl
#
# Summary: Performs sequence alignment and computes similarity
#          of two sequences (an implementation of the 
#          Needleman-Wunsch algorithm)
#
# Written by: Rex A. Dwyer (from his text, "Genomic Perl")
# Adapted by: Marc Smith
# 
#====================================================================


# Global variables
my @M;           ## Similarity scoring matrix
my $g = -2;      ## gap penalty

my $seq1;        ## sequences
my $seq2;        ## to be aligned

# Add/uncomment the pair of sequences to be aligned
#$seq1 = "MSVVGIDLGFQSCYVAVARAGGIETIANEYSDRCTPACISFGPKNRSIGAAAKSQVISNAKNTVQGFKRFHGRAFSDPFVEAEKSNLAYDIVQLPTGLTGIKVTYMEEERNFTTEQVTAMLLSKLKETAESVLKKPVVDCVVSVPCFYTDAERRSVMDATQIAGLNCLRLMNETTAVALAYGIYKQDLPALEEKPRNVVFVDMGHSAYQVSVCAFNRGKLKVLATAFDTTLGGRKFDEVLVNHFCEEFGKKYKLDIKSKIRALLRLSQECEKLKKLMSANASDLPLSIECFMNDVDVSGTMNRGKFLEMCNDLLARVEPPLRSVLEQTKLKKEDIYAVEIVGGATRIPAVKEKISKFFGKELSTTLNADEAVTRGCALQCAILSPAFKVREFSITDVVPYPISLRWNSPAEEGSSDCEVFSKNHAAPFSKVLTFYRKEPFTLEAYYSSPQDLPYPDPAIAQFSVQKVTPQSDGSSSKVKVKVRVNVHGIFSVSSASLVEVHKSEENEEPMETDQNAKEEEKMQVDQEEPHVEEQQQQTPAENKAESEEMETSQAGSKDKKMDQPPQAKKAKVKTSTVDLPIENQLLWQIDREMLNLYIENEGKMIMQDKLEKERNDAKNAVEEYVYEMRDKLSGEYEKFVSEDDRNSFTLKLEDTENWLYEDGEDQPKQVYVDKLAELKNLGQPIKIRFQESEERPKLFEELGKQIQQYMKIISSFKNKEDQYDHLDAADMTKVEKSTNEAMEWMNNKLNLQNKQSLTMDPVVKSKEIEAKIKELTSTCSPIISKPKPKVEPPKEEQKNAEQNGPVDGQGDNPGPQAAEQGTDTAVPSDSDKKLPEMDID";
#$seq2 = "MSKAVGIDLGTTYSCVAHFANDRVDIIANDQGNRTTPSFVAFTDTERLIGDAAKNQAAMNPSNTVFDAKRLIGRNFNDPEVQADMKHFPFKLIDVDGKPQIQVEFKGETKNFTPEQISSMVLGKMKETAESYLGAKVNDAVVTVPAYFNDSQRQATKDAGTIAGLNVLRIINEPTAAAIAYGLDKKGKEEHVLIFDLGGGTFDVSLLFIEDGIFEVKATAGDTHLGGEDFDNRLVNHFIQEFKRKNKKDLSTNQRALRRLRTACERAKRTLSSSAQTSVEIDSLFEGIDFYTSITRARFEELCADLFRSTLDPVEKVLRDAKLDKSQVDEIVLVGGSTRIPKVQKLVTDYFNGKEPNRSINPDEAVAYGAAVQAAILTGDESSKTQDLLLLDVAPLSLGIETAGGVMTKLIPRNSTISTKKFEIFSTYADNQPGVLIQVFEGERAKTKDNNLLGKFELSGIPPAPRGVPQIEVTFDVDSNGILNVSAVEKGTGKSNKITITNDKGRLSKEDIEKMVAEAEKFKEEDEKESQRIASKNQLESIAYSLKNTISEAGDKLEQADKDTVTKKAEETISWLDSNTTASKEEFDDKLKELQDIANPIMSKLYQAGGAPGGAAGGAPGGFPGGAPPAPEAEGPTVEEVD";

#$seq1 = "HOUSE";
#$seq2 = "HOME";

$seq1 = "THISSEQUENCE";
$seq2 = "THISISASEQUENCE";


# Main control flow:

# 1. Build scoring matrix for $seq1 and $seq2
similarity($seq1, $seq2);

# 2. Align sequences and report alignment results
my ($alignedSeq1, $alignedSeq2) = getAlignment($seq1, $seq2);
print "$alignedSeq1\n\n$alignedSeq2\n";

#====================================================================
# Subroutines below...
#====================================================================

# Returns the max of the given values
sub max
{
  # @_ is the list of values passed into this subroutine
  # $m will be assigned the first value from @_
  # @l is an array that will contain the rest of the values from @_
  my ($m, @l) = @_;
  
  # A loop to iterate through each value $x from @l; if any such $x
  # from @l is greater than the current $m, it becomes the new $m.
  foreach my $x (@l) 
  {
    if ($x > $m) 
    {
      $m = $x;
    }
  }
  
  return $m;
}


# Returns +1 or -1, depending on whether its two arguments are the 
# same or different, respectively.
sub p 
{
  # @_ is the list of values passed into this subroutine
  # $aa1 will be assigned the first value from @_
  # $aa2 will be assigned the second value from @_
  my ($aa1, $aa2) = @_;
  
  if ($aa1 eq $aa2)
  {
    return 1;
  }
  else 
  {
    return -1;
  }
}


# Populates matrix @M and returns the similarity score of its 
# arguments, $s and $t.
sub similarity
{
  my ($s, $t) = @_;
  my ($i, $j);

  # initialize the first column of @M
  foreach $i (0..length($s)) 
  { 
    $M[$i][0] = $g * $i;
  }

  # initialize the first row of @M
  foreach $j (0..length($t))
  {
    $M[0][$j] = $g * $j;
  }

  foreach $i (1..length($s))    ## for each row after the first
  {
    foreach $j (1..length($t))  ## for each col within current row
	{
      # Score of the current square is the max of:
      # -- the score of square above + gap penalty,
	  # -- the score of square before + gap penalty,
	  # -- the score of square diag above to left + p(current pair)
      my $p = p(substr($s, $i-1, 1), substr($t, $j-1, 1));
      $M[$i][$j] = max($M[$i-1][$j] + $g,    ## square above
                       $M[$i][$j-1] + $g,    ## square before
                       $M[$i-1][$j-1]+ $p);  ## square diag left up
	}
  }
  
  # lower right corner of M contains score of $s and $t's alignment
  return ($M[length($s)][length($t)]);
}


# Assumes matrix @M has been filled, takes two strings of letters as
# arguments, an returns a list of the same two strings with gap 
# symbols inserted to achieve the best possible alignment.
sub getAlignment
{
  my ($s, $t) = @_;
  my ($i, $j) = (length($s),length($t));

  if ($i == 0)  ## Case 0a
  {
    return ("-" x $j, $t);
  }
	
  if ($j == 0)  ## Case 0b
  {
    return ($s, "-" x $i);
  }
	
  my ($sLast, $tLast) = (substr($s, -1), substr($t, -1));
  
  if ($M[$i][$j] == $M[$i-1][$j-1] + p($sLast, $tLast)) 
  { 
	## Case 1: last letters are paired in the best alignment  
	my ($sa, $ta) = getAlignment(substr($s,0,-1), substr($t,0,-1));
    return ($sa.$sLast, $ta.$tLast);
  }
  elsif ($M[$i][$j] == $M[$i-1][$j]+$g) 
  {
     ## Case 2: last letter of the first string is paired with a gap
	my ($sa, $ta) = getAlignment(substr($s,0,-1), $t);
    return ($sa.$sLast, $ta."-");
  }
  else  
  {
    ## Case 3: last letter of the second string is paired with a gap
	my ($sa, $ta) = getAlignment($s, substr($t,0,-1));
    return ($sa."-", $ta.$tLast);
  }
}
