package MDOM::Assignment;

use strict;
use base 'MDOM::Node';

sub lhs ($) {
    my ($self) = @_;
    $self->_parse if !defined $self->{op};
    my $tokens = $self->{lhs};

    return wantarray ?
        @$tokens
        :
        join '', map { $_->content } @$tokens;
}

sub rhs ($) {
    my ($self) = @_;
    $self->_parse if !defined $self->{op};
    my $tokens = $self->{rhs};

    return wantarray ?
                @$tokens
            :
                join '', map { $_->content } @$tokens;
}

sub op {
    my ($self) = @_;
    $self->_parse if !defined $self->{op};
    $self->{op};
}

sub _parse ($) {
    my ($self) = @_;
    my @elems = $self->elements;
    my (@lhs, @rhs, $op);
    for my $elem (@elems) {
        if (!$op) {
            if ($elem->class eq 'MDOM::Token::Separator') {
                $op = $elem;
            } else {
                push @lhs, $elem;
            }
        } elsif ($elem->class eq 'MDOM::Token::Comment') {
            last;
        } else {
            push @rhs, $elem;
        }
    }
    $self->{lhs} = \@lhs;
    $self->{rhs} = \@rhs;
    $self->{op}  = $op;
}

1;
