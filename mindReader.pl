#!/usr/bin/env perl

# http://www.smbc-comics.com/?id=2123#comic

use strict;
use warnings;

print "This program can read minds!\n";

print "Would you like to know what you are thinking? (y/n): ";
my $answer = <>;
chomp $answer;

if ($answer eq 'y') {
print "Hold on... reading your brain!\n";
sleep 5;
print "You're thinking: 'This is bullshit!'\n";
} elsif ($answer eq 'n') {
print "Yeah, I did a preliminary scan and I don't want to go there either.\n";
} else {
print "Now I'm just thinking you're stupid.\n";
}

print "\nThanks for playing!\n";
