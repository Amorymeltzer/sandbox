#!/usr/bin/env perl
## TODO
# number of letters
# first letter
# sort and store
# suggest subroutine
# place?
# failsafe

use strict;
use warnings;

use Array::Uniq;

my $dictionary = "big_english.txt";
#my $dictionary = "english.txt";
my $hangTmp = "hang_tmp.txt";
my $working = "hang_working.txt";

my %ranking;
my $letterCounts;
my $wordCount = "0";


print "How long is the word?\n";
my $wordLength = <>;

open (my $dict, "<$dictionary") or die $1;
open (my $tmp, ">$hangTmp") or die $1;

while (my $word = <$dict>) {
  chomp($word);
  $word = uc($word);
  print $tmp "$word\n" if length($word) == $wordLength;
}
close($dict);
close($tmp);

print "What is the first known letter?\n";
my $guess = <>;

chomp($guess);			# not necessary if the /x option used in regex


open ($tmp, "<$hangTmp") or die $!;
while (my $word = <$tmp>) {
  chomp($word);
  $word = uc($word);

  if ($word =~ m/$guess/io) {
    $wordCount++;
    print "$word\n";
    letterCount($word);
  }
}

sortAndShow();

close ($dict);



##########################################
#Rank the letters
sub letterCount
  {
    my @letterTmp = split(//,shift(@_));
    my @letters = uniq sort @letterTmp;

    my $lettersLength=@letters;
    for my $x (0..$lettersLength-1) {
      $ranking{$letters[$x]}++;
    }
    $letterCounts++;
  }


sub sortAndShow
  {
    #    my @sortedKeys = sort {$a cmp $b} (keys %ranking); # alphabetical
    #    my @sortedKeys = sort {$ranking{$b} <=> $ranking{$a}} (keys %ranking); # most common first
    my @sortedKeys = sort {$ranking{$b} <=> $ranking{$a} || $a cmp $b} (keys %ranking); # common then alpha

    my $end = 10;
    $end = @sortedKeys-1 if @sortedKeys < 10; # Top ten or all
    print "\n$wordCount Words\nLeader List:\n";
    for my $num (0..$end) {
      if ($guess !~ m/$sortedKeys[$num]/i) {
	#	    print "$sortedKeys[$num]\t$guess\n";

	# 3 decimal spaces
	my $percentage = sprintf "%.3f", $ranking{$sortedKeys[$num]}/$letterCounts/$wordCount*100;
	#	    print "\t$sortedKeys[$num] - $ranking{$sortedKeys[$num]} $percentage \%\n";
	print "\n$sortedKeys[$num]\t$ranking{$sortedKeys[$num]}\t$percentage \%\n";
      }
    }
  }
