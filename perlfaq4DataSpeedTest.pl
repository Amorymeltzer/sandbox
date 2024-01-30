#!/usr/bin/env perl
# perlfaq4DataSpeedTest by Amory Meltzer

# Just a dumb thing to compare some options from perlfaq4:
# <https://perldoc.perl.org/5.39.4/perlfaq4#How-can-I-remove-duplicate-elements-from-a-list-or-array?>

use 5.036;

use Benchmark qw(:all);

my @array = buildArray();

my $results = timethese(100000,
			{'map' => sub {
			   my %hash = map {$_ => 1} @array;
			 },
			 # or a hash slice:
			 'slice' => sub {my %slice; @slice{@array} = ();},
			 # or a foreach:
			 'foreach ' => sub {my %foreach; $foreach{$_} = 1 for @array;}
			}
		       );
cmpthese($results);


sub buildArray {
  my ($words, $length) = @_;
  $words  //= 100;
  $length //= 6;

  my %lookup;
  for my $num (65 .. 90) {
    $lookup{$num} = chr $num;
  }

  my @words;
  for (1 .. $words) {
    my $word;
    for (1 .. $length) {
      my $n = 65 + int rand 25;
      $word .= $lookup{$n};
    }
    push @words, $word;
  }
  return @words;
}
