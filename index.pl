use strict;
use warnings;

use lib 'lib';

use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use XML::FeedPP;

use FictionalSpork::Summary;

my @file;

my %metadata;

my $siteurl = 'https://argrath.ub32.org/annex/';

my $fnpat = 'output/%Y/%m/%d-%H.html';
{
    %metadata = %{&FictionalSpork::Summary::find_entry()};

    my (@list) = FictionalSpork::Summary::extract('%Y/%m/%d-%H.html', \&filter);
    output(\@list);
    atom(@list);
    exit;
}

sub filter {
    my ($meta, $args) = @_;

    if($meta->{status} ne 'publish'){return 0;}
    return 1;
}

sub output {
    my ($list) = @_;
    my %vars;

    $vars{title} = 'Index';
    $vars{csslink} = 'st.css';
    $vars{itemlist} = $list;

    my $outfn = 'output/index.html';
    my $tt = new Template;
    $tt->process('tmpl/summary.tt.html', \%vars, $outfn);
}

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
	my $d = $_->{date};
	$d =~ s/ /T/;
	$d .= '+09:00';

	$f->add_item(
	    title => $_->{title},
	    pubDate => $d,
	    link => $siteurl . $_->{link},
	    );
    }

    $f->to_file('output/atom.xml');
}
