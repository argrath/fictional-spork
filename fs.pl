use strict;
use warnings;

use lib 'lib';

use FictionalSpork::Command::Build;

{
    my @fn = glob($ARGV[0]);
    for(@fn){
        FictionalSpork::Command::Build::build($_);
    }
}
