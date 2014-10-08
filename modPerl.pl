#!/usr/bin/env perl

#use strict;
use warnings;

#open (my $output, ">>$0") || die $1;
#print $output "print \"test\\n\"\;\n";
#print "$0\n";

my $foo = 2;
print eval('$foo + 2'), "\n";
