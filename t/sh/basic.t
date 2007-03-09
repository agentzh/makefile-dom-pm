#: basic.t
#: test the very basic syntax of `sh'
#: 2006-02-02 2006-02-03

use t::Shell;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: normal
--- cmd
echo hello, world
--- stdout
hello, world
--- stderr
--- error_code
0



=== TEST 2: whitespace
--- cmd
echo hello,    world
--- stdout
hello, world
--- stderr
--- error_code
0



=== TEST 3: multiple argument
--- cmd
echo a b c
--- stdout
a b c
--- stderr
--- error_code
0



=== TEST 4: no argument
--- cmd
echo
--- stdout unchomp
--- stderr
--- error_code
0



=== TEST 5: 0 as the argument
--- cmd
echo 0 "0" '0' ' '
--- stdout eval
"0 0 0  \n"
--- stderr
--- error_code
0
