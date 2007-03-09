#: exit.t
#: Test the `exit' builtin support in script/sh
#: Copyright (c) 2006 Agent Zhang
#: 2006-02-11 2006-02-11

use t::Shell;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: exit
--- cmd
exit
--- stdout
--- stderr
--- error_code
0



=== TEST 2: exit with 1
--- cmd
exit 1
--- stdout
--- stderr
--- error_code
1 * 256



=== TEST 3: exit with 3
--- cmd
exit 3
--- stdout
--- stderr
--- error_code
3 * 256
