# Description:
#    Test various types of escaping in makefiles.
#
# Details:
#    
#    Make sure that escaping of `:' works in target names.
#    Make sure escaping of whitespace works in target names.
#    Make sure that escaping of '#' works.

use t::Gmake;

plan tests => 3 * blocks() - 4;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1
--- source

$(path)foo : ; @echo "touch ($@)"

foo\ bar: ; @echo "touch ($@)"

sharp: foo\#bar.ext
foo\#bar.ext: ; @echo "foo#bar.ext = ($@)"
--- stdout
touch (foo)
--- stderr



=== TEST 2: This one should fail, since the ":" is unquoted.
--- source ditto
--- options:  path=pre:
--- stdout

--- stderr preprocess
#MAKEFILE#:1: *** target pattern contains no `%'.  Stop.
--- error_code:  2



=== TEST 3: This one should work, since we escape the ":".
--- source ditto
--- options:  'path=pre:'
--- stdout
touch (pre:foo)
--- stderr



=== TEST 4: This one should fail, since the escape char is escaped.
--- source ditto
--- options:  'path=pre\:'
--- stdout

--- stderr preprocess
#MAKEFILE#:1: *** target pattern contains no `%'.  Stop.
--- error_code:  2



=== TEST 5: This one should work
--- source ditto
--- options:  'foo bar'
--- stdout
touch (foo bar)
--- stderr



=== TEST 6: Test escaped comments
--- source ditto
--- goals:  sharp
--- stdout
foo#bar.ext = (foo#bar.ext)
--- stderr

