package FictionalSpork::Conf;

use strict;
use warnings;

use YAML::Tiny;

my $conf;

sub _conffn {
    my $fn = $ENV{'FS_CONF'};
    if(!defined $fn){
        $fn = 'fs.yml';
    }

    return $fn;
}

sub _set {
    $conf = shift;
}

sub load {
    my $fn = _conffn();
    my $data = YAML::Tiny->read($fn);
    my %c = %{$data->[0]};
    {
        if(!defined $c{atomfile}){
            $c{atomfile} = 'output/atom.xml';
        }
    }
    $conf = \%c;
}

sub get {
    if(!defined $conf){
        load();
    }
    return $conf;
}

1;
