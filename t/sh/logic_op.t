#: logic_op.t
#: Test the logical AND (&&) and OR (||) operators in script/sh
#: Copyright (c) 2006 Zhang "agentzh" Yichun
#: 2006-02-13 2006-02-13

use t::Shell;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: basic `&&'
--- cmd
echo a && echo b
--- stdout
a
b
--- stderr
--- success:            true



=== TEST 2: quoted `&&'
--- cmd
echo 'a && echo b'
--- stdout
a && echo b
--- stderr
--- success:            true



=== TEST 3: short-circuit of `&&'
--- cmd
rm void && echo yeah
--- stdout
--- stderr_like
.+void.+
--- success:            false



=== TEST 4: short-circuit of `||'
--- cmd
echo a || echo b
--- stdout
a
--- stderr
--- success:            true



=== TEST 5: basic `||'
--- cmd
rm void || echo yeah
--- stdout
yeah
--- stderr_like
.+void.+
--- success:            true



=== TEST 6: quoted `||'
--- cmd
echo 'a || echo b'
--- stdout
a || echo b
--- stderr
--- success:            true



=== TEST 7: `exit' takes precedence
--- cmd
exit 1 || echo abc
--- stdout
--- stderr
--- error_code
1 * 256
