#!/usr/bin/env perl
# netBenefits.pl by Amory Meltzer
# Quickly grab daily updates for some investments
# Updates around 7pm PST
# Depends on ~/bin/ticker.sh, a simple curl/perl from Yahoo

use strict;
use warnings;

eval 'use diagnostics; 1' or warn 'diagnostics not found';
#if  (eval {require PDF;1;} ne 1) {
#    print "wow\n"; # if module can't load
#} else {
#    print "okay\n";
#    diagnostics->import();
#}

my @tickers = ('FGCKX','FDIKX','CCPIX','VSCPX','VGSNX','VFFVX','RDITX','SSO','QLD','VOOG','QQQ','^DJI','^IXIC','^GSPC','^NYA','^TNX');

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime time;
$year = $year+1900;
$mon = $mon+1;
my $date = "$mon/$mday/$year";

system "echo $date > ~/Documents/perl/sandbox/beneOut.csv";

foreach my $stock (@tickers)
{
    print "$stock\t";
    my $value = `~/bin/stockclose $stock`;
    $value =~ s/,//gx;
    chomp $value;
    print "$value\n";
    system "echo $value >> ~/Documents/perl/sandbox/beneOut.csv";
}

#  system "perl -pi -e 's/\r//gi' ~/Documents/perl/sandbox/beneOut.csv";
system "perl -pi -e 's/\n/\,/gi' ~/Documents/perl/sandbox/beneOut.csv";

print "Data in file: beneOut.csv\n";
