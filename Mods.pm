package Mods;

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
