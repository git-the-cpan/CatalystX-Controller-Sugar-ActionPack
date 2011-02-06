package CatalystX::Controller::Sugar::ActionPack::Default;

=head1 NAME

CatalystX::Controller::Sugar::ActionPack::Default

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

my %cache;

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
    my $path = join('/',
                   grep { defined and length }
                   controller->action_namespace, @_
               );
    my $static;

    # template
    if(my $template = _find_template($path)) {
        stash template => $template;
        report debug => 'template=%s', $template if c->debug;
        return;
    }

    # static files
    $static = (controller->{'serve_static'} ||= []);
    $static = [$static] unless(ref $static eq 'ARRAY');

    if(grep { $path eq $_ } @$static) {
        c->serve_static_file( c->path_to('root', $path) );
        c->detach;
        return; # c->detach will prevent this method from returning
    }

    # if everything fail...
    go '/error' => ['not_found'];
};

sub _find_template {
    my $path = shift;
    my @search_paths = (c->path_to('root'), c->path_to('root', 'base'));

    # get from cache
    if(my $template = $cache{$path}) {
        if(-e $template->[0]) {
            return $template->[1];
        }
        else {
            delete $cache{$path};
        }
    }

    if(my $addtional = c->stash->{'additional_template_paths'}) {
        unshift @search_paths, @$addtional;
    }

    # find from disc
    for my $base (@search_paths) {
        if(-e "$base/$path/default.tt") {
            $cache{$path} = [ "$base/$path/default.tt", $path ? "$path/default.tt" : "default.tt" ];
            return $cache{$path}->[1];
        }
        elsif(-e "$base/$path.tt") {
            $cache{$path} = [ "$base/$path.tt", "$path.tt" ];
            return $cache{$path}->[1];
        }
    }

    return;
}

=head1 LICENSE

=head1 AUTHOR

See L<CatalystX::Controller::Sugar::ActionPack>.

=cut

1;
