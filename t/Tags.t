use strict;
use warnings;

use Data::Dumper;

#use Test::More tests => 1;
use Test::More qw(no_plan);
BEGIN { use_ok('FictionalSpork::Tags') };

{
    my $entry = FictionalSpork::Tags->new('');
    print Dumper($entry) . "\n";
    is($#{$entry->{tags}}, -1, '0 number');
    is($entry->to_string, '', '0 url');
}

{
    my $entry = FictionalSpork::Tags->new('tag1');
    print Dumper($entry) . "\n";
    is($#{$entry->{tags}}, 0, '1 number');
    is($entry->to_string, '<a href="../../tags/tag1.html">tag1</a>', '1 url');
}

{
    my $entry = FictionalSpork::Tags->new('tag1 tag2');
    print Dumper($entry) . "\n";
    is($#{$entry->{tags}}, 1, '2 number');
    is($entry->to_string, '<a href="../../tags/tag1.html">tag1</a>, <a href="../../tags/tag2.html">tag2</a>', '2 url');
}
