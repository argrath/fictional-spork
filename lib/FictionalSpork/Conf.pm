package FictionalSpork::Conf;

use strict;
use warnings;

use YAML::Tiny;

my $conf;

sub load {
    my $fn = shift;
    if(!defined $fn){
        $fn = 'fs.yml';
    }
	my $data = YAML::Tiny->read($fn);
	$conf = $data->[0];
}

sub get {
    return $conf;
}

1;
