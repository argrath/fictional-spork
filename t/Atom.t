use strict;
use warnings;

use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Atom') };

use FindBin;
chdir $FindBin::Bin;

use FictionalSpork::Conf;

{
    FictionalSpork::Conf::_set({atomfile => 'atom.xml'});
    FictionalSpork::Atom::atom();
}
