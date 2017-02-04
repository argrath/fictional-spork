use strict;
use warnings;

use lib 'lib';

use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use FictionalSpork::Summary;

my @file;

my %metadata;

my $fnpat = 'output/%Y/%m/%d-%H.html';
{
    my $year = $ARGV[0];

    %metadata = %{&FictionalSpork::Summary::find_entry()};

    my (@list) = FictionalSpork::Summary::extract('%m/%d-%H.html', \&filter, $year);
    output($year, \@list);
    exit;
}

sub filter {
    my ($meta, $args) = @_;

    if($meta->{date} !~ /^$args/){return 0;}
    if($meta->{status} ne 'publish'){return 0;}
    return 1;
}

sub output {
    my ($year, $list) = @_;
    my %vars;

    $vars{title} = 'Year ' . $year;
    $vars{csslink} = '../st.css';
    $vars{itemlist} = $list;

    my $outfn = sprintf('output/%s/index.html', $year);
    my $tt = new Template;
    $tt->process('tmpl/summary.tt.html', \%vars, $outfn);
}
