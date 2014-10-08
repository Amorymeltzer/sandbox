#!/usr/bin/env perl -w
use strict;

open WORDS, "big_english.txt" or die "no more words: $!";

for (@ARGV) {
    my @avoid = do {
	my @lits = /[a-z]/g;
	@lits ? "[" . join("", @lits) . "]" : ()
    };
    my %template;
    my $regex = "^";
    for (split //) {
	if (/[a-z]/) {
	    $regex .= "$_";
	} elsif (/[A-Z]/) {
	    if (exists $template{$_}) {
		$regex .= $template{$_};
	    } else {
		my $id = 1 + keys %template;
		if (@avoid) {
		    $regex .= "(?!" . join("|", @avoid) . ")";
		}
		$regex .= "(.)";
		push @avoid, $template{$_} = "\\$id";
	    }
	} else {
	    warn "ignoring $_";
	}
    }
    $regex .= "\$";
    print "$_ => $regex\n";
    seek WORDS, 0, 0;
    while (<WORDS>) {
	next unless /$regex/i;
	print;
    }
}
