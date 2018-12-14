use strict;
use warnings;

use lib 'lib';

use FictionalSpork::Command::Create;

{
    FictionalSpork::Command::Create::create($ARGV[0]);
}
