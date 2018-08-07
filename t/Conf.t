use strict;
use warnings;
use utf8;

use Data::Dumper;

#use Test::More tests => 1;
use Test::More qw(no_plan);
use FindBin;

chdir $FindBin::Bin;

BEGIN { use_ok('FictionalSpork::Conf') };

{
    $ENV{'FS_CONF'} = 'fs.test.yml';
    my $conf = FictionalSpork::Conf::load();
    is($conf->{title}, 'テストタイトル', 'load yml');
}

{
    $ENV{'FS_CONF'} = 'fs.nosuch.yml';
    eval {
        my $conf = FictionalSpork::Conf::load();
    };
    isnt($@, '', 'yml not found');
}
