package MDOM::Rule::Simple;

use strict;
use warnings;
use base 'MDOM::Rule';
use MDOM::Util qw( trim_tokens );

sub targets {
    my ($self) = @_;
    $self->_parse if !$self->{colon};
    my $tokens = $self->{targets};
    wantarray ? @$tokens : $tokens;
}

sub prereqs {
    my ($self) = @_;
    $self->_parse if !$self->{colon};
    my $tokens = $self->{prereqs};
    wantarray ? @$tokens : $tokens;
}

sub colon {
    my ($self) = @_;
    $self->_parse if !$self->{colon};
    $self->{colon};
}

sub command {
    my ($self) = @_;
    $self->_parse if !$self->{colon};
    $self->{command};
}

sub _parse {
    my ($self) = @_;
    my @elems = $self->elements;
    my (@targets, $colon, @prereqs, $command);
    for my $elem (@elems) {
        if (!$colon) {
            if ($elem->class eq 'MDOM::Token::Separator') {
                $colon = $elem->content;
            } else {
                push @targets, $elem;
            }
        } elsif ($elem->class eq 'MDOM::Token::Comment') {
            last;
        } elsif ($elem->class eq 'MDOM::Command') {
            $command = $elem;
            last;
        } else {
            push @prereqs, $elem;
        }
    }
    trim_tokens(\@targets);
    trim_tokens(\@prereqs);
    $self->{targets} = \@targets;
    $self->{colon}   = $colon;
    $self->{prereqs} = \@prereqs;
    $self->{command} = $command;
}

1;

