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
    my %default = (
        atomfile => 'output/atom.xml',
        entrypattern => 'output/%Y/%m/%d-%H.html',
        );
    my $fn = _conffn();
    my $data = YAML::Tiny->read($fn);
    my %c = (%default, %{$data->[0]});
    $conf = \%c;
}

sub get {
    if(!defined $conf){
        load();
    }
    return $conf;
}

1;
