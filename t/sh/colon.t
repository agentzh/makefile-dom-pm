#: colon.t
#: Test the `:' (colon) builtin support in script/sh
#: Copyright (c) 2006 Agent Zhang
#: 2006-02-11 2006-02-11

use t::Shell;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: basic
--- cmd
:
--- stdout
--- stderr
--- success:        true



=== TEST 2: colon, but with arguments
--- cmd
: a b c
--- stdout
--- stderr
--- success:        true
