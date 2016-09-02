use strict;
use warnings;

use YAML::Tiny;
use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;

my @file;
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
	my $date = $yaml->[0]->{date};
	$vars{date} = $date;
	substr($date, 10, 1) = 'T';
	$date .= '+0900';
	$vars{w3cdate} = $date;
    }

    my $tt = new Template;
    $tt->process('tmpl/entry.tt.html', \%vars);

}
