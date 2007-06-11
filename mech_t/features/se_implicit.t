# Description:
#    Test second expansion in ordinary rules.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== Test #1: automatic variables.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

foo.a: bar baz

foo.a: biz | buz

foo.%: 1.$$@ \
       2.$$< \
       $$(addprefix 3.,$$^) \
       $$(addprefix 4.,$$+) \
       5.$$| \
       6.$$*
	@:

1.foo.a \
2.bar \
3.bar \
3.baz \
3.biz \
4.bar \
4.baz \
4.biz \
5.buz \
6.a:
	@echo $@


--- stdout
1.foo.a
2.bar
3.bar
3.baz
3.biz
4.bar
4.baz
4.biz
5.buz
6.a
bar
baz
biz
buz

--- stderr
--- error_code:  0



=== Test #2: target/pattern -specific variables.
--- source

.SECONDEXPANSION:
foo.x:

foo.%: $$(%_a) $$(%_b) bar
	@:

foo.x: x_a := bar

%.x: x_b := baz

bar baz: ; @echo $@


--- stdout
bar
baz

--- stderr
--- error_code:  0



=== Test #3: order of prerequisites.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

all: foo bar baz


# Subtest #1
#
%oo: %oo.1; @:

foo: foo.2

foo: foo.3

foo.1: ; @echo $@


# Subtest #2
#
bar: bar.2

%ar: %ar.1; @:

bar: bar.3

bar.1: ; @echo $@


# Subtest #3
#
baz: baz.1

baz: baz.2

%az: ; @:


--- stdout
foo.1
foo.2
foo.3
bar.1
bar.2
bar.3
baz.1
baz.2

--- stderr
--- error_code:  0



=== Test #4: stem splitting logic.
--- source

.SECONDEXPANSION:
$(dir)/tmp/bar.o:

$(dir)/tmp/foo/bar.c: ; @echo $@
$(dir)/tmp/bar/bar.c: ; @echo $@
foo.h: ; @echo $@

%.o: $$(addsuffix /%.c,foo bar) foo.h
	@echo $@: {$<} $^


--- options preprocess:  dir=#PWD#
--- stdout preprocess
#PWD#/tmp/foo/bar.c
#PWD#/tmp/bar/bar.c
foo.h
#PWD#/tmp/bar.o: {#PWD#/tmp/foo/bar.c} #PWD#/tmp/foo/bar.c #PWD#/tmp/bar/bar.c foo.h

--- stderr
--- error_code:  0



=== Test #5: stem splitting logic and order-only prerequisites.
--- source

.SECONDEXPANSION:
$(dir)/tmp/foo.o: $(dir)/tmp/foo.c
$(dir)/tmp/foo.c: ; @echo $@
bar.h: ; @echo $@

%.o: %.c|bar.h
	@echo $@: {$<} {$|} $^


--- options preprocess:  dir=#PWD#
--- stdout preprocess
#PWD#/tmp/foo.c
bar.h
#PWD#/tmp/foo.o: {#PWD#/tmp/foo.c} {bar.h} #PWD#/tmp/foo.c

--- stderr
--- error_code:  0



=== Test #6: lack of implicit prerequisites.
--- source

.SECONDEXPANSION:
foo.o: foo.c
foo.c: ; @echo $@

%.o:
	@echo $@: {$<} $^


--- stdout
foo.c
foo.o: {foo.c} foo.c

--- stderr
--- error_code:  0



=== Test #7: Test stem from the middle of the name.
--- source

.SECONDEXPANSION:
foobarbaz:

foo%baz: % $$*.1
	@echo $*

bar bar.1:
	@echo $@


--- stdout
bar
bar.1
bar

--- stderr
--- error_code:  0



=== Test #8: Make sure stem triple-expansion does not happen.
--- source

.SECONDEXPANSION:
foo$$bar:

f%r: % $$*.1
	@echo '$*'

oo$$ba oo$$ba.1:
	@echo '$@'


--- stdout
oo$ba
oo$ba.1
oo$ba

--- stderr
--- error_code:  0

