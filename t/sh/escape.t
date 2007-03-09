#: escape.t
#: test the escape character `\' in `sh' syntax
#: 2006-02-03 2006-02-03

use t::Shell;

plan tests => 1 * blocks;

run_tests;

__DATA__

=== TEST 1: in unquoted argument
--- cmd
echo \aa
--- stdout
aa



=== TEST 2: ditto
--- cmd
echo b\'a
--- stdout
b'a



=== TEST 3:
--- cmd
echo \'ba
--- stdout
'ba



=== TEST 4:
--- cmd
echo \'\'\a\\
--- stdout
''a\



=== TEST 5: in quoted argument
--- cmd
echo "\a\ "
--- stdout eval
"\\a\\ \n"
