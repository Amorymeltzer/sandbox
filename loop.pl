#!/usr/bin/env perl
# loop.pl by Amory Meltzer
# Test out loop labels and C-style loops

use strict;
use warnings;
use diagnostics;

for (my $i=1;$i<13;$i++)
{
    print "$i\n";
}

my @ar1 = qw(1 2 3 4 5);
my @ar2 = @ar1;

foreach my $i (@ar1)
{
    foreach my $j (@ar2)
    {
	if ($i == 4 && $j == 3)
	{
	    last;
	}
	print "$i\t$j\n";
    }
}

OUTER:foreach my $i (@ar1)
{
  INNER: foreach my $j (@ar2)
  {
      if ($i == 4 && $j == 3)
      {
	  last OUTER;
      }
      print "$i\t$j\n";
  }
}
