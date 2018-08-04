package FictionalSpork::Atom;

use strict;
use warnings;

use FictionalSpork::Conf;

use XML::FeedPP;

my $siteurl = 'https://argrath.ub32.org/annex/';

sub atom {
    my (@list) = @_;

    my $conf = FictionalSpork::Conf::get();

    my $f = XML::FeedPP::Atom::Atom10->new(
        title => $conf->{title},
        description => $conf->{description},
        pubDate => time(),
        link => $siteurl,
        copyright => $conf->{copyright},
        lang => 'ja',
        );

    for(@list){
        $f->add_item(
            title => $_->{title},
            pubDate => $_->{w3cdate},
            link => $siteurl . $_->{link},
            );
    }

    $f->to_file('output/atom.xml');
}

1;
