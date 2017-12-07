package FictionalSpork::Tag;

use warnings;
use strict;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    my $tag = shift;

    $self->{tag} = lc($tag);

    return $self;
}

sub url {
    my $self = shift;
    my $tag = $self->{tag};
    return sprintf('<a href="../../tags/%s.html">%s</a>', $tag, $tag);
}

1;
