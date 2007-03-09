#: include2.t
#: Extension to include.t
#: Copyright (c) 2006 Agent Zhang
#: 2006-02-11 2006-02-14

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: errors when remaking included makefile
--- filename:     makefile
--- source
.PHONY: all
all: ; @:

include foo
foo: bar; @:
--- stdout
--- stderr preprocess
makefile:4: foo: No such file or directory
#MAKE#: *** No rule to make target `bar', needed by `foo'.  Stop.
--- success:      false



=== TEST 2: target-specific rule
--- source
bar.mk: foo := baz
hello: ; @echo hello
--- stdout
hello
--- stderr
--- success:      true
