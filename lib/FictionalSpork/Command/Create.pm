package FictionalSpork::Command::Create;

use strict;
use warnings;

use lib 'lib';

sub create {
    my $name = shift;

    my ($y, $m, $d, $h) = unpack('A4A2A2A2', $name);

    mkdir 'entry/' . $y;

    my $fn = sprintf('entry/%s/%s%s%s.txt', $y, $m, $d, $h);

    if(-e $fn){
        printf "$fn already exist.\n";
        return 1;
    }

    open my $f, '>', $fn or die;

    print $f <<"EOF"
title: ...
tags: ...
date: $y-$m-$d $h:00:00
style: markdown
status: draft
---
EOF
;
    close $f or die;
}

1;
