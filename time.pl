#!/usr/bin/env perl

use strict;
use warnings;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$year = $year+1900;
$mon = $mon+1;
my $date = "$mon/$mday/$year $hour:$min:$sec";
print "$date\n";
printf"%2d/%02d/%04d %02d:%02d:%02d\n",$mon,$mday,$year,$hour,$min,$sec;

print "$year\n";
print "$wday\n";
