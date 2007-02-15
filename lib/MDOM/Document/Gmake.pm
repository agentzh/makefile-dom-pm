package MDOM::Document::Gmake;

use strict;
use warnings;

use Text::Balanced qw( gen_extract_tagged );
use Makefile::DOM;
#use Data::Dump::Streamer;
use base 'MDOM::Node';
use List::MoreUtils qw( before all any );
#use List::Util qw( first );

my %_map;
BEGIN {
    %_map = (
        COMMENT => 1,
        COMMAND => 2,
        RULE    => 3,
        VOID    => 4,
        UNKNOWN => 5,
    );
}

use constant \%_map;

my %_rev_map = reverse %_map;

my @keywords = qw(
    vpath include ifdef ifndef else endif 
    define endef export unexport
);

my $extract_interp_1 = gen_extract_tagged('\$[(]', '[)]', '');
my $extract_interp_2 = gen_extract_tagged('\$[{]', '[}]', '');

sub extract_interp {
    my ($res) = $extract_interp_1->($_[0]);
    if (!$res) {
        ($res) = $extract_interp_2->($_[0]);
    }
    $res;
}

my ($context, $saved_context);

sub new {
    my $class = ref $_[0] ? ref shift : shift;
    my $input = shift;
    return undef if !defined $input;
    my $in;
    if (ref $input) {
        open $in, '<', $input or die;
    } else {
        open $in, $input or
            die "Can't open $input for reading: $!";
    }
    my $self = $class->SUPER::new;
    $self->_tokenize($in);
    $self;
}

sub _tokenize {
    my ($self, $fh) = @_;
    $context = VOID;
    my @tokens;
    while (<$fh>) {
        #warn "!!! tokenizing $_";
        #warn "CONTEXT = ", $_rev_map{$context};
        s/\r\n/\n/g;
        $_ .= "\n" if !/\n$/s;
        if ($context == VOID || $context == RULE) {
            if ($context == VOID && s/(?x) ^ (\t\s*) (?= \# ) //) {
                #warn "Found comment in VOID context...";
                @tokens = (
                    MDOM::Token::Whitespace->new($1),
                    _tokenize_comment($_)
                );
                if ($tokens[-1]->isa('MDOM::Token::Continuation')) {
                    $saved_context = $context;
                    $context = COMMENT;
                    $tokens[-2]->add_content("\\\n");
                    pop @tokens;
                }
                $self->__add_elements( @tokens );
            }
            elsif (s/^\t//) {
                #warn "Found command in VOID/RULE context... ($_)";
                @tokens = _tokenize_command($_);
                #warn "*@tokens*";
                unshift @tokens, MDOM::Token::Separator->new("\t");
                if ($tokens[-1]->isa('MDOM::Token::Continuation')) {
                    #warn "From ", $_rev_map{$context}, " to COMMAND...";
                    $saved_context = $context;
                    $context = COMMAND;
                    $tokens[-2]->add_content("\\\n");
                    pop @tokens;
                }
                my $cmd = MDOM::Command->new;
                $cmd->__add_elements(@tokens);
                $self->__add_element($cmd);
                next;
            } else {
                @tokens = _tokenize_normal($_);
                if (@tokens >= 2 && $tokens[-1]->isa('MDOM::Token::Continuation') &&
                        $tokens[-2]->isa('MDOM::Token::Comment')) {
                    #warn "trailing comments found...";
                    $saved_context = $context;
                    $context = COMMENT;
                    $tokens[-2]->add_content("\\\n");
                    pop @tokens;
                    $self->__add_elements( _parse_normal(@tokens) );
                } elsif ($tokens[-1]->isa('MDOM::Token::Continuation')) {
                    #warn "continuation found...";
                    $saved_context = $context;
                    $context = UNKNOWN;
                } else {
                    #warn "line parsed....";
                    $self->__add_elements( _parse_normal(@tokens) );
                }
            }
        } elsif ($context == COMMENT) {
            @tokens = _tokenize_comment($_);
            if (! $tokens[-1]->isa('MDOM::Token::Continuation')) {
                #warn "finishing comment slurping...(switch back to ",
                #    $_rev_map{$saved_context}, ")";
                $context = $saved_context;
                my $last = pop @tokens;
                $self->last_token->add_content(join '', @tokens);
                $self->last_token->parent->__add_element($last);
            } else {
                $tokens[-2]->add_content("\\\n");
                pop @tokens;
                $self->last_token->add_content(join '', @tokens);
            }
        } elsif ($context == COMMAND) {
            @tokens = _tokenize_command($_);
            if (! $tokens[-1]->isa('MDOM::Token::Continuation')) {
                $context = RULE;
                my $last = pop @tokens;
                $self->last_token->add_content(join '', @tokens);
                $self->last_token->parent->__add_element($last);
            } else {
                $tokens[-2]->add_content("\\\n");
                pop @tokens;
                $self->last_token->add_content(join '', @tokens);
            }
        } elsif ($context == UNKNOWN) {
            push @tokens, _tokenize_normal($_);
            if (@tokens >= 2 && $tokens[-1]->isa('MDOM::Token::Continuation') &&
                    $tokens[-2]->isa('MDOM::Token::Comment')) {
                $context = COMMENT;
                $tokens[-2]->add_content("\\\n");
                pop @tokens;
                $self->__add_elements( _parse_normal(@tokens) );
            } elsif ($tokens[-1]->isa('MDOM::Token::Continuation')) {
                # do nothing here...stay in the UNKNOWN context...
            } else {
                $self->__add_elements( _parse_normal(@tokens) );
                $context = $saved_context;
            }
        } else {
            die "Unkown state: $context";
        }
    }
    if ($context != RULE && $context != VOID) {
        warn "unexpected end of input at line $.";
    }
}

sub _tokenize_normal {
    local $_ = shift;
    my @tokens;
    my $token = '';
    my $next_token;
    while (1) {
        #warn "token = $token";
        #warn extract_interp($_) if extract_interp($_);
        #warn pos;
        #warn '@tokens = ', _dump_tokens2(@tokens);
        if (/(?x) \G [\s\n]+ /gc) {
            #warn "!#@$@#@#@#" if $& eq "\n";
            $next_token = MDOM::Token::Whitespace->new($&);
            #push @tokens, $next_token;
        }
        elsif (/(?x) \G (?: := | \?= | \+= | [=:;] )/gc) {
            $next_token = MDOM::Token::Separator->new($&);
        }
        elsif (my $res = extract_interp($_)) {
            $next_token = MDOM::Token::Interpolation->new($res);
            #die "!!!???";
            #_dump_tokens($next_token);
        }
        elsif (/(?x) \G \$. /gc) {
            $next_token = MDOM::Token::Interpolation->new($&);
        }
        elsif (/(?x) \G \\ ([\#\\\n]) /gcs) {
            my $c = $1;
            if ($c eq "\n") {
                push @tokens, MDOM::Token::Bare->new($token) if $token;
                push @tokens, MDOM::Token::Continuation->new("\\\n");
                return @tokens;
            } else {
                $token .= "\\$c";
            }
        }
        elsif (/(?x) \G (\# [^\n]*) \\ \n/sgc) {
            my $s = $1;
            push @tokens, MDOM::Token::Bare->new($token) if $token;
            push @tokens, MDOM::Token::Comment->new($s);
            push @tokens, MDOM::Token::Continuation->new("\\\n");
            return @tokens;
        } elsif (/(?x) \G \# [^\n]* /gc) {
            $next_token = MDOM::Token::Comment->new($&);
        } elsif (/(?x) \G . /gc) {
            #warn "!#@$@#@#@#" if $& eq "\n";
            $token .= $&;
        } else {
            last;
        }
        if ($next_token) {
            if ($token) {
                push @tokens, MDOM::Token::Bare->new($token);
                $token = '';
            }
            push @tokens, $next_token;
            $next_token = undef;
        }
    }
    @tokens;
}

sub _tokenize_command {
    my $s = shift;
    my @tokens;
    my $token = '';
    my $next_token;
    my $strlen = length $s;
    #warn "$strlen <=> ", pos $_, "===========";
    if ($s =~ /(?x) \G (\s*) ([\@+\-]) /gc) {
        my ($whitespace, $modifier) = ($1, $2);
        if ($whitespace) {
            push @tokens, MDOM::Token::Whitespace->new($whitespace);
        }
        push @tokens, MDOM::Token::Modifier->new($modifier);
    }
    #warn "!>! ~!$_!~ !>!\n";
    #warn "!>! ~@tokens~ !>!";
    #warn "(1) !~! *@tokens* !~!\n";
    while (1) {
        #warn "   (2) !~! *@tokens* !~!\n";
        #warn '@tokens = ', Dumper(@tokens);
        #warn "TOKEN = *$token*\n";
        #warn "LEFT: *", (substr $s, pos $s), "*\n";
        #warn "pos before substitution: ", pos $s;
        my $last = 0;
        if ($s =~ /(?x) \G \n /gc) {
            #warn "!!!";
            $next_token = MDOM::Token::Whitespace->new("\n");
            #push @tokens, $next_token;
        }
        elsif (my $res = extract_interp($s)) {
            #pos $s += length($res);
            #warn "!!!!!!$s!!!!!";
            #warn "pos after substitution: ", pos $s;
            $next_token = MDOM::Token::Interpolation->new($res);
        }
        elsif ($s =~ /(?x) \G \$. /gc) {
            $next_token = MDOM::Token::Interpolation->new($&);
        }
        elsif ($s =~ /(?x) \G \\ ([\#\\\n]) /gcs) {
            #warn "!!!~~~~ *$&*\n";
            #warn pos $s, " == $strlen\n";
            my $c = $1;
            if ($c eq "\n" && pos $s == $strlen) {
                #warn "!!!~~~";
                $next_token = MDOM::Token::Continuation->new("\\\n");
            } else {
                $token .= "\\$c";
            }
        }
        elsif ($s =~ /(?x) \G . /gc) {
            #warn "appending '$&' to token...";
            $token .= $&;
        } else {
            $last = 1;
        }
        if ($next_token) {
            if ($token) {
                push @tokens, MDOM::Token::Bare->new($token);
                $token = '';
            }
            push @tokens, $next_token;
            $next_token = undef;
        }
        last if $last;
    }
    if ($token) {
        push @tokens, MDOM::Token::Bare->new($token);
        $token = '';
    }
    #warn "(3) !~! *@tokens* !~!\n";
    @tokens;
}

sub _tokenize_comment {
    local $_ = shift;
    my @tokens;
    my $token = '';
    #warn "COMMENT: $_";
    while (1) {
        if (/(?x) \G \n /gc) {
            push @tokens, MDOM::Token::Comment->new($token) if $token;
            push @tokens, MDOM::Token::Whitespace->new("\n");
            return @tokens;
            #push @tokens, $next_token;
        }
        elsif (/(?x) \G \\ ([\\\n]) /gcs) {
            my $c = $1;
            if ($c eq "\n") {
                push @tokens, MDOM::Token::Comment->new($token) if $token;
                push @tokens, MDOM::Token::Continuation->new("\\\n");
                return @tokens;
            } else {
                $token .= "\\$c";
            }
        }
        elsif (/(?x) \G . /gc) {
            $token .= $&;
        }
        else {
            last;
        }
    }
}

sub _parse_normal {
    my @tokens = @_;
    my @sep = grep { $_->isa('MDOM::Token::Separator') } @tokens;
    #_dump_tokens2(@sep);
    if (@tokens == 1) {
        return $tokens[0];
    }
    elsif (@sep >= 2 && $sep[0] eq ':' and $sep[1] eq ';') {
        my $rule = MDOM::Rule::Simple->new;
        my @t = before { $_ eq ';' } @tokens;
        $rule->__add_elements(@t);
        splice @tokens, 0, scalar(@t);

        my @prefix = shift @tokens;
        if ($tokens[0] && $tokens[0]->isa('MDOM::Token::Whitespace')) {
            push @prefix, shift @tokens;
        }

        @tokens = (@prefix, _tokenize_command(join '', @tokens));
        if ($tokens[-1]->isa('MDOM::Token::Continuation')) {
            $saved_context = $context;
            $context = COMMAND;
        }
        my $cmd = MDOM::Command->new;
        $cmd->__add_elements(@tokens);
        $rule->__add_elements($cmd);
        $saved_context = RULE;
        return $rule;
    }
    elsif (@sep >= 2 && $sep[0] eq ':' and $sep[1] eq ':') {
        my $rule = MDOM::Rule::StaticPattern->new;
        my @t = before { $_ eq ';' } @tokens;
        $rule->__add_elements(@t);
        splice @tokens, 0, scalar(@t);
        if (@tokens) {
            my @prefix = shift @tokens;
            if ($tokens[0] && $tokens[0]->isa('MDOM::Token::Whitespace')) {
                push @prefix, shift @tokens;
            }

            @tokens = (@prefix, _tokenize_command(join '', @tokens));
            if ($tokens[-1]->isa('MDOM::Token::Continuation')) {
                $saved_context = $context;
                $context = COMMAND;
            }
            my $cmd = MDOM::Command->new;
            $cmd->__add_elements(@tokens);
            $rule->__add_elements($cmd);
        }
        $saved_context = RULE;
        return $rule;
    }
    elsif (@sep == 1 && $sep[0] eq ':') {
        my $rule = MDOM::Rule::Simple->new;
        $rule->__add_elements(@tokens);
        $saved_context = RULE;
        return $rule;
    }
    elsif (@sep && ($sep[0] eq '=' || $sep[0] eq ':=' || $sep[0] eq '+=' ||
                    $sep[0] eq '?=')) {
        my $assign = MDOM::Assignment->new;
        $assign->__add_elements(@tokens);
        $saved_context = VOID;
        return $assign;
    }
    if (all {
                $_->isa('MDOM::Token::Comment')    ||
                $_->isa('MDOM::Token::Whitespace') 
            } @tokens) {
        @tokens;
    } else {
        # XXX directive support given here...
        # filter out significant tokens:
        my ($fst, $snd) = grep { $_->significant } @tokens;
        #_dump_tokens2($fst, $snd);
        my $is_directive;
        if ($fst eq '-include') {
            $fst->set_content('include');
            unshift @tokens, MDOM::Token::Modifier->new('-');
            $is_directive = 1;
        }
        elsif ($fst eq 'override' && $snd eq 'define' ||
            (any { $fst eq $_ } @keywords)) {
            $is_directive = 1;
        }
        my $node;
        if ($is_directive) {
            $node = MDOM::Directive->new;
            $node->__add_elements(@tokens);
        } else {
            #warn "!!!! It's unkown: *@tokens* !!!!";
            @tokens = _tokenize_command(join '', @tokens);
            $node = MDOM::Unknown->new;
            $node->__add_elements(@tokens);
        }
        $node;
    }
}

sub _dump_tokens {
    my @tokens = map { $_->clone } @_;
    warn "??? ", (join ' ',
        map { s/\\/\\\\/g; s/\n/\\n/g; s/\t/\\t/g; "[$_]" } @tokens
    ), "\n";
}

sub _dump_tokens2 {
    my @tokens = map { $_->clone } @_;
    Dump(@tokens)->To(\*STDERR)->Out();
}

1;
