#!perl

use warnings;
use lib qw(lib t/lib);
use Catalyst::Test 'CataTest';
use Test::More;
use CatalystX::Controller::Sugar::ActionPack::Error;
use CatalystX::Controller::Sugar::ActionPack::Merge;

plan tests => 6;

CatalystX::Controller::Sugar::ActionPack::Error->inject(
    'CataTest::Controller::Root'
);
CatalystX::Controller::Sugar::ActionPack::Merge->inject(
    'CataTest::Controller::Root'
);

my $r;

$r = request('/merge');
is($r->content, 'error/not_found.tt', 'not found');

$r = request('/merge/bad_request.css');
is($r->content, 'error/bad_request.tt', 'bad request: no content type');

$r = request('/merge/not_found.js');
is($r->content, 'error/not_found.tt', 'not found: no files');

$r = request('/merge/success.js');
like($r->content, qr{var one.*?var two}s, 'success content');
is($r->code, 200, 'success code');
is($r->content_type, 'text/javascript', 'success content type');

sub test_plugin {
    eval q/
        package TestPlugin;
        use CatalystX::Controller::Sugar::Plugin;
        chain '' => sub { die "foo" };
        1;
    / or die $@;

    return 'TestPlugin';
}
