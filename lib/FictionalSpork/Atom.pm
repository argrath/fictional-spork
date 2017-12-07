package FictionalSpork::Atom;

use strict;
use warnings;

use XML::FeedPP;

my $siteurl = 'https://argrath.ub32.org/annex/';

sub atom {
    my (@list) = @_;

    my $f = XML::FeedPP::Atom::Atom10->new(
	title => '王様の耳は驢馬の耳(別館)',
	description => 'よしなしごとをかきつくる',
	pubDate => time(),
	link => $siteurl,
	copyright => 'SHIRAKATA Kentaro',
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