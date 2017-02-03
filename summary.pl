use strict;
use warnings;

use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use File::Find;

use Mods;

my @file;

my %metadata;

my $fnpat = 'output/%Y/%m/%d-%H.html';
{
    my $year = $ARGV[0];

    find({
	wanted => \&findsub,
	no_chdir => 1}, 'entry');
    my (@list) = extract(\&filter, $year);
    output($year, \@list);
    exit;
}

sub findsub {
    my $path = $File::Find::name;
    if($path !~ /\.txt$/){return;}
    my (@file) = load_file($path);
    my $meta = Mods::read_meta($file[0]);
    $metadata{$meta->{date}} = $meta;
}

sub load_file {
    my (@file);
    my ($fn) = @_;
    open my $f, '<', $fn or die "$!: $fn";
    my $s = '';
    while(<$f>){
	if(/---\n/){
	    push @file, $s;
	    $s = '';
	    next;
	}
	$s .= $_;
    }
    push @file, $s;
    return @file;
}

sub filter {
    my ($meta, $args) = @_;

    if($meta->{date} !~ /^$args/){return 0;}
    if($meta->{status} ne 'publish'){return 0;}
    return 1;
}

sub extract {
    my ($filter, $args) = @_;
    my @ret;

    for(reverse sort keys %metadata){
	my $meta = $metadata{$_};
	if(!&$filter($meta, $args)){next;}
	my $url = entry_url($meta->{date});
	push @ret, {
	    date => $meta->{date},
	    link => $url,
	    title => $meta->{title},
	};
    }

    return @ret;
}

sub entry_url {
    my $linkpat = '%m/%d-%H.html';

    my $date = shift;
    my $dateobj = Time::Piece->strptime($date, '%Y-%m-%d %H:%M:%S');
    return $dateobj->strftime($linkpat);
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
