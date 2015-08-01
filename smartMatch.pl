#!/usr/bin/env perl
# smartMatch.pl by Amory Meltzer
# Test out the smartmatch feature http://perltraining.com.au/tips/2008-04-18.html

use strict;
use warnings;
use diagnostics;

use feature qw(say);

my $x = 'foo';
my $y = 'bar';
my $z = 'foo';
say '$x and $y are identical strings' if $x ~~ $y;
say '$x and $z are identical strings' if $x ~~ $z;     # Printed
print "$x and $z are identical strings\n" if $x ~~ $z; # Printed

my $num   = 100;
my $input = <>;
say 'You entered 100' if $num ~~ $input;

$input  = <>;
say 'You said the secret word!' if $input ~~ /friend/;


my @friends = qw(Frodo Meriadoc Pippin Samwise Gandalf);
my $name    = <>;
chomp $name;

say "You're a friend" if $name ~~ @friends;
my @foo = qw(x y z xyzzy ninja);
my @bar = qw(x y z xyzzy ninja);
say 'Identical arrays' if @foo ~~ @bar;

say 'Array contains a ninja ' if @foo ~~ 'ninja';
say 'Array contains a y ' if 'y' ~~ @foo;

say 'Array contains magic pattern' if @foo ~~ /xyz/;

my $array_ref = [5, 10, 15];
say 'Array contains 10' if $array_ref ~~ 10;

my %colour = (
	      sky   => 'blue',
	      grass => 'green',
	      apple => 'red',
	     );
$input = <>;
chomp $input;
say "I know the colour of $input, it's $colour{$input}" if $input ~~ %colour;
say "A key starts with 'gr'" if %colour ~~ /^gr/;

my %taste = (
	     grass => 'boring',
	     apple => 'yummy',
	     sky   => undef,
	    );
say 'Hashes have identical keys' if %taste ~~ %colour;
