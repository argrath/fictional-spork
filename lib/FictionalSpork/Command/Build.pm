package FictionalSpork::Command::Build;

use strict;
use warnings;

use lib 'lib';

use YAML::Tiny;

use Data::Dumper;

use Template;
use Time::Piece;

use FictionalSpork::Mods;
use FictionalSpork::Entry;
use FictionalSpork::Tag;
use FictionalSpork::Tags;
use FictionalSpork::Markdown;
use FictionalSpork::Conf;

sub build {
    my $fn = shift;

    my $conf = FictionalSpork::Conf::get();

    print "Processing: $fn\n";

    my $entry = FictionalSpork::Entry->new($fn);
    if(!defined $entry){
        print "Not found: $fn\n";
        return;
    }
    my (@file) = @{$entry->file};

    my $meta = $entry->meta;

    if($meta->{status} ne 'publish'){
        print "Skip.\n";
        return;
    }

    my %vars;

    $file[2] =~ s/\n([ \t]*)```([a-z]*)\n/\n$1```\n/g;
    my $html1 = FictionalSpork::Markdown::make_markdown($file[1]);

    $vars{text} = $html1;

#    $file[2] =~ s{\n```([a-z]*)\n(.+?)\n```\n}{<pre><code>$2</code></pre>}sg;
#    $file[2] =~ s/\n([ \t]*)```([a-z]*)\n/\n$1```\n/g;
    my $html2 = FictionalSpork::Markdown::make_markdown($file[2]);

    $vars{textmore} = $html2;

    $vars{blogtitle} = $conf->{title};
    $vars{title} = $meta->{title};
    $vars{w3cdate} = $meta->{w3cdate};

    {
        my $tags = FictionalSpork::Tags->new($meta->{tags});
        $vars{tags} = $tags->to_string;
    }

    my $outfn;
    {
	my $date = $meta->{date};
	$vars{date} = $date;

        my $fnpat = $conf->{entrypattern};
	$outfn = FictionalSpork::Mods::entry_url($date, $fnpat);
    }

    my $tt = new Template;
    $tt->process('tmpl/entry.tt.html', \%vars, $outfn, 'binmode' => ':utf8');
}

1;
