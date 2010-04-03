package CatalystX::Controller::Sugar::ActionPack::Default;

=head1 NAME

CatalystX::Controller::Sugar::ActionPack::Default - Action for /*

=head1 DESCRIPTION

This module acts as a default handler for a controller. It will either
server a file by its best knowledge or do C<go('/error', ["not_found"])>.

=head1 DEPENDENCIES

L<CatalystX::Controller::Sugar::ActionPack::Error> or an C</error> action.

=head1 SAMPLE CONFIG FILE

 <Controller::Foo>
   serve_static robots.txt
   serve_static foo/bar.png
 </Controller::Foo>

The example above requires this module to be injected into the Root
controller.

It will allow the default action to serve files relative to the C<root/>
folder. "robots.txt" will therefor be translated to:

 /path/to/my-project/root/robots.txt

=cut

use CatalystX::Controller::Sugar::Plugin;

=head1 ACTIONS

=head2 Endpoint /*

 go '/', [@path];

Will serve a static file by these rules:

 1) Exists root/@path.tt
 2) Exists root/@path/default.tt
 3) Is the requested file defined in config file

Will C<go()> to C</error> unless the rules match the request.

=cut

chain '' => sub {
    my $path = join '/', grep { /^\w/ } controller->{'namespace'}, @_;
    my $base = c->config->{'root'};
    my $static;

    if(-e "$base/$path.tt") {
        stash template => "$path.tt";
        return;
    }
    if(-e "$base/$path/default.tt") {
        stash template => $path ? "$path/default.tt" : "default.tt";
        return;
    }

    $static = controller->{'serve_static'} || [];
    $static = [$static] unless(ref $static eq 'ARRAY');

    if(grep { $path eq $_ } @$static) {
        c->serve_static_file( c->path_to('root', $path) );
        c->detach;
        return; # c->detach will prevent this method from returning
    }

    # if everything else fail...
    go '/error' => ['not_found'];
};

=head1 LICENSE

=head1 AUTHOR

See L<CatalystX::Controller::Sugar::ActionPack>.

=cut

1;
