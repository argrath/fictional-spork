package FictionalSpork::Markdown;
use strict;
use warnings;

use Text::MultiMarkdown 'markdown';

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

1;
