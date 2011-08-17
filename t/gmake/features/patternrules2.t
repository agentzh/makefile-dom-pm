#: patternrules2.t
#: Extension to patternrules.t
#: Copyright (c) 2006 Zhang "agentzh" Yichun
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



=== TEST 3:
Implicit rules are applied in a reversed order if they have
the same level of generality.
--- source
.PHONY: all
all: foo.c foo.o

%.h %.c: %.in
	touch $*.h
	touch $*.c

%.o: %.c
	echo $+ >$@

%.o: %.c
	@echo wrong rule

foo.in:
	touch $@

--- stdout
touch foo.in
touch foo.h
touch foo.c
wrong rule
--- stderr
--- success:            true



=== TEST 4:
--- source
all: foo.x bar.w

%.x: %.h
	touch $@

%.w: %.hpp ; echo $<

--- touch: foo.h bar.hpp
--- stdout
touch foo.x
echo bar.hpp
bar.hpp
--- stderr
--- error_code:  0



=== TEST 5: chained implicit rules
--- source

all: foo.a bar.a baz.a

%.a: %.b ; touch $@
%.b: %.d ; touch $@

--- touch: foo.d bar.d baz.d
--- stdout
touch foo.b
touch foo.a
touch bar.b
touch bar.a
touch baz.b
touch baz.a
rm foo.b bar.b baz.b

--- stderr
--- error_code:  0
--- SKIP

