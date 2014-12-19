#!/usr/bin/env perl
# retirementSavingsGuide.pl by Amory Meltzer
# Calculate a reasonable salary checkpoint given an age
# http://www.businessinsider.com/retirement-savings-guide-2014-3

# Figure out how else to do hash of hash.  Shorter. ;;;;;; ##### FIXME TODO

use strict;
use warnings;
use diagnostics;

use POSIX;			# for floor/ceiling calculations

unless (@ARGV == 2) {
  print "Usage: $0 <age> <income>\n";
  exit;
}

if ($ARGV[0] =~ m/\D/gx) {
  print "Age must be a number\n";
  exit;
}

if ($ARGV[1] !~ m/^-?\d*\.?\d+$/gx) {
  print "Income must be in dollar form\n";
  exit;
}

my ($age,$income) = ($ARGV[0],$ARGV[1]);

# Round age to nearest half-decade
my $round = $age % 5;
$age = 5*floor($age/5);
$age +=5 if $round >= 2.5;
print "$age\n";

if ($age < 30 || $age > 65) {
  print "Your age must be between 30 and 65, sorry.\n";
  exit;
}

if ($income < 50000 || $income > 400000) {
  print "Your income must be between \$50,000 and \$400,000, sorry.\n";
  exit;
}

# Round income according to the ranges below
# Work backwards to avoid incompatibility
# Round to nearest 100k for 300k-400k
if ($income > 300000) {
  $income = properRound(100000);
}
# Round to nearest 50k for 100k-300k
elsif ($income > 100000) {
  $income = properRound(50000);
}
# Round to nearest quarter thousand for 50k-100k
else {
  $income = properRound(25000);
}
print "$income\n";

my %savings = (
	       30 => {50000 => 0.4, 75000 => 0.6, 100000 => 1.0, 150000 => 1.7, 200000 => 2.0, 250000 => 2.2, 300000 => 2.4, 400000 => 2.8},
	       35 => {50000 => 0.7, 75000 => 1.1, 100000 => 1.5, 150000 => 2.3, 200000 => 2.8, 250000 => 3.0, 300000 => 3.3, 400000 => 3.7},
	       40 => {50000 => 1.2, 75000 => 1.6, 100000 => 2.2, 150000 => 3.2, 200000 => 3.7, 250000 => 4.0, 300000 => 4.3, 400000 => 4.9},
	       45 => {50000 => 1.7, 75000 => 2.3, 100000 => 3.0, 150000 => 4.2, 200000 => 4.9, 250000 => 5.3, 300000 => 5.7, 400000 => 6.3},
	       50 => {50000 => 2.4, 75000 => 3.1, 100000 => 3.9, 150000 => 5.5, 200000 => 6.3, 250000 => 6.8, 300000 => 7.3, 400000 => 8.1},
	       55 => {50000 => 3.3, 75000 => 4.2, 100000 => 5.2, 150000 => 7.2, 200000 => 8.1, 250000 => 8.8, 300000 => 9.4, 400000 => 10.4},
	       60 => {50000 => 4.4, 75000 => 5.5, 100000 => 6.7, 150000 => 9.2, 200000 => 10.4, 250000 => 11.2, 300000 => 11.9, 400000 => 13.1},
	       65 => {50000 => 5.7, 75000 => 7.1, 100000 => 8.6, 150000 => 11.6, 200000 => 13.2, 250000 => 14.1, 300000 => 15.0, 400000 => 16.6}
	      );

my $mult = $savings{$age}{$income};
print "\nBy now you should have saved about $mult times your current salary.\n";
my $save = $mult*$income;
print "That comes to around \$$save.\n";


# Round according to particular ranges
sub properRound
  {
    my $divisor = shift;
    $round = $income % $divisor;
    $income = $divisor*floor($income/$divisor);
    $income += $divisor if $round >= $divisor/2;
    return $income;
  }
