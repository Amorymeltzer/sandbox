#!/usr/bin/env perl
# creditCard.pl by Amory Meltzer
# Determine what type of card a given CC number refers to

use strict;
use warnings;
use diagnostics;

my $num = join(q{ },@ARGV) // q{}; # unpack, compress in case card number is input with spaces i.e. $ARGV[1], etc.
$num =~ s/[-\s]//g;		   # remove - and spaces

unless (@ARGV && $num =~ m/^[\dx]+$/i) # allow testing via X instead of number
  {
    print "Usage: $0 <cardNumber>\n";
    exit;
  }

my $mun = reverse $num;
my @revNum = split //, $mun;
my $first = shift @revNum;
my $sum = 0;
foreach my $idx (0..scalar @revNum - 1) {
  $sum += $revNum[$idx];
  if (($idx+1)%2>0) {
    $sum += $revNum[$idx];
    $sum -= 9 if $revNum[$idx] >= 5;
  }
}

my $check = (9*$sum)%10;
my $valid = ($check+$sum)%10;
if ($valid == 0 && $check == $first) {
  print "Valid number!\n";
} else {
  print "Invalid!\n";
  exit;
}

my $length = length $num;

if ($num =~ m/^3[47]/)		# && $length == 15)
  {
    print "American Express\n";
  } elsif ($num =~ m/^3[68]/)	# && $length == 14)
  {
    print "Diners Club/Carte Blanche\n";
  } elsif ($num =~ m/^30[0-5]/)	# && $length == 14)
  {
    print "Diners Club/Carte Blanche\n";
  } elsif ($num =~ m/^4/)	# && ($length == 13 || $length == 16))
  {
    print "VISA\n";
  } elsif ($num =~ m/^5[1-5]/)	# && $length == 16)
  {
    print "MasterCard\n";
  } elsif ($num =~ m/^6011/)	# && $length == 16)
  {
    print "Discover\n";
  } else {
    print "Card number not recognized\n";
  }
