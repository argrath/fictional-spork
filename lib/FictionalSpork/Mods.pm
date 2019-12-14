package FictionalSpork::Mods;

sub load_file {
    my (@file);
    my ($fn) = @_;
    open my $f, '<', $fn or die "$!: $fn";
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
    return @file;
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

sub entry_url {
    my ($date, $linkpat) = @_;

    my $dateobj = Time::Piece->strptime($date, '%Y-%m-%d %H:%M:%S');
    return $dateobj->strftime($linkpat);
}

1;
