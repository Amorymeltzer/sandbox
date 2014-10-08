#!/usr/bin/env perl
# mergePDF.pl by Amory Meltzer
# Merge PDFs, from http://stackoverflow.com/questions/17864419/merge-pdf-with-pdfapi2-under-perl-and-keeping-the-bookmarks

use strict;
use warnings;
use diagnostics;

use PDF::API2;

# files to merge
my @input_files = (
    'document1.pdf',
    'document2.pdf',
    'document3.pdf',
    );
my $output_file = 'new.pdf';

# the output file
my $output_pdf = PDF::API2->new(-file => $output_file);

foreach my $input_file (@input_files) {
    my $input_pdf = PDF::API2->open($input_file);
    my @numpages = (1..$input_pdf->pages());
    foreach my $numpage (@numpages) {
        # add page number $numpage from $input_file to the end of 
        # the file $output_file
        $output_pdf->importpage($input_pdf,$numpage,0);        
    }
}

$output_pdf->save();
