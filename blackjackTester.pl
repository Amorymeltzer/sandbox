#!/usr/bin/env perl
# Documents/perl/sandbox/blackjackTester.pl by Amory Meltzer
# Quiz myself on Blackjack basic strategy
# Or, with arguments, print what should be played

# Need to correct for surrender option FIXME TODO
## Simple printing very very naive, especially with wrong ranges and Aces
## Subroutine for simple printing

use strict;
use warnings;
use diagnostics;

use Term::ANSIColor;

unless ((@ARGV < 1) || ((@ARGV == 3) && ($ARGV[0] =~ /^h|s|p$/ix))) {
  print "Run with no arguments to play the game, or pass three arguments:\n";
  print "blackjackTester.pl <h, s, p> <dealer_value> <player_value>\n";
  exit;
}


my $randType = 0;
my $tmp;
my ($score,$count,$perc) = (0,0,0);
my ($hardScore,$hardCount,$hardPerc) = (0,0,0);
my ($softScore,$softCount,$softPerc) = (0,0,0);
my ($splitScore,$splitCount,$splitPerc) = (0,0,0);
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

if (@ARGV == 3) {
  my ($type,$deal,$play) = (uc($ARGV[0]),$ARGV[1],$ARGV[2]);

  if (($deal !~ /^\d+|J|Q|K|A$/) || $play !~ /^\d+|J|Q|K|A$/) {
    print "<dealer_value> and <player_value> must be numeric, or a face card\n";
    exit;
  }

  $deal = 10 if $deal =~ /^J|Q|K$/ix;
  $play = 10 if $play =~ /^J|Q|K$/ix;

  $deal = 11 if $deal =~ /^A$/ix;
  $play = 11 if $play =~ /^A$/ix;

  if (($deal < 2) || ($deal > 11)) {
    print "<dealer_value> must be between 2 and 11, or a face card\n";
    exit;
  }
  if (($play < 2) || ($play > 21)) {
    print "<player_value> must be between 2 and 21, or a face card\n";
    exit;
  }

  $deal--;
  if ($type eq 'H') {
    if ($play < 4) {
      print "<player_value> on hard hands must be no lower than 4\n";
      exit;
    }
    elsif ($play < 8) {
      $play = 8;
    }
    $play = 17 if $play > 17;
    $play -= 7;
    print "$hard[$play][$deal]\n";
  } elsif ($type eq 'S') {
    if ($play < 13) {
      print "<player_value on soft hands must be no lower than 13\n";
      exit;
    }
    elsif ($play > 19) {
      $play = 19;
    }
    $play -= 12;
    print "$soft[$play][$deal]\n";
  } elsif ($type eq 'P') {
    if ($play > 11) {
      print "<player_value> when splitting should be an individual card's";
      print " value, i.e. no higher than 11/A\n";
      exit;
    }
    $play--;
    print "$split[$play][$deal]\n";
  } else {
    print "Error\n";
    exit;
  }
} else {
  while (1) {
    system("clear");

    # No decimal points
    $perc=sprintf "%.f", 100*$score/$count if $score > 0;
    $hardPerc=sprintf "%.f", 100*$hardScore/$hardCount if $hardScore > 0;
    $softPerc=sprintf "%.f", 100*$softScore/$softCount if $softScore > 0;
    $splitPerc=sprintf "%.f", 100*$splitScore/$splitCount if $splitScore > 0;
    print color 'red';
    print "$score/$count, $perc%";
    print " (H: $hardPerc%, S: $softPerc%, P: $splitPerc%)\n";
    print color 'reset';

    $randType = int(rand(3))+1;
    if ($randType==1) {
      print colored("Hard ", 'cyan');
      quizshow (10,10,\@hard);
    } elsif ($randType==2) {
      print colored("Soft ", 'cyan');;
      quizshow (7,10,\@soft);
    } elsif ($randType==3) {
      print colored("Split ", 'cyan');;
      quizshow (10,10,\@split);
    } else {
      print "Error calculating random value between 1 and 3.\n";
      exit;
    }

  }
}

sub quizshow
  {
    my ($rows, $cols, $aref) = @_;
    my $row = int(rand($rows))+1;
    my $col = int(rand($cols))+1;
    my $player = $$aref[$row][0];
    my $dealer = $$aref[0][$col];
    my @answer = split //, $$aref[$row][$col];

    print "You have $player, dealer shows $dealer.  What do?\n";
    # print "$row, $player, $col, $dealer, @answer\n";
    print "[H]it, [S]tand, [D]ouble";
    print ", S[p]lit" if ($randType==3);
    print "\n";
    my $guess = <>;
    exit if $guess =~ /exit|no?/ix;

    shift @answer if $answer[0] =~ /r/ix; # No surrendering
    if ($guess =~ /$answer[0]/ix) { # try to get around silly Dh or Ph stuff
      print "Correct! You should @answer\n";
      calcScore(1);
    } else {
      if ($guess =~ /$answer[-1]/ix) {
	print "Almost correct! You should @answer\n";
	calcScore();
      } else {
	print "Sorry, the correct answer was @answer\n";
	calcScore();
      }
    }

    print "Next?";
    $guess = <>;
    chomp($guess);
    exit if $guess =~ /exit|no?/ix;
  }


sub calcScore
  {
    $tmp = shift;
    $score++ if $tmp;
    $count++;
    if ($randType == 1) {
      $hardScore++ if $tmp;
      $hardCount++;
    } elsif ($randType == 2) {
      $softScore++ if $tmp;
      $softCount++;
    } elsif ($randType == 3) {
      $splitScore++ if $tmp;
      $splitCount++;
    } else {
      print "Error calculating random value between 1 and 3.\n";
      exit;
    }
    return;
  }
