#: env.t
#: test environments used in `sh'
#: 2006-02-02 2006-02-02

use t::Shell;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: simple
--- pre:      $ENV{A} = 3;
--- cmd
echo $A
--- stdout
3
--- stderr
--- error_code
0



=== TEST 2: simple, and multiple
--- pre:      $ENV{A} = 5; $ENV{B} = 'abc';
--- cmd
echo $B $A
--- stdout
abc 5
--- stderr
--- error_code
0



=== TEST 3: interpolate
--- pre:      $ENV{ABC} = 2;
--- cmd
echo "$ABC"
--- stdout
2
--- stderr
--- error_code
0



=== TEST 4: interpolate, multiple
--- pre:     $ENV{foo} = 'FOO'; $ENV{bar} = 'BAR';
--- cmd
echo "FOO == $foo and BAR == $bar"
--- stdout
FOO == FOO and BAR == BAR
--- stderr
--- error_code
0



=== TEST 5: no interpolation in single quotes:
--- pre:     $ENV{A} = '123';
--- cmd
echo '$A' ' = ' "$A"
--- stdout
$A  =  123
--- stderr
--- error_code
0
