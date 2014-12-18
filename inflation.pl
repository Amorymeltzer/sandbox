#!/usr/bin/env perl
# inflation.pl by Amory Meltzer
# Use CPI-U data to calculate inflation prices

use warnings;
use strict;
eval 'use diagnostics; 1' or warn 'diagnostics not found';

unless (@ARGV == 3 || @ARGV == 2) {
  print "Usage: inflation.pl <USD> <inYear1> <isWorthinYear2>\n";
  exit;
}

if ($ARGV[0] !~ m/^-?\d*\.?\d+$/x) {
  print "USD must be in dollar form\n";
  exit;
}

my $present;			# newest allowable
my $past;			# oldest allowable
my %yearAvg;			# holds year->CPI data

while (<DATA>) {
  chomp;

  my @tmp = split /,/;
  $yearAvg{$tmp[0]} = $tmp[1];

  # Newest allowable
  if ($. == 1) {
    $present = $tmp[0];
  }
  # Oldest allowable
  $past = $tmp[0];
}

my $oldDollar = $ARGV[0];
my $oldYear = $ARGV[1];
my $newYear;

# Validate inputs
checkYearValue($oldYear);
if (@ARGV == 3) {
  $newYear = $ARGV[2];
  checkYearValue($newYear);
}
else {
  $newYear = $present;
}

# Two decimal places
my $newDollar = sprintf '%.2f', $oldDollar*$yearAvg{$newYear}/$yearAvg{$oldYear};

print "\$$oldDollar in $oldYear was worth \$$newDollar in $newYear\n";


sub checkYearValue
  {
    my $year = shift;
    if ($year !~ m/^\d\d\d\d$/x) {
      print "Years must be in YYYY format\n";
    } elsif ($year > $present || $year < $past) {
      print "Years must be between $past and $present\n";
    } else {
      return;
    }
    exit;
  }


## The lines below are not Perl code, and are
## not examined by the compiler.  Rather, they
## are a list of CPI-U data read in as <DATA>.
__END__
2013,232.957
2012,229.594
2011,224.939
2010,218.056
2009,214.537
2008,215.303
2007,207.342
2006,201.6
2005,195.3
2004,188.9
2003,184
2002,179.9
2001,177.1
2000,172.2
1999,166.6
1998,163
1997,160.5
1996,156.9
1995,152.4
1994,148.2
1993,144.5
1992,140.3
1991,136.2
1990,130.7
1989,124
1988,118.3
1987,113.6
1986,109.6
1985,107.6
1984,103.9
1983,99.6
1982,96.5
1981,90.9
1980,82.4
1979,72.6
1978,65.2
1977,60.6
1976,56.9
1975,53.8
1974,49.3
1973,44.4
1972,41.8
1971,40.5
1970,38.8
1969,36.7
1968,34.8
1967,33.4
1966,32.4
1965,31.5
1964,31
1963,30.6
1962,30.2
1961,29.9
1960,29.6
1959,29.1
1958,28.9
1957,28.1
1956,27.2
1955,26.8
1954,26.9
1953,26.7
1952,26.5
1951,26
1950,24.1
1949,23.8
1948,24.1
1947,22.3
1946,19.5
1945,18
1944,17.6
1943,17.3
1942,16.3
1941,14.7
1940,14
1939,13.9
1938,14.1
1937,14.4
1936,13.9
1935,13.7
1934,13.4
1933,13
1932,13.7
1931,15.2
1930,16.7
1929,17.1
1928,17.1
1927,17.4
1926,17.7
1925,17.5
1924,17.1
1923,17.1
1922,16.8
1921,17.9
1920,20
1919,17.3
1918,15.1
1917,12.8
1916,10.9
1915,10.1
1914,10
