#!/usr/bin/env perl
# file by Amory Meltzer

use strict;
use warnings;
use English;

use 5.036;


# use Cwd;
# use File::Basename;
# use lib File::Basename::dirname( Cwd::realpath( __FILE__ ) );

use Cwd 'abs_path';
use File::Basename qw (dirname basename);

my $file = dirname __FILE__;
say "File:\t\t\t$file";

my $THISFILE;
$THISFILE = abs_path __FILE__;
say "abs_path __FILE__:\t\t$THISFILE";

my $name = basename(__FILE__);
say "basename(__FILE__):\t\t$name";

my $dirFile = dirname __FILE__;
say "dirname __FILE__:\t$dirFile";

my $THISDIR;
$THISDIR = dirname abs_path __FILE__;
say "dirname abs_path __FILE__:\t$THISDIR";

my $absdirFile = abs_path $dirFile;
say "abs_path dirname __FILE__:\t$absdirFile";

my $path = abs_path __FILE__;
my $dir = dirname $path;
say "dirname abs_path __FILE__:\t$dir";

use File::Spec ();
my $asd = File::Spec->catdir($dir);
say "File::Spec->catdir dir:\t\t$asd";

use FindBin qw($Bin);
say "FindBin:\t\t\t$Bin";
