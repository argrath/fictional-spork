use strict;
use warnings;

use YAML::Tiny;
use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use File::Find;

my @file;

my $fnpat = 'output/%Y/%m/%d-%H.html';
{
#    binmode(STDOUT, ':encoding(Shift_JIS)');
    find({
	wanted => \&findsub,
	no_chdir => 1}, 'entry');
    exit;
}
sub findsub {
    my $path = $File::Find::name;
    if($path !~ /\.txt$/){return;}
    print $path . "\n";
    my (@file) = load_file($path);
    print $file[0] . "\n";
    my $conf = read_meta($file[0]);
    print $conf->{title} . "\n";
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

sub read_meta {
    my %ret;
    for(@_){
	if(/([a-z]+): *(.+)/){
	    $ret{$1} = $2;
	}
    }
    return \%ret;
}

{
    {
	open my $f, '<', $ARGV[0];
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
    }
    my $yaml = YAML::Tiny->read_string($file[0]);
    my %vars;

    my $html1 = markdown($file[1]);

    $vars{text} = $html1;

    my $html2 = markdown($file[2]);

    $vars{textmore} = $html2;

    $vars{title} = $yaml->[0]->{title};
    {
	my (@tags) = split / /, $yaml->[0]->{tags};
	my @tagstr = ();
	for(@tags){
	    my $tag = lc($_);
	    push @tagstr, sprintf('<a href="../../%s">%s</a>', $tag, $tag);
	}
	$vars{tags} = join(', ', @tagstr);
    }
    my $outfn;
    {
	my $date = $yaml->[0]->{date};
	my $dateobj = Time::Piece->strptime($date, '%Y-%m-%d %H:%M:%S');
	$vars{date} = $date;
	substr($date, 10, 1) = 'T';
	$date .= '+0900';
	$vars{w3cdate} = $date;
	$outfn = $dateobj->strftime($fnpat);
    }

    my $tt = new Template;
    $tt->process('tmpl/entry.tt.html', \%vars, $outfn);
}
