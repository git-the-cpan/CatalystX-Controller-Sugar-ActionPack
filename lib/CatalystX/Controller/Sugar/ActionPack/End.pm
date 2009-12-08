package CatalystX::Controller::Sugar::ActionPack::End;

=head1 NAME

CatalystX::Controller::Sugar::ActionPack::End

=head1 DESCRIPTION

This plugin should be injected into the Root controller, or a controller
with namespace set to "" (empty string). It provides something similar to
L<Catalyst::Action::RenderView>.

=head1 DEPENDENCIES

L<CatalystX::Controller::Sugar::ActionPack::Error> or an C</error> action.

=cut

use CatalystX::Controller::Sugar::Plugin;

my $default_content_type = 'text/html; charset=utf-8';

=head1 ACTIONS

=head2 Private end

Will:

 1) Skip the whole process if
  *) Request method is HEAD
  *) A redirect response is in process
  *) Content body is set
 2) Check for internal errors.
  *) forward('/error', ['internal']) if so
 2) Set up stash('title'), unless already set
 3) Set res->content_type, unless already set up
  *) controller->{'default_content_type'} || 'text/html; charset=utf-8';
 3) Forward to a view. Either default view or stash('current_view')

=cut

private end => sub {
    return if(req->method eq 'HEAD');
    return if(res->location);
    return if(length res->body);

    my $view_component;

    # handle 500
    if(@{ c->error } and !c->debug) {
        report error => $_ for(@{ c->error });
        stash errors => c->error;
        forward '/error', ['internal'];
        c->error(0);
    }

    if(!stash('title')) {
        my $title = (split "/", req->path)[-1];

        $title ||= 'index';
        $title   =~ s/%(\w{2})/&nbsp;/g;

        report debug => 'Set stash(title=>%s)', $title if c->debug;
        stash title => $title;
    }

    if(!res->content_type) {
        my $content_type = controller->{'default_content_type'} || $default_content_type;
        report debug => 'Set content_type=%s', $content_type if c->debug;
        res->content_type($content_type);
    }

    if(defined( my $view_name = stash('current_view') )) {
        report debug => 'Forward to custom view: %s', $view_name if c->debug;
        $view_component = c->view($view_name);
    }
    else {
        report debug => 'Forward to default view' if c->debug;
        $view_component = c->view; # default
    }

    if($view_component) {
        return c->forward($view_component);
    }

    return;
};

=head1 LICENSE

=head1 AUTHOR

See L<CatalystX::Controller::Sugar::ActionPack>.

=cut

1;
