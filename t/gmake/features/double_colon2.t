use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: Savannah bug #14334
--- utouch
-3 bar
-2 foo
-1 baz
--- source
all: foo; touch $@

foo:: bar; echo bar && touch $@

foo:: baz; echo baz && touch $@
--- stdout
echo baz && touch foo
baz
touch all
--- stderr
--- error_code: 0



=== TEST 2: Savannah bug #14334
--- utouch
-1 bar
-2 foo
-1 baz
-1 bit
--- source
all: foo bit; touch $@

foo:: bar
	@echo first
	touch $@

foo:: baz
	@echo second
	touch $@

bit: foo ; @echo bit

--- stdout
first
touch foo
second
touch foo
bit
touch all
--- stderr
--- error_code: 0



=== TEST 3: example from dmake's manpage
"If a.o is found to be out of date with
respect to a.c then the first recipe
is used to make a.o."
--- utouch
-2 a.o
-1 a.c
-3 b.h
-3 a.y1
--- source
a.o :: a.c b.h
	@echo first

a.o :: a.y1 b.h
	@echo second
--- stdout
first
--- stderr
--- error_code
0



=== TEST 4: ditto (2)
"If it (i.e. a.o) is found out of date with respect to a.y
then the second recipe is used."
--- utouch
-3 a.o
-1 a.y1
-4 b.h
-4 a.c
--- source
a.o :: a.c b.h
	@echo first

a.o :: a.y1 b.h
	@echo second

--- stdout
second
--- stderr
--- error_code
0



=== TEST 4: ditto (3)
"If a.o is out of date with respect to b.h
then both recipes are invoked to make a.o.
In the last case the order of invocation
corresponds to the order in which the rule
definitions appear in the makefile."
--- utouch
-2 a.o
-3 a.y1
-1 b.h
-4 a.c
--- source
a.o :: a.c b.h
	@echo first

a.o :: a.y1 b.h
	@echo second

--- stdout
first
second
--- stderr
--- error_code
0



=== TEST 9: make sure all rules in s double colon family get executed (Savannah bug #14334). (2)
--- touch:                one two
--- utouch:               -2 result
--- source
.PHONY: all
all: result

result:: one
	@echo $^ >>$@
	@echo $^

result:: two
	@echo $^ >>$@
	@echo $^

--- stdout
one
two
--- stderr
--- success:           true

