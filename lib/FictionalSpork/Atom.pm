package FictionalSpork::Atom;

use strict;
use warnings;

use FictionalSpork::Conf;

use XML::FeedPP;

sub atom {
    my (@list) = @_;

    my $conf = FictionalSpork::Conf::get();

    my $f = XML::FeedPP::Atom::Atom10->new(
        title => $conf->{title},
        description => $conf->{description},
        pubDate => time(),
        link => $conf->{baseurl},
        copyright => $conf->{copyright},
        lang => 'ja',
        );

    for(@list){
        $f->add_item(
            title => $_->{title},
            pubDate => $_->{w3cdate},
            link => $conf->{baseurl} . $_->{link},
            );
    }

    $f->to_file($conf->{atomfile});
}

1;
