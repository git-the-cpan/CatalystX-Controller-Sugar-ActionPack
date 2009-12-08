package CataTest;

use Moose;
use CatalystX::Controller::Sugar::ActionPack::Error qw/ finalize_error /;

extends 'Catalyst';

# just to pass tests
sub serve_static_file {
    shift->res->body(shift);
}

__PACKAGE__->config(
    name => 'CataTest',
    home => './t',
    root => './t/root',
    'Controller::Root' => {
        merge => {
            js => {
                content_type => 'text/javascript',
                success => [ qw/one.js two.js/ ],
                not_found => undef,
            },
            css => {
                bad_request => [],
            },
        },
    },
);
__PACKAGE__->setup;

1;
