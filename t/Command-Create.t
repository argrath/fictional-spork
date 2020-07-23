use strict;
use warnings;

use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Command::Create') };

use FindBin;
chdir $FindBin::Bin;

{
    my $ret = FictionalSpork::Command::Create::create('');
    is($ret, 1, 'illigal args');
}

{
    my $ret = FictionalSpork::Command::Create::create('2017010704');
    is($ret, 1, 'create duplication');
}

{
    my $ret = FictionalSpork::Command::Create::create('2017010101');
    unlink 'entry/2017/010101.txt';
    is($ret, 0, 'create');
}
