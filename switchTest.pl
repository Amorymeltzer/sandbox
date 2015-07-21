#!/usr/bin/env perl
# switchTest.pl by Amory Meltzer
# Test out this

use strict;
use warnings;
use diagnostics;

use feature qw(switch say);

# Pick our random number between 1 and 100
my $secret = int(rand 100)+1;

# An array of numbers guessed thus far
my @guessed;

say 'Guess my number between 1-100';

# Get each guess from the user
while (my $guess = <>) {
  chomp $guess;

  # Check their guess using given/when
  given($guess) {
    when (/\D/)         { say 'Give me an integer'; }
    when (@guessed)     { say 'You\'ve tried that';  }
    when ($secret)      { say 'Just right!';  last; }
    when ($_ < $secret) { say 'Too low';  continue; }
    when ($_ > $secret) { say 'Too high'; continue; }

    # record the guess they've made
    push @guessed, $_;
  }
}

my @cool_things = qw(pirate pirate foozball ninja robot pirate apple ninja pirate robot monkey);
my ($pirate,$ninja,$robot);
foreach (@cool_things) {
  when (/pirate/)  { $pirate++ }
  when (/ninja/)   { $ninja++  }
  when (/robot/)   { $robot++  }
  say "$_ doesn't look cool...";
}

print "Pirate: $pirate\tNinja: $ninja\tRobot: $robot\n";
