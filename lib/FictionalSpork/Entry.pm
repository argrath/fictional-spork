package FictionalSpork::Entry;

use warnings;
use strict;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    $self->{id} = shift;

    my $file = load_file($self->{id}) or return undef;
    $self->{file} = $file;

    my $meta = read_meta($$file[0]);
    $self->{meta} = $meta;

    return $self;
}

sub file {
    my $self = shift;
    return $self->{file};
}

sub meta {
    my $self = shift;
    return $self->{meta};
}

sub _fn {
    my $name = shift;
    my ($y, $m, $d, $h) = unpack('A4A2A2A2', $name);

    return sprintf('entry/%s/%s%s%s.txt', $y, $m, $d, $h);
}

sub load_file {
    my (@file);
    my ($fn) = @_;

    if($fn !~ /txt$/){
	$fn = _fn($fn);
    }
    open my $f, '<', $fn or return undef;
    my $s = '';
    while(<$f>){
	if(/---\n/){
	    push @file, $s;
	    $s = '';
	    next;
	}
	$s .= $_;
    }
    push @file, $s;
    return \@file;
}

sub read_meta {
    my $data = shift;
    my %ret;
    for(split /\n/, $data){
	if(/([a-z]+): *(.+)/){
	    $ret{$1} = $2;
	}
    }
    return \%ret;
}

1;
