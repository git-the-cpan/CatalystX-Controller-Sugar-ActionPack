#!perl

use warnings;
use lib qw(lib t/lib);
use Test::More;
use Catalyst::Test 'CataTest';
use CatalystX::Controller::Sugar::ActionPack::Default;
use CatalystX::Controller::Sugar::ActionPack::Error;

plan tests => 5;

CatalystX::Controller::Sugar::ActionPack::Error->inject(
    'CataTest::Controller::Root'
);
CatalystX::Controller::Sugar::ActionPack::Default->inject(
    'CataTest::Controller::Root'
);

is(request('/')->content, 'default.tt', '/');
is(request('/foo')->content, 'foo.tt', '/foo');
is(request('/foo/bar')->content, 'foo/bar.tt', '/foo/bar');
like(request('/robots.txt')->content, qr{/robots.txt$}, '/robots.txt');
is(request('/errrr')->content, 'error/not_found.tt', '/errrr');
