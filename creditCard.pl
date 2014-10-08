#!/usr/bin/env perl
# creditCard.pl by Amory Meltzer
# Determine what type of card a given CC number refers to

use strict;
use warnings;
use diagnostics;

my $num = join(" ",@ARGV) // ""; # unpack, compress in case card number is input with spaces i.e. $ARGV[1], etc.
$num =~ s/[-\s]//g; # remove - and spaces

unless (@ARGV && $num =~ m/^[\dx]+$/i) # allow testing via X instead of number
{
    print "Usage: $0 <cardNumber>\n";
    exit;
}

my $length = length $num;

if ($num =~ m/^3[47]/)# && $length == 15)
{
    print "American Express\n";
}
elsif ($num =~ m/^3[68]/)# && $length == 14)
{
    print "Diners Club/Carte Blanche\n";
}
elsif ($num =~ m/^30[0-5]/)# && $length == 14)
{
    print "Diners Club/Carte Blanche\n";
}
elsif ($num =~ m/^4/)# && ($length == 13 || $length == 16))
{
    print "VISA\n";
}
elsif ($num =~ m/^5[1-5]/)# && $length == 16)
{
    print "MasterCard\n";
}
elsif ($num =~ m/^6011/)# && $length == 16)
{
    print "Discover\n";
}
else
{
    print "Card number not recognized\n";
}
