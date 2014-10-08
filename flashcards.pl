#!/usr/bin/env perl

use strict;
use warnings;

use Term::ANSIColor;

my $score = 0;
my %wordHash;
my @wordList;

open (my $data, "<", "vocab.csv") || die $1;
while (my $in = <$data>)
{
    chomp($in);
    my @info = split (",",$in);
    my $word = shift(@info);
    my $def = substr($in,length($word)+1);
    $def =~ s/"//gix;
    $wordHash{$word} = $def;
    @wordList = (@wordList,$word);
}
close ($data);

my $length = keys %wordHash;

my $infinite = -1;
while ($infinite != 0)
{
    system("clear");
    my $rand = int(rand($length-1))+1; # ignore the header
    my $finally = $wordList[$rand];
    print "Score: $score\n";
    print color 'red';
    print "$finally means\.\.\.\?";
    my $name = <>;
    print color 'cyan';
    print "$wordHash{$finally}\n";
    print color 'reset';
    print "Next?";
    $name = <>;
    chomp($name);
    $score++ if $name eq "=";
    $score-- if $name eq "-";
    exit if $name eq "exit";
}
