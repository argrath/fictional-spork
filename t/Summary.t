use strict;
use warnings;

use Data::Dumper;

use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Summary') };

use FindBin;
chdir $FindBin::Bin;

{
    my $c = FictionalSpork::Summary->new();
    my $result = $c->find_entry();
    my @keys = keys(%$result);
    is($#keys, 0, 'entry count');
    is($keys[0], '2017-01-07 04:00:00', 'entry header');
}
