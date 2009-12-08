package CataTest::View::A;

use Moose;

extends 'Catalyst::View';

sub process {
    my $self = shift;
    my $c = shift;
    my $keys = $c->stash->{'keys'};
    my $title = $c->stash->{'title'} || q();

    if($title =~ /^error/) {
        $c->res->body( $c->stash->{'template'} );
    }
    else {
        $c->res->body(join("|",
            $c->res->content_type,
            map { $c->stash->{$_} || q(__UNDEF__) } @$keys
        ));
    }

    return 1;
}

1;
