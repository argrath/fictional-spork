use strict;
use warnings;

use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Command::TagList') };

use FindBin;
chdir $FindBin::Bin;