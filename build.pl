use strict;
use warnings;

use lib 'lib';

use YAML::Tiny;
use Text::MultiMarkdown 'markdown';

use Data::Dumper;

use Template;
use Time::Piece;

use FictionalSpork::Mods;
use FictionalSpork::Entry;
use FictionalSpork::Tag;

{
    my $entry = FictionalSpork::Entry->new($ARGV[0]);
    my (@file) = @{$entry->file};

    my $meta = $entry->meta;

    my %vars;

    $file[2] =~ s/\n([ \t]*)```([a-z]*)\n/\n$1```\n/g;
    my $html1 = make_markdown($file[1]);

    $vars{text} = $html1;

#    $file[2] =~ s{\n```([a-z]*)\n(.+?)\n```\n}{<pre><code>$2</code></pre>}sg;
#    $file[2] =~ s/\n([ \t]*)```([a-z]*)\n/\n$1```\n/g;
    my $html2 = make_markdown($file[2]);

    $vars{textmore} = $html2;

    $vars{title} = $meta->{title};
    {
	my (@tags) = split / /, $meta->{tags};
	my @tagstr = ();
	for(@tags){
	    my $tag = FictionalSpork::Tag->new($_);
	    push @tagstr, $tag->url;
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

sub make_markdown {
    my $md = shift;

    $md =~ s{
	\n([ \t]*)```([a-z]*)\n
	(.*?)
	\n([ \t]*)```\n
      }{
	my $indent = $1;
	my $codeblock = "\n" . $3;
	my $result;
	$codeblock =~ s/\n/\n$indent\t/g;
	$result = $codeblock .  "\n";
	$result;
    }egsx;

    my $html = markdown($md);

    return $html;
}
