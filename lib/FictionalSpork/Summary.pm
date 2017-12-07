package FictionalSpork::Summary;
use strict;
use warnings;

use File::Find;

use FictionalSpork::Mods;
use FictionalSpork::Entry;

my %metadata;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    return $self;
}

sub find_entry {
    find({
	wanted => \&_findsub,
	no_chdir => 1}, 'entry');
    return \%metadata;
}

sub _findsub {
    my $path = $File::Find::name;
    if($path !~ /\.txt$/){return;}
    my $entry = FictionalSpork::Entry->new($path);
    my $meta = $entry->meta;
    $metadata{$meta->{date}} = $meta;
}

sub extract {
    my ($linkpat, $filter, $args) = @_;
    my @ret;

    for(reverse sort keys %metadata){
	my $meta = $metadata{$_};
	if(!&$filter($meta, $args)){next;}
	my $url = FictionalSpork::Mods::entry_url($meta->{date}, $linkpat);
	push @ret, {
	    date => $meta->{date},
	    link => $url,
	    title => $meta->{title},
	    w3cdate => $meta->{w3cdate},
	};
    }

    return @ret;
}

1;
