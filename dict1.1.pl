#!/usr/bin/env perl

use strict;
use warnings;
use LWP::Simple;
use XML::XPath;
use Data::Dumper;

use constant NOMRAL_DISPLAY => "\e[0;0m";
use constant UNDERLINE => "\e[0;4m";

use constant HOSTNAME => "http://services.aonaware.com";
use constant DICTIONARY => "gcide";
use constant STRATEGY => "lev";
use constant DEFINE_URL =>
    HOSTNAME . "/DictService/DictService.asmx/DefineInDict?dictId=" . DICTIONARY . "&word=";

my $rawXml = get(DEFINE_URL . $ARGV[0]);
my $xp = XML::XPath->new(xml => $rawXml);
my $data = $xp->find('//Definition/WordDefinition');
if ($data->size == 0) {
    print "No Matches for $ARGV[0]\n";
} else {
    my $count = 1;
    for my $def ($data->get_nodelist) {
	print UNDERLINE . "DEFINITION $count" . NOMRAL_DISPLAY . "\n";
	print $def->string_value . "\n";
	$count++;
    }
}

=head1 NAME

    Dictionary

    =head1 DESCRIPTION

    A command line dictionary that uses the aonaware.com dictionary webservice.

    =head1 README

    THIS SOFTWARE DOES NOT COME WITH ANY WARRANTY WHATSOEVER. USE AT YOUR OWN RISK.
    Please check out my blog at http://grepmonster.wordpress.com if you like this script.

    =head1 PREREQUISITES

    This script requires the LWP::Simple and XML::XPath modules

    =head1 COREQUISITES

    CGI

    =pod OSNAMES

    any

    =pod SCRIPT CATEGORIES

    CPAN/Administrative
    Educational

    =cut
