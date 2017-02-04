package Summary;
use strict;
use warnings;

use File::Find;

use Mods;

my %metadata;

sub find_entry {
    find({
	wanted => \&findsub,
	no_chdir => 1}, 'entry');
    return \%metadata;
}

sub findsub {
    my $path = $File::Find::name;
    if($path !~ /\.txt$/){return;}
    my (@file) = Mods::load_file($path);
    my $meta = Mods::read_meta($file[0]);
    $metadata{$meta->{date}} = $meta;
}

sub extract {
    my ($linkpat, $filter, $args) = @_;
    my @ret;

    for(reverse sort keys %metadata){
	my $meta = $metadata{$_};
	if(!&$filter($meta, $args)){next;}
	my $url = Mods::entry_url($meta->{date}, $linkpat);
	push @ret, {
	    date => $meta->{date},
	    link => $url,
	    title => $meta->{title},
	};
    }

    return @ret;
}

1;
