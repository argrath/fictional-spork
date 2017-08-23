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
#    my $tags = $ARGV[0];

    %metadata = %{&FictionalSpork::Summary::find_entry()};

    my (@taglist) = listup(\%metadata);

    for(@taglist){
	my $tags = $_;
	my (@list) = FictionalSpork::Summary::extract('../%Y/%m/%d-%H.html', \&filter, $tags);
	output($tags, \@list);
    }

    output_index(\@taglist);
    exit;
}

sub listup {
    my ($meta) = @_;
    my %list;

    for(values %$meta){
	for(split / +/, $_->{tags}){
	    $list{lc($_)}++;
	}
    }

    return sort keys %list;
}

sub filter {
    my ($meta, $args) = @_;
    my (@tags) = split / +/, $meta->{tags};

    my @filtered = grep {lc($_) eq $args} @tags;
    if($#filtered < 0){return 0;}
    if($meta->{status} ne 'publish'){return 0;}
    return 1;
}

sub output {
    my ($tags, $list) = @_;
    my %vars;

    $vars{title} = 'Tag "' . $tags . '"';
    $vars{csslink} = '../st.css';
    $vars{itemlist} = $list;

    my $outfn = sprintf('output/tags/%s.html', $tags);
    my $tt = new Template;
    $tt->process('tmpl/summary.tt.html', \%vars, $outfn);
}

sub output_index {
    my ($taglist) = @_;
    my %vars;
    my @list;

    for(@$taglist){
	push @list, {
	    title => $_,
	    link => $_ . '.html'
	  };
    }

    print Dumper($taglist);
    print Dumper(\@list);

    $vars{title} = 'Tag';
    $vars{csslink} = '../st.css';
    $vars{itemlist} = \@list;

    my $outfn = 'output/tags/index.html';
    my $tt = new Template;
    $tt->process('tmpl/list.tt.html', \%vars, $outfn);
}
