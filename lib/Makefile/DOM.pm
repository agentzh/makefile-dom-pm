package Makefile::DOM;

use strict;
use warnings;

our $VERSION = '0.001';

use MDOM::Document;
use MDOM::Element;
use MDOM::Node;
use MDOM::Rule;
use MDOM::Token;
use MDOM::Command;
use MDOM::Assignment;
use MDOM::Unknown;
use MDOM::Directive;

1;
__END__

=head1 NAME

Makefile::DOM - Simple DOM parser for Makefiles

=head1 DESCRIPTION

XXX

=head1 AUTHOR

Agent Zhang E<lt>agentzh@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2006, 2007, 2008 by Agent Zhang.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<MDOM::Document>, L<MDOM::Document::Gmake>.

