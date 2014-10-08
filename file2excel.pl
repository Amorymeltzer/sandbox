#!/usr/bin/env perl
# file2excel.pl by Amory Meltzer
# Convert text file to excel
# From perldoc Spreadsheet::WriteExcel

use strict;
use warnings;
use diagnostics;

use Spreadsheet::WriteExcel;

my $workbook  = Spreadsheet::WriteExcel->new('file.xls');
my $worksheet = $workbook->add_worksheet();

open INPUT, 'file.txt' or die "Couldn't open file: $!";

$worksheet->write($.-1, 0, [split]) while <INPUT>;
