#!/usr/bin/env perl

use strict;
use warnings;

my @table; # Game board matrix

buildTable(); # Initialize board
printTable(); # Print the current state of the game

sub buildTable
{
    for (my $row = 0; $row < 5; $row++)
    {
	@table = (@table, ["_","_","_","_","_"]);
    }
}

sub printTable
{
    for (my $row = 0; $row < 5; $row++)
    {
	print "|";
	for (my $col = 0; $col < 5; $col++)
	{
	    print $table[$row][$col];
	    print "|";
	}
	print "\n";
    }
}
