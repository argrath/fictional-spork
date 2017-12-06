# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl FictionalSpork.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

#use Test::More tests => 1;
use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Entry') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use FindBin;
chdir $FindBin::Bin;

{
    my $entry = FictionalSpork::Entry->new('2001010304');
    is($entry, undef, 'load non-existent');
}

{
    my $entry = FictionalSpork::Entry->new('2017010704');
    isnt($entry, undef, 'load entry');

    $entry = FictionalSpork::Entry->new('entry/2017/010704.txt');
    isnt($entry, undef, 'load entry with path');

    my $file = $entry->file;
    is($#$file, 2, 'entry count');
}
