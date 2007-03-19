package MDOM::Assignment;

use strict;
use base 'MDOM::Node';
use MDOM::Util qw( trim_tokens );

sub lhs ($) {
    my ($self) = @_;
    $self->_parse if !defined $self->{op};
    my $tokens = $self->{lhs};
    wantarray ? @$tokens : $tokens;
}

sub rhs ($) {
    my ($self) = @_;
    $self->_parse if !defined $self->{op};
    my $tokens = $self->{rhs};
    wantarray ? @$tokens : $tokens;
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
    trim_tokens(\@lhs);
    pop @rhs if $rhs[-1] eq "\n";
    shift @rhs if $rhs[0]->class eq 'MDOM::Token::Whitespace';
    $self->{lhs} = \@lhs;
    $self->{rhs} = \@rhs;
    $self->{op}  = $op;
}

1;
