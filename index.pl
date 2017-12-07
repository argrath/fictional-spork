use strict;
use warnings;

use lib 'lib';

use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use FictionalSpork::Summary;
use FictionalSpork::Atom;

my @file;

my $fnpat = 'output/%Y/%m/%d-%H.html';
{
    my $summary = FictionalSpork::Summary->new();
    $summary->find_entry();

    my (@list) = FictionalSpork::Summary::extract('%Y/%m/%d-%H.html', \&filter);
    output(\@list);

    FictionalSpork::Atom::atom(@list);
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
