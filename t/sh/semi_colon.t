#: semi_colon.t
#: test the semi_colon in the `sh' sytax
#: 2006-02-03 2006-02-03

use t::Shell;

plan tests => 1 * blocks;

run_tests;

__DATA__

=== TEST 1: simple
--- cmd
echo a; echo b
--- stdout
a
b



=== TEST 2: another form
--- cmd
echo a ; echo b
--- stdout
a
b



=== TEST 3: yet another
--- cmd
echo a ;echo b
--- stdout
a
b



=== TEST 4: in double quote
--- cmd
echo "a; echo b"
--- stdout
a; echo b



=== TEST 5: in single quote
--- cmd
echo 'a; echo b'
--- stdout
a; echo b



=== TEST 6: escaped
--- cmd
echo a\; echo b
--- stdout
a; echo b



=== TEST 7: multiple in one word
--- cmd
echo a;pwd;pwd; echo b
--- stdout_like
a
\S.+
\S.+
b
