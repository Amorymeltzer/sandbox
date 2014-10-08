#!/usr/bin/env perl

use strict;
use warnings;

open(my $table, '<table.txt'); # csv(?) format of a sudoku table

my %answers; # Hash table to do the grunt work
my $count;
my @empty; # Keep track of dead empties

# Fill %answers with table data
while (my $line = <$table>) # while instead of foreach allows use of $.
{
    chomp($line);
    print "$.\t$line\n";

    $count = $line =~ tr/,/,/;
    $count++;
    my @list = split(/,/,$line);
    foreach my $x (1..$count)
    {
	my $time = $.;
	my $fix = $time.$x;
	$answers{$fix} = $list[$x-1] if $list[$x-1] =~ m/\d/;
	$answers{$fix} = "123" if $list[$x-1] =~ m/\s/;
	@empty = (@empty,"$fix") if $list[$x-1] =~ m/\s/;
    }
}
sudoSudoku();
sudoSudoku();

sub sudoSudoku
{
    foreach my $dead (@empty)
    {
	my @ref = split(//,$dead);
	foreach my $row (1..$count)
	{
	    next if $row == $ref[0];
#	print "A\t$dead\t$answers{$dead}\t$row.$ref[1]\t$answers{$row.$ref[1]}\n";
	    $answers{$dead} =~ s/$answers{$row.$ref[1]}//i if ($answers{$row.$ref[1]} =~ m/^\d$/i && $answers{$dead} !~ m/^\d$/i);
#	print "B\t$dead\t$answers{$dead}\t$row.$ref[1]\t$answers{$row.$ref[1]}\n";
	}
	
	foreach my $col (1..$count)
	{
	    next if $col == $ref[1];
#	print "C\t$dead\t$answers{$dead}\t$ref[0].$col\t$answers{$ref[0].$col}\n";
	    $answers{$dead} =~ s/$answers{$ref[0].$col}//i if ($answers{$ref[0].$col} =~ m/^\d$/i && $answers{$dead} !~ m/^\d$/i);
#	print "D\t$dead\t$answers{$dead}\t$ref[0].$col\t$answers{$ref[0].$col}\n";
	}
    }
}

print "$answers{11},$answers{12},$answers{13}\n$answers{21},$answers{22},$answers{23}\n$answers{31},$answers{32},$answers{33}\n";
