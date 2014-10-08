#!/usr/bin/env perl
# evalTest.pl by Amory Meltzer
# Testing eval

use strict;
use warnings;
use diagnostics;

my $nom = "5";
my $den = "0";
my $answer;

print "Dividing $nom by $den\n";

#$answer = $nom / $den;

eval { $answer = $nom / $den; }; warn $@ if $@;

eval '$answer = $nom / $den'; warn $@ if $@;
