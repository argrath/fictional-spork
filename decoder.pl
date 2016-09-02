use strict;
use warnings;

use XML::TreePP;

use Data::Dumper;

my %title;
my %category;
my %tag;
my %entry;

{
    my $treepp = XML::TreePP->new();
    my $hash = $treepp->parsefile( "Movable_Type-conv.xml" );
    for(@{$hash->{movabletype}->{entry}}){
	my $e = $_;
	my $id = $e->{'-id'};
	printf "%d: %s\n", $id, $e->{'-title'};
	$title{$id} = $e->{'-title'};

	$e->{tags} = [];
	$entry{$id} = $e;
#	print Dumper($_);
    }
    print "----\n";
    for(@{$hash->{movabletype}->{category}}){
	printf "%d: %s %s\n", $_->{'-id'}, $_->{'-basename'}, $_->{'-label'};
	$category{$_->{'-id'}} = $_->{'-label'};
#	print Dumper($_);
    }
    print "----\n";
    for(@{$hash->{movabletype}->{tag}}){
	printf "%d: %s\n", $_->{'-id'}, $_->{'-name'};
	$tag{$_->{'-id'}} = $_->{'-name'};
#	print Dumper($_);
    }
    print "----\n";
    for(@{$hash->{movabletype}->{objecttag}}){
	my $id = $_->{'-object_id'};
	printf "%s\n%s\n--\n", $title{$_->{'-object_id'}}, $tag{$_->{'-tag_id'}};
	push @{$entry{$id}->{tags}}, $tag{$_->{'-tag_id'}};
#	print Dumper($_);
    }
    print "----\n";
    for(@{$hash->{movabletype}->{placement}}){
	my $id = $_->{'-entry_id'};
	printf "%s\n%s\n--\n", $title{$_->{'-entry_id'}}, $category{$_->{'-category_id'}};
	push @{$entry{$id}->{tags}}, $category{$_->{'-category_id'}};
#	print Dumper($_);
    }
    print "----\n";
    for(@{$hash->{movabletype}->{fileinfo}}){
	if($_->{-archive_type} eq 'Individual'){
	    my $id = $_->{'-entry_id'};
	    printf "%s\n%s\n--\n", $title{$_->{'-entry_id'}}, $_->{'-url'};
	    $entry{$id}->{url} = $_->{'-url'};
#	print Dumper($_);
	}
    }

    print "----\n";
    for(keys %entry){
	my $e = $entry{$_};
	my(@date) = ($e->{-authored_on} =~ /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/);
	my $folder = 'entry/' . $date[0];
	mkdir $folder;
	my $fn = sprintf '%s/%s%s%s.txt' , $folder, $date[1], $date[2], $date[3];
	{
	    open my $f, '>', $fn or die;
	    printf $f "title: %s\n", $e->{-title};
	    printf $f "tags: %s\n", join(' ', @{$e->{tags}});
	    {
		my $date = sprintf '%s-%s-%s %s:%s:%s', splice(@date, 0, 6);
		printf $f "date: %s\n", $date;
	    }
	    {
		my $style = $e->{-convert_breaks};
		if($style eq '__default__'){
		    $style = 'html';
		}
		printf $f "style: %s\n", $style;
	    }
	    printf $f "status: %s\n", ($e->{-status} == 1 ? 'draft' : 'publish');
	    print $f "---\n";
	    if(defined $e->{text}){
		print $f $e->{text};
		if(defined $e->{text_more}){
		    print $f "\n---\n";
		    print $f $e->{text_more};
		}
	    }
	    close $f;
	}
    }


}
