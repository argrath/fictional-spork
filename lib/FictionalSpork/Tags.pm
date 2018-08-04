package FictionalSpork::Tags;

use warnings;
use strict;

use FictionalSpork::Tag;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    my $tags = shift;
    {
	my (@tags) = split / /, $tags;
	my @tagobj = ();
	for(@tags){
	    my $tag = FictionalSpork::Tag->new($_);
	    push @tagobj, $tag;
	}
	$self->{tags} = \@tagobj;
    }

    return $self;
}

sub to_string {
    my $self = shift;
    my $tag = $self->{tags};

    my @tagstr = ();
    for(@{$self->{tags}}){
	push @tagstr, $_->url;
    }
    return join(', ', @tagstr);
}

1;
