#!/usr/bin/env perl
# Test some inflation thangs

use strict;
use warnings;
use English qw(-no_match_vars); # Avoid regex speed penalty in perl <=5.16

use Test::More;
use Test::Script;

my $script = 'inflation.pl';
script_compiles($script);
script_runs($script, 'Usage-empty');
script_stdout_is "Usage: inflation.pl <USD> <inYear1> <isWorthinYear2>\n", 'std_out:Usage-empty';
script_runs([$script, 'a'], 'Usage-NaN');
script_stdout_is "Usage: inflation.pl <USD> <inYear1> <isWorthinYear2>\n", 'std_out:Usage-NaN';
script_runs([$script, '100', '17'], 'Err-year-format');
script_stdout_is "Years must be in YYYY format\n", 'std_out:Err-year-format';
script_runs([$script, '1000', '1912'], 'Err-year-range');
# Ugh
script_stdout_is "Years must be between 1914 and 2022, inclusive\n", 'std_out:Err-year-range';


script_runs([$script, '100', '2000'], '2000');
script_stdout_is '$100 in 2000 was worth $169.95 in 2022'."\n", 'std_out:2000';

script_runs([$script, '100', '2000', '2020'], '2000->2020');
script_stdout_is '$100 in 2000 was worth $150.30 in 2020'."\n", 'std_out:2000->2020';

done_testing();