package CataTest::Controller::Root;

use Data::Dumper;
use CatalystX::Controller::Sugar;

__PACKAGE__->config(
    namespace => q(),
    serve_static => 'robots.txt',
);

chain sub {
};

private end => sub {
    res->body( stash('template') ) unless(res->body);
};
