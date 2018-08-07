package FictionalSpork::Conf;

use strict;
use warnings;

use YAML::Tiny;

my $conf;

sub load {
    my $fn = $ENV{'FS_CONF'};
    if(!defined $fn){
        $fn = 'fs.yml';
    }
    my $data = YAML::Tiny->read($fn);
    $conf = $data->[0];
}

sub get {
    if(!defined $conf){
        load();
    }
    return $conf;
}

1;
