package MDOM::Util;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = qw(
    trim_tokens
);

sub trim_tokens ($) {
    my $tokens = shift;
    return if !@$tokens;
    if ($tokens->[0] =~ /^\s+$/) {
        shift @$tokens;
    }
    return if !@$tokens;
    if ($tokens->[-1] =~ /^\s+$/) {
        pop @$tokens;
    }
}

1;
