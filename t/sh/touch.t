#: touch.t
#: Test the `touch' command support in script/sh
#: Copyright (c) 2006 Agent Zhang
#: 2006-02-11 2006-02-11

use t::Shell;

plan tests => 4 * blocks() + 2;

run_tests;

__DATA__

=== TEST 1: single argument
--- cmd
touch foo
--- found:        foo
--- stdout
--- stderr
--- success:      true



=== TEST 2: multiple arguments
--- cmd
touch foo bar baz
--- found:        foo bar baz
--- stdout
--- stderr
--- success:      true
