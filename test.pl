#!/usr/bin/env perl

use strict;
use warnings;

print "$_\n" for sort {$a<=>$b} keys %{{2..13}};
