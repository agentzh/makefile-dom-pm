# Description:
#    The following test creates a makefile to test the
#    simple functionality of make.  It is the same as
#    general_test1 except that this one tests the
#    definition of a variable to hold the object filenames.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
The contents of the Makefile ...

--- source
VPATH = .
objects = main.o kbd.o commands.o display.o insert.o
edit:  $(objects)
	@echo cc -o edit $(objects)
main.o : main.c defs.h
	@echo cc -c main.c
kbd.o : kbd.c defs.h command.h
	@echo cc -c kbd.c
commands.o : command.c defs.h command.h
	@echo cc -c commands.c
display.o : display.c defs.h buffer.h
	@echo cc -c display.c
insert.o : insert.c defs.h buffer.h
	@echo cc -c insert.c

--- touch:  ./command.h ./command.c ./commands.c ./buffer.h ./display.c ./main.c ./insert.c ./defs.h ./kbd.c
--- stdout
cc -c main.c
cc -c kbd.c
cc -c commands.c
cc -c display.c
cc -c insert.c
cc -o edit main.o kbd.o commands.o display.o insert.o

--- stderr

