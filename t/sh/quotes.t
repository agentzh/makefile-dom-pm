#: quotes.t
#: test the various quotes in `sh' syntax
#: 2006-02-02 2006-02-03

use t::Shell;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: single-colon, basic
--- cmd
echo 'hello, world'
--- stdout
hello, world
--- stderr
--- error_code
0



=== TEST 2: single-colon, whitespace
--- cmd
echo 'hello,    world'
--- stdout
hello,    world
--- stderr
--- error_code
0



=== TEST 3: single-colon, escape '
--- cmd
echo '\''
--- stdout:
--- stderr_like:  .*\w+.*
--- success:      false



=== TEST 4: single-colon, escape "
--- cmd
echo '\"'
--- stdout
\"
--- stderr
--- success:      true



=== TEST 5: single-colon, escape '\'
--- cmd
echo '\\'
--- stdout
\\
--- stderr
--- error_code
0



=== TEST 6: malformed single-colon
--- cmd
echo ab''
--- stdout
ab
--- stderr
--- error_code
0



=== TEST 7: ditto, another example
--- cmd
echo abcd
--- stdout
abcd
--- stderr
--- error_code
0



=== TEST 8: ditto, yet another
--- cmd
echo ab'cd
--- stdout
--- stderr_like:  .*\w+.*
--- success:      false



=== TEST 9: double quotes in single quotes
--- cmd
echo '""'
--- stdout
""
--- stderr
--- error_code
0



=== TEST 10: escaped single quote
--- cmd
echo \'
--- stdout
'
--- stderr
--- success:     true
