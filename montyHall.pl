#!/usr/bin/env perl

use strict;
use warnings;

my @doors;
my $carChance;
my $reveal = "123"; # All options, will just subst out car and choice

print "Play or Test?\n";
#my $choice = <>; # User choice for a full list or number
my $choice = "p";
while ($choice !~ m/[pt]/io)
{
    print "Try again\n";
    $choice = <>;
}

if ($choice =~ m/p/i) # Play the door game
{
    doorPopulate();
    print "\ttest\t$carChance\n";
    print "Do you want what's behind Door #1, Door #2, or Door #3?\n";
    $choice = <>; # Which door will you pick?

    while ($choice !~ m/[123]|one|two|three/io)
    {
	print "Pick again\n";
	$choice = <>;
    }
    
    $choice = "1" if $choice =~ m/1|one/io;
    $choice = "2" if $choice =~ m/2|two/io;
    $choice = "3" if $choice =~ m/3|three/io;


    # Reveal the goat
    
    $reveal =~ s/$choice//;
    $reveal =~ s/$carChance//;

    if (length($reveal) > 1)
    {
	my @reveals = split (//,$reveal); # split on the empty, get options
	$reveal = $reveals[int(rand(2))];
    }

    print "\treveal\t$reveal\n";

    print "Behind Door #$reveal is...\n";
    print "$doors[$reveal]\n";

    my $left = "123";
    $left =~ s/$choice//;
    $left =~ s/$reveal//;

    print "Do you want to switch to Door #$left?  Yes or No?\n";
    my $doorChoice = <>;
    $choice = $doorChoice if $doorChoice =~ m/yes|$left/io;

    print "\nCongratulations!  You've won a new car!\n" if $doors[$choice] eq "car";
    print "\nOhhh, sorry, you got the goat...\n" if $doors[$choice] eq "goat";
}


if ($choice =~ m/t/i) # Simulate the door game
{
    print "How many simulations do you want to run?\n";
    my $trials = <>;
    
    for my $x (1..$trials)
    {
	doorPopulate();

    }
}


#########################################################
# Subroutines
#########################################################

# Create the doors
sub doorPopulate
{
    $carChance = int(rand(3))+1;

    # 1 is the car, 2 is a goat
    # Makes opening revealing a goat simpler
    @doors = ("","goat","goat","goat");

    print "@doors\n";
    $doors[$carChance] = "car";
    print "$doors[1]\t$doors[2]\t$doors[3]\n";
}

# Which door will you pick?
sub doorChoice
{
    
}
