#!/usr/bin/env perl
# whatColorIsThis.pl by Amory Meltzer
# Return what color a given RGB code represents
# Requires http://xkcd.com/color/rgb.txt
# From http://codegolf.stackexchange.com/a/32604/8946
# Tweaked for convenience, showing more information

use strict;
use warnings;
use diagnostics;

sub hex2rgb ($) {
  my ($h) = @_;
  map {hex} ($h=~/[0-9a-fA-F]{2}/g)
}

sub distance ($$) {
  my ($acol1, $acol2) = @_;
  my $r = 0;
  $r += abs($acol1->[$_] - $acol2->[$_]) for (0..$#$acol1);
  $r
}

sub read_rgb {
  open my $rgb, '<', 'rgb.txt' or die $!;
  my @col;
  while (<$rgb>) {
    my ($name, $hex) = split /\t#/;
    my @rgb = hex2rgb $hex;
    push @col, [@rgb, $name];
  }
  close $rgb;
  \@col
}

my $acolours = read_rgb;
print "What color should I analayze?  <R,G,B>\n";
my @C = split /, */, <>;


#  printf "%.02f%% %s\n", (768-$_->[0])/768*100, $_->[4] for
printf "%.02f%% %s (%s,%s,%s)\n", (768-$_->[0])/768*100, $_->[4], $_->[1], $_->[2], $_->[3] for
  (sort {$a->[0] <=> $b->[0]}
   map [distance(\@C, $_), @$_], @$acolours)[0..4];
