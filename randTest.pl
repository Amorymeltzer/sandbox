#!/usr/bin/env perl

use strict;
use warnings;

my $rand = -1;
my $var;
#unlink("output.txt");
open (my $doc, '>', "output.txt") or die "Haha!";

my ($sec,$min,$hour,$day,$mon,$year,$wday,
    $yday,$isdst)=localtime(time);
($year,$mon) = ($year+1900,$mon+1);
my $date = "$mon/$day/$year $hour:$min:$sec";

print $doc "$date\n";

$var = int(rand(100))+1;

while ($var != $rand)
{
    $rand = int(rand(100))+1;
    print $doc "$rand\n";
}

($sec,$min,$hour,$day,$mon,$year,$wday,
    $yday,$isdst)=localtime(time);
($year,$mon) = ($year+1900,$mon+1);
my $date1 = "$mon/$day/$year $hour:$min:$sec";

    print $doc "$date1\n$date";
print "$var\n$rand\n";
