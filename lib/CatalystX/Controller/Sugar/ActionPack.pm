package CatalystX::Controller::Sugar::ActionPack;

=head1 NAME

CatalystX::Controller::Sugar::ActionPack - Plugins

=head1 VERSION

0.01

=head1 DESCRIPTION

This distribution is a collection of L<CatalystX::Controller::Sugar> plugins.

=head2 L<CatalystX::Controller::Sugar::ActionPack::Default>

This module acts as a default handler for a controller. It will either
server a file by its best knowledge or do C<go('/error', ["not_found"])>.

=head2 L<CatalystX::Controller::Sugar::ActionPack::End>

This plugin should be injected into the Root controller, or a controller
with namespace set to "" (empty string). It provides something similar to
L<Catalyst::Action::RenderView>.

=head2 L<CatalystX::Controller::Sugar::ActionPack::Error>

Used to server custom error pages, which the webapp dispatch to.

=head2 L<CatalystX::Controller::Sugar::ActionPack::Merge>

Provides an action which can serve multiple files in one request. The reason
for this is easier maintenance of css and js files, while having less request
to the web server.

=cut

our $VERSION = "0.01";

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Jan Henning Thorsen - jhthorsen -at- cpan.org

=cut

1;
