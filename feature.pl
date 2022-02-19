#!/usr/bin/env perl

use strict;
use warnings;

# use 5.010;
use feature qw(say);
CORE::say 'Purple';

# use 5.010; # Really 5.016 or 5.018 for proper working
use feature 'switch';
# No flag for turning off given/when warnings??  Lame.
given (-1) {
  say 'one' when 1;
  say 'two' when 2;
  say 'three' when $_ >= 3;
  default {say 'defaultt'}
}

# use 5.016;
# use feature 'fc';
say CORE::fc 'aDddDAdSDjkA sdkja KAD';

# use 5.020;
use feature 'signatures';
no warnings 'experimental::signatures';

say addMe(3,4);

sub addMe ($left, $right) {
    return $left + $right;
}
