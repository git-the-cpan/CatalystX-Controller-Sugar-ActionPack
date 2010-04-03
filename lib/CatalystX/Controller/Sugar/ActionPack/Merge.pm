package CatalystX::Controller::Sugar::ActionPack::Merge;

=head1 NAME

CatalystX::Controller::Sugar::ActionPack::Merge - Merge static files

=head1 DESCRIPTION

Provides an action which can serve multiple files in one request. The reason
for this is easier maintenance of css and js files, while having less request
to the web server.

=head1 SAMPLE CONFIG FILE

 <Controller::Root>
   <merge> # <-- "js" from "/merge/foo.js"
     <js>
       content_type text/javascript
       foo file1.js # <-- "foo" from "/merge/foo.js"
       foo file2.js # <--/ /
       foo file3.js # <---/
     </js>
   </merge>
 </Controller::Root>

The example above requires this module to be injected into the Root
controller.

=cut

use CatalystX::Controller::Sugar::Plugin;
use File::Slurp qw/ read_file /;

=head1 ACTIONS

=head2 Endpoint /merge/*

 go '/merge', [$virtual_file];

Will merge files from the static directory, based on requested path.

Example: Will serve "file1.js", "file2.js" and "file3.js", if
C<$virtual_file> is "foo.js", based on the config from
L</SAMPLE CONFIG FILE>.

=cut

chain '/' => 'merge' => sub {
    my $key = shift || '';
    my $config = controller->{'merge'} || controller;
    my $section;

    if($key =~ s/\.(\w{2,4})$//) {
        $section = $1;
    }
    else {
        go '/error' => ['not_found', 'Nothing to merge'];
    }

    my $base = c->path_to('root', 'static', $section);
    my $files = $config->{$section}{$key};
    my $content_type = $config->{$section}{'content_type'};
    my $modified = time;
    my $body = '';

    unless($content_type) {
        go '/error' => ['bad_request', 'Content type missing'];
    }
    unless($files) {
        go '/error' => ['not_found', 'Files not found'];
    }

    $files = [$files] unless(ref $files eq 'ARRAY');

    FILE:
    for my $file (grep { not m,/, } @$files) {
        my @stat = stat "$base/$file";

        eval {
            $body .= read_file("$base/$file");
        } or do {
            report error => 'Could not merge %s: %s', $file, $@;
            next FILE;
        };

        $modified = $stat[9] if($modified < $stat[9]);
    }

    res->headers->content_type($content_type);
    res->headers->last_modified($modified);
    res->headers->content_length(length $body);
    res->body($body);
};

=head1 LICENSE

=head1 AUTHOR

See L<CatalystX::Controller::Sugar::ActionPack>.

=cut

1;
