#!/usr/bin/env perl
# opts.pl by Amory Meltzer
# Test (splitting of) comandline options

use strict;
use warnings;
use diagnostics;

use Getopt::Std;

# my $one = join('',@ARGV);
# print "$one\n";
# my @opts = split('-',$one);
# print "@opts\n";

my %opts = ();
my ($eh, $see, $ess, $bigEss) = ('','','','');
getopts( 'a:c:s:S:h', \%opts );
#getopts( 'a:c:s:Sh', \%opts );
if( $opts{a} ) { $eh = $opts{a} ; }
if( $opts{c} ) { $see = $opts{c}; }
if( $opts{s} ) { $ess = $opts{s}; }
if( $opts{S} ) { $bigEss = $opts{S}; }
if( $opts{h} ) { &usage; exit;}

print "eh\t$eh\n";
print "see\t$see\n";
print "ess\t$ess\n";
print "bigEss\t$bigEss\n";

sub usage {
    print <<USAGE;
    -W <canvas width>Default is 500
	-H <canvas height>Default is 500
	-b <background color>Default is blue
	-f <foreground color>Default is yellow
	-F <fuel>Default is 20
	-x <initail x position>Default is 0
	-y <initail y position>Default is 800
	-g <gravity>Default is 1.62 (the moon)
	-a <engine thrust>Default is 20
	-X <initail X velocity> Default is 0
	-Y <initail Y velocity> Default is 0
	-c <crash velocity> Default is 10
	-s <landing slope tolerance> Default is 0
	-S do not resize scene (ship may leave screen)
	-h print this message

	How to play
USAGE
}
