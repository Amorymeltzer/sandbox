#!/usr/bin/env perl

use strict;
use warnings;

open (my $file, '<', "foo.txt");

undef $/;


print <$file>;
