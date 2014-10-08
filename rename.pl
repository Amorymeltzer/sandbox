#!/usr/bin/env perl

use strict;
use warnings;

# Rename pdf files from MM/DD/YY to YYYY/MM/DD

my @files = <*.pdf>;

foreach my $file (@files)
{
    $file =~ m/(\d{1,2})\.(\d{1,2})\.(\d\d)\.pdf/i;
    print "20$3.$1.$2.pdf\n";
    rename($file,"20$3.$1.$2.pdf");
}
