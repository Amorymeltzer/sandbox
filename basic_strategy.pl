#!/usr/bin/env perl
# basic_strategy.pl by Amory Meltzer
# Print basic strategy for blackjack
# 4-8 decks, dealer stands on soft 17


# Ph only if double allowed after split.  Likely?  Or should it just be hit?

use strict;
use warnings;
use diagnostics;

use Term::ANSIColor;

my @hard = (
	    [ qw (Hard 2 3 4 5 6 7 8 9 10 A)],
	    [ qw (4-8 H H H H H H H H H H)],
	    [ qw (9 H Dh Dh Dh Dh H H H H H)],
	    [ qw (10 Dh Dh Dh Dh Dh Dh Dh Dh H H)],
	    [ qw (11 Dh Dh Dh Dh Dh Dh Dh Dh Dh H)],
	    [ qw (12 H H S S S H H H H H)],
	    [ qw (13 S S S S S H H H H H)],
	    [ qw (14 S S S S S H H H H H)],
	    [ qw (15 S S S S S H H H Rh H)],
	    [ qw (16 S S S S S H H Rh Rh Rh)],
	    [ qw (17+ S S S S S S S S S S)],
	   );

my @soft = (
	    [ qw (Soft 2 3 4 5 6 7 8 9 10 A)],
	    [ qw (13 H H H Dh Dh H H H H H)],
	    [ qw (14 H H H Dh Dh H H H H H)],
	    [ qw (15 H H Dh Dh Dh H H H H H)],
	    [ qw (16 H H Dh Dh Dh H H H H H)],
	    [ qw (17 H Dh Dh Dh Dh H H H H H)],
	    [ qw (18 S Ds Ds Ds Ds S S H H H)],
	    [ qw (19+ S S S S S S S S S S)],
	   );

my @split = (
	     [ qw (Split 2 3 4 5 6 7 8 9 10 A)],
	     [ qw (2/2 Ph Ph P P P P H H H H)],
	     [ qw (3/3 Ph Ph P P P P H H H H)],
	     [ qw (4/4 H H H Ph Ph H H H H H)],
	     [ qw (5/5 D D D D D D D D H H)],
	     [ qw (6/6 Ph P P P P H H H H H)],
	     [ qw (7/7 P P P P P P H H H H)],
	     [ qw (8/8 P P P P P P P P P P)],
	     [ qw (9/9 P P P P P S P P S S)],
	     [ qw (10/10 S S S S S S S S S S)],
	     [ qw (A/A P P P P P P P P P P)],
	    );

# Pass arrays (of arrays) as references
repeater (11,11,\@hard);
repeater (8,11,\@soft);
repeater (11,11,\@split);

#######
sub repeater
  {
    my ($rows, $cols, $aref) = @_;

    for (my $j=0;$j<$rows;$j++) {
      for (my $i=0;$i<$cols;$i++) {
	prettyPrintTable(${$aref}[$j][$i]); # scalar $ of array @ $aref
      }
      print "\n";
    }
    return;
  }

sub prettyPrintTable
  {
    my $test = shift;

    if ($test eq 'H') {
      print colored("$test ", 'red');
    } elsif ($test eq 'S') {
      print colored("$test ", 'bright_yellow');
    } elsif ($test =~ m/^P|Ph$/x) {
      print colored("$test ", 'green');
    } elsif ($test =~ m/^D|Dh|Ds$/x) {
      print colored("$test ", 'blue');
    } elsif ($test =~ m/^R|Rh|Rs|Rp$/x) {
      print colored("$test ", 'white');
    } elsif ($test =~ m/^Hard|Soft|Split$/x) {
      print colored("$test ", 'bright_cyan');
    } else {
      print colored("$test ", 'bold bright_magenta');
    }
    return;
  }
