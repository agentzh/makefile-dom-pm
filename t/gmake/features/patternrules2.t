#: patternrules2.t
#: Extension to patternrules.t
#: Copyright (c) 2006 Agent Zhang
#: 2006-02-13 2006-02-14

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: `$@' for multi-target pattern rules
--- source
all: foo.c foo.o

%.o %.c: %.h
	@echo $@

foo.h: ; @echo $@

--- stdout
foo.h
foo.c
--- stderr
--- success:            true



=== TEST 2: target of multi-target implicit rules should be considered intermediate file
a variant for TEST #5 in patternrules.t
--- source
.PHONY: all
all: foo.c foo.o

%.h %.c: %.in
	touch $*.h
	touch $*.c

%.o: %.c
	echo $+ >$@

foo.in:
	touch $@

--- stdout
touch foo.in
touch foo.h
touch foo.c
echo foo.c >foo.o
--- stderr
--- success:            true
