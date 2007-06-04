package MDOM::Directive;

use strict;
use base 'MDOM::Node';

sub name {
    my ($self) = @_;
    # XXX need a better way to do this:
    return $self->schild(0);
}

sub value {
    my ($self) = @_;
    # XXX This is a hack
    return $self->schild(1);
}

1;

