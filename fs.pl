use strict;
use warnings;

use lib 'lib';

use FictionalSpork::Command::Build;

{
    FictionalSpork::Command::Build::build($ARGV[0]);
}
