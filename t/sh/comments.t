#: comments.t
#: Test comments in shell
#: Copyright (c) 2006 Zhang "agentzh" Yichun
#: 2006-02-03 2006-02-10

use t::Shell;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: basic
--- cmd
echo hello, #world
--- stdout
hello,
--- stderr
--- error_code
0



=== TEST 2: `#' at the very beginning
--- cmd
#echo 'hello'
--- stdout
--- stderr
--- error_code
0



=== TEST 3: `#' in the middle of word
--- cmd
echo hello#world
--- stdout
hello#world
--- stderr
--- error_code
0



=== TEST 4: `#' at the end of word
--- cmd
echo hello# world!
--- stdout
hello# world!
--- stderr
--- error_code
0



=== TEST 5: `#' in single quotes
--- cmd
echo 'hi, #bill!'
--- stdout
hi, #bill!
--- stderr
--- error_code
0



=== TEST 6: `#' in double quotes
--- cmd
echo "hi, #jim!"
--- stdout
hi, #jim!
--- stderr
--- error_code
0



=== TEST 7: escaped `#'
--- cmd
echo hello, \#world
--- stdout
hello, #world
--- stderr
--- error_code
0



=== TEST 8: ditto, another example
--- cmd
echo foo\#bar.ext = 'foo#bar.ext'
--- stdout
foo#bar.ext = foo#bar.ext
--- stderr
--- error_code
0
