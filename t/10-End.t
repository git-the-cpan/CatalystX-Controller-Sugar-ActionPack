#!perl
use warnings;
use lib qw(lib t/lib);
use Catalyst::Test 'CataTest';
use Test::More;
use CatalystX::Controller::Sugar::ActionPack::End;

plan tests => 6;

test_plugin()->inject('CataTest::Controller::Root');
CatalystX::Controller::Sugar::ActionPack::End->inject(
    'CataTest::Controller::Root'
);

is(request('/')->content,
    'text/html|charset=utf-8|index|__UNDEF__',
    '/'
);
is(request('/HEAD')->content,
    '',
    'req->method == HEAD'
);
like(request('/location')->content,
    qr{This item has moved},
    'redirect in action set'
);
is(request('/body/foo')->content,
    'foo',
    'body is set'
);
is(request('/title')->content,
    'text/html|charset=utf-8|hello world|__UNDEF__',
    'title is set'
);
is(request('/content-type')->content,
    'test|content-type|__UNDEF__',
    'content_type is set'
);

sub test_plugin {
    eval q/
        package TestPlugin;
        use CatalystX::Controller::Sugar::Plugin;

        chain '' => sub {
            my $do = shift || 'default';

            stash keys => [qw[ title current_view ]];

            if($do eq 'HEAD') {
                req->method('HEAD');
            }
            elsif($do eq 'location') {
                res->location('localhost');
            }
            elsif($do eq 'body') {
                res->body($_[0]);
            }
            elsif($do eq 'title') {
                stash title => 'hello world';
            }
            elsif($do eq 'content-type') {
                res->content_type('test');
            }
            elsif($do eq 'current-view') {
                stash current_view => 'MyView';
            }
        };

        1;
    / or die $@;

    return 'TestPlugin';
}
