#!/usr/bin/env perl

use strict;
use warnings;

my @table; # Game board matrix

buildTable(); # Initialize board
printTable(); # Print the current state of the game

my ($test,$testR,$testC) = (0,0,0); # Winrar?

xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;
xGo() if check() == 0;



sub buildTable
{
    for (my $row = 0; $row < 3; $row++)
    {
	@table = (@table, ["_","_","_"]);
    }
}

sub printTable
{
    for (my $row = 0; $row < 3; $row++)
    {
	for (my $col = 0; $col < 3; $col++)
	{
	    print $table[$row][$col];
	    print "|" if $col != 2;
	}
	print "\n";
    }
}


sub xGo
{
    print "X's turn (row,col)\n";
    my $ecks = <>;
    my @x = split (/,/,$ecks);
    $table[$x[0]-1][$x[1]-1] = "X";
    printTable();
}

sub oGo
{
    print "O's turn (row,col)\n";
    my $oh = <>;
    my @o = split (/,/,$oh);
    $table[$o[0]-1][$o[1]-1] = "O";
    printTable();
}

sub checkRow
{
    $testR = 0;
    for (my $checkR = 0; $checkR < 3; $checkR++)
    {
	$testR = $checkR + 1 if ($table[$checkR][0] eq $table[$checkR][1] && $table[$checkR][1] eq $table[$checkR][2] && $table[$checkR][0] =~ m/x|o/io);
    }
    return $testR;
}

sub checkCol
{
    $testC = 0;
    for (my $checkC = 0; $checkC < 3; $checkC++)
    {
	$testC = $checkC + 1 if ($table[0][$checkC] eq $table[1][$checkC] && $table[1][$checkC] eq $table[2][$checkC] && $table[0][$checkC] =~ m/x|o/io);
    }
    return $testC;
}

sub check
{
    checkRow();
    checkCol();
    $test = $testR+$testC;
    return $test;
}
