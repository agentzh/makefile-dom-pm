# Description:
#    Test handling of static pattern rules.
#
# Details:
#    
#    The makefile created in this test has three targets.  The
#    filter command is used to get those target names ending in
#    .o and statically creates a compile command with the target
#    name and the target name with .c.  It also does the same thing
#    for another target filtered with .elc and creates a command
#    to emacs a .el file

use t::Gmake;

plan tests => 3 * blocks() - 8;

use_source_ditto;

run_tests;

__DATA__

=== TEST #0
--- source

files = foo.elc bar.o lose.o

$(filter %.o,$(files)): %.o: %.c ; @echo CC -c $(CFLAGS) $< -o $@

$(filter %.elc,$(files)): %.elc: %.el ; @echo emacs $<

--- touch:  lose.c bar.c
--- stdout
CC -c bar.c -o bar.o
--- stderr



=== TEST #1
--- source ditto
--- touch:  lose.c bar.c
--- options:  lose.o
--- stdout
CC -c lose.c -o lose.o
--- stderr



=== TEST #2
--- source ditto
--- touch:  foo.el lose.c bar.c
--- options:  foo.elc
--- stdout
emacs foo.el
--- stderr



=== TEST #3 -- PR/1670: don't core dump on invalid static pattern rules
Clean up after the first tests.

--- source

.DEFAULT: ; @echo $@
foo: foo%: % %.x % % % y.% % ; @echo $@

--- stdout
.x
y.
foo
--- stderr



=== TEST #4 -- bug #12180: core dump on a stat pattern rule with an empty
prerequisite list.

--- source

foo.x bar.x: %.x : ; @echo $@


--- stdout
foo.x
--- stderr



=== TEST #5 -- bug #13881: double colon static pattern rule does not
substitute %.

--- source

foo.bar:: %.bar: %.baz
foo.baz: ;@:

--- stdout

--- stderr



=== TEST #6: make sure the second stem does not overwrite the first
perprerequisite's stem (Savannah bug #16053).

--- source

all.foo.bar: %.foo.bar: %.one

all.foo.bar: %.bar: %.two

all.foo.bar:
	@echo $*
	@echo $^

.DEFAULT:;@:

--- stdout
all.foo
all.one all.foo.two
--- stderr



=== TEST #7: make sure the second stem does not overwrite the first
perprerequisite's stem when second expansion is enabled
(Savannah bug #16053).

--- source

.SECONDEXPANSION:

all.foo.bar: %.foo.bar: %.one $$*-one

all.foo.bar: %.bar: %.two $$*-two

all.foo.bar:
	@echo $*
	@echo $^

.DEFAULT:;@:

--- stdout
all.foo
all.one all-one all.foo.two all.foo-two
--- stderr

