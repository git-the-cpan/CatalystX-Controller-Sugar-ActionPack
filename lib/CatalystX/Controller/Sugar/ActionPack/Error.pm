package CatalystX::Controller::Sugar::ActionPack::Error;

=head1 NAME

CatalystX::Controller::Sugar::ActionPack::Error - Action for error pages

=head1 DESCRIPTION

Used to server custom error pages, which the webapp dispatch to.

=cut

use Moose;
use CatalystX::Controller::Sugar::Plugin;
use CatalystX::Controller::Sugar::ActionPack::Default;

=head1 VARIABLES

=head2 %ERROR_STATUS

This hash holds a mapping between the error template and the response
status. See the source code for a sample of default templates.

=cut

our %ERROR_STATUS = (
    bad_request => 400,
    fallback => 500,
    internal => 500,
    method_not_allowed => 405,
    no_content => 404,
    not_found => 404,
    unauthorized => 401,
    undefined_user => 404,
);

=head1 ACTIONS

=head2 Endpoint /error/*

 go '/error' => [$template, $message];

Show error message, and set HTTP response status. Supported status: See
C<%ERROR_STATUS>.

Affected stash variables:

 {
   template => "error/$template.tt",
   title => "error - $status_code",
   error_message => $message,
 }

=cut

chain error => sub {
    my $error_id = shift || 'fallback';
    my $msg = shift || '';
    my $status = $ERROR_STATUS{$error_id} || 500;
    my $template = CatalystX::Controller::Sugar::ActionPack::Default::_find_template("error/$error_id");

    unless($template) {
        report error => 'Could not find error template: %s', $error_id if c->debug;
        $template = 'error/fallback.tt';
    }

    stash template => $template;
    stash title => "error - $status";
    stash error_message => $msg;

    res->status($status);
};

=head1 LICENSE

=head1 AUTHOR

See L<CatalystX::Controller::Sugar::ActionPack>.

=cut

1;
