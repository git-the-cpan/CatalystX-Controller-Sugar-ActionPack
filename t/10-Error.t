#!perl

use warnings;
use lib qw(lib t/lib);
use Catalyst::Test 'CataTest';
use Test::More;
use CatalystX::Controller::Sugar::ActionPack::End;
use CatalystX::Controller::Sugar::ActionPack::Error;

plan tests => 8;

test_plugin()->inject('CataTest::Controller::Root');
CatalystX::Controller::Sugar::ActionPack::End->inject(
    'CataTest::Controller::Root'
);
CatalystX::Controller::Sugar::ActionPack::Error->inject(
    'CataTest::Controller::Root'
);

my $r;

$r = request('/error');
is($r->content, 'error/fallback.tt', 'fallback, without argument');
is($r->code, 500, 'fallback, without argument');

$r = request('/error/foo');
is($r->content, 'error/fallback.tt', 'fallback, without argument');
is($r->code, 500, 'fallback, without argument');

$r = request('/error/not_found');
is($r->content, 'error/not_found.tt', 'not found');
is($r->code, 404, 'not found');

$r = request('/');
is($r->content, 'error/internal.tt', 'catch internal error');
is($r->code, 500, 'catch internal error');

sub test_plugin {
    eval q/
        package TestPlugin;
        use CatalystX::Controller::Sugar::Plugin;
        chain '' => sub { die "foo" };
        1;
    / or die $@;

    return 'TestPlugin';
}
