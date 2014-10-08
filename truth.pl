#!/usr/bin/env perl

use strict;
use warnings;


my $stuff = "AQBCDEFGHIJKL";

my $j0 = ($stuff =~ m/AB/);
if ($j0 == 1)
{
    print "hi\n";
}
elsif ($j0 == 0)
{
    print "bye\n";
}
