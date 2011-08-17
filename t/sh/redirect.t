#: redirect.t
#: test the redirection operator support of script/sh
#: Copyright (c) 2006 Zhang "agentzh" Yichun
#: 2006-02-10 2006-02-12

use t::Shell;

plan tests => 5 * blocks() - 1;

sub check_file ($$$) {
    my ($block, $filename, $expected) = @_;
    open my $in, $filename or
        die "Can't open $filename for reading: $!";
    local $/;
    my $got = <$in>;
    close $in;
    is ($got, $expected, "Check file content - ".$block->name);
}

run_tests;

__DATA__

=== TEST 1: redirect stdout to disk file
--- cmd
echo abc >tmp
--- stdout
--- stderr
--- found:         tmp
--- post:          ::check_file($block, 'tmp', "abc\n");
--- success:       true



=== TEST 2: ditto, another form
--- cmd
echo abc > tmp
--- stdout
--- stderr
--- found:         tmp
--- post:          ::check_file($block, 'tmp', "abc\n");
--- success:       true



=== TEST 3: ditto, yet another
--- cmd
echo abc> tmp
--- stdout
--- stderr
--- found:         tmp
--- post:          ::check_file($block, 'tmp', "abc\n");
--- success:       true



=== TEST 3: ditto, yet yet another
--- cmd
echo abc>tmp
--- stdout
--- stderr
--- found:         tmp
--- post:          ::check_file($block, 'tmp', "abc\n");
--- success:       true



=== TEST 4: quoted `>'
--- cmd
echo abc '>' tmp
--- stdout
abc > tmp
--- stderr
--- not_found:     tmp
--- success:       true



=== TEST 5: redirect stdout to the end of a disk file
--- cmd
echo 123 > tmp; echo abc >>tmp
--- stdout
--- stderr
--- found:         tmp
--- post:          ::check_file($block, 'tmp', "123\nabc\n");
--- success:       true



=== TEST 6: complex
--- cmd
echo '1: ; @echo ONE; sleep 2; echo TWO' > foo
--- stdout
--- stderr
--- found:         foo
--- post
::check_file($block, 'foo', '1: ; @echo ONE; sleep 2; echo TWO'."\n");
--- success:       true
