# Description:
#    Test the make -k (don't stop on error) option.

#
# Details:
#    
#    The makefile created in this test is a simulation of building
#    a small product.  However, the trick to this one is that one
#    of the dependencies of the main target does not exist.
#    Without the -k option, make would fail immediately and not
#    build any part of the target.  What we are looking for here,
#    is that make builds the rest of the dependencies even though
#    it knows that at the end it will fail to rebuild the main target.

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
--- source
VPATH = .
edit:  main.o kbd.o commands.o display.o
	@echo cc -o edit main.o kbd.o commands.o display.o

main.o : main.c defs.h
	@echo cc -c main.c

kbd.o : kbd.c defs.h command.h
	@echo cc -c kbd.c

commands.o : command.c defs.h command.h
	@echo cc -c commands.c

display.o : display.c defs.h buffer.h
	@echo cc -c display.c

--- touch:  ./display.c ./command.h ./main.c ./command.c ./commands.c ./buffer.h ./defs.h
--- options:  -k
--- stdout preprocess
cc -c main.c
#MAKE#: *** No rule to make target `kbd.c', needed by `kbd.o'.
cc -c commands.c
cc -c display.c
#MAKE#: Target `edit' not remade because of errors.

--- stderr
--- error_code:  2



=== TEST 1: Make sure that top-level targets that depend on targets that
previously failed to build, aren't attempted.  Regression for PR/1634.

--- source
.SUFFIXES:

all: exe1 exe2; @echo making $@

exe1 exe2: lib; @echo cp $^ $@

lib: foo.o; @echo cp $^ $@

foo.o: ; exit 1

--- options:  -k
--- stdout preprocess
exit 1
#MAKE#: Target `all' not remade because of errors.

--- stderr preprocess
#MAKE#: *** [foo.o] Error 1

--- error_code:  2



=== TEST 3:
TEST -- make sure we keep the error code if we can't create an included
makefile.

--- source
all: ; @echo hi
include ifile
ifile: no-such-file; @false

--- options:  -k
--- stdout preprocess
#MAKE#: *** No rule to make target `no-such-file', needed by `ifile'.
#MAKE#: Failed to remake makefile `ifile'.
hi

--- stderr preprocess
#MAKEFILE#:2: ifile: No such file or directory

--- error_code:  2

