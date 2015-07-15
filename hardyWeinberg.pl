#!/usr/bin/env perl

use strict;
use warnings;

my $inds = 5;
my @list;
my %genotype;
my ($PP,$Pp,$pp)=(0,0,0);

#for (1..5) {@list = (@list,int(rand(9)))};

for my $x (1..$inds) {
  my $rand = int(rand(15));
  if ($rand < 4) {
    $genotype{$x} = 'PP';
    $PP++;
  } elsif ($rand < 8) {
    $genotype{$x} = 'Pp';
    $Pp++;
  } elsif ($rand < 11) {
    $genotype{$x} = 'pP';
    $Pp++;
  } else {
    $genotype{$x} = 'pp';
    $pp++;
  }

}

print "$genotype{1}\t$genotype{2}\n";

my @first = split //, $genotype{1};
unshift @first, $first[0];
push @first, $first[2];
#print @first;
my @second = split //, $genotype{2};
unshift @second, $second[1];
push @second, $second[1];
my %genTwo;
for my $x (0..3) {
  $genTwo{$x} = $first[$x].$second[$x];
}
#print %genTwo;

########################################################
# Punnett
########################################################
# Mutation
########################################################

my @sort = sort keys %genTwo;
foreach my $key (@sort) {
  print "$key\t$genTwo{$key}\n";
}
#print "$PP\t$Pp\t$pp\n";

my @seq = 1..1000;
my @newSeq;

foreach my $tide (@seq) {
  my $mut = int(rand(100))+1;
  @newSeq = (@newSeq,$tide) if $mut < 86;
  @newSeq = (@newSeq,"0") if $mut > 85;
}
my $count = 0;
for my $x (1..@newSeq) {
  $count++ if $newSeq[$x-1] == 0;
  print "\t$count\t" if $newSeq[$x-1]==0;
  print "$newSeq[$x-1]\n";
}
