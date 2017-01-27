use strict;
use warnings;

use YAML::Tiny;
use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

my @file;

my $fnpat = 'output/%Y/%m/%d-%H.html';
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
