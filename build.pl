use strict;
use warnings;

use lib 'lib';

use YAML::Tiny;
use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use FictionalSpork::Mods;

{
    my (@file) = FictionalSpork::Mods::load_file($ARGV[0]);

    my $meta = FictionalSpork::Mods::read_meta($file[0]);
    my %vars;

    my $html1 = markdown($file[1]);

    $vars{text} = $html1;

    my $html2 = markdown($file[2]);

    $vars{textmore} = $html2;

    $vars{title} = $meta->{title};
    {
	my (@tags) = split / /, $meta->{tags};
	my @tagstr = ();
	for(@tags){
	    my $tag = lc($_);
	    push @tagstr, sprintf('<a href="../../tags/%s.html">%s</a>', $tag, $tag);
	}
	$vars{tags} = join(', ', @tagstr);
    }
    my $outfn;
    {
	my $date = $meta->{date};
	$vars{date} = $date;

	my $fnpat = 'output/%Y/%m/%d-%H.html';
	$outfn = FictionalSpork::Mods::entry_url($date, $fnpat);

	substr($date, 10, 1) = 'T';
	$date .= '+0900';
	$vars{w3cdate} = $date;

    }

    my $tt = new Template;
    $tt->process('tmpl/entry.tt.html', \%vars, $outfn);
}
