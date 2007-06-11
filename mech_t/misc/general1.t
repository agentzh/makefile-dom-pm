# Description:
#    The following test creates a makefile to test the
#    simple functionality of make.  It mimics the
#    rebuilding of a product with dependencies.
#    It also tests the simple definition of VPATH.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
VPATH = .
edit:  main.o kbd.o commands.o display.o \
       insert.o
	@echo cc -o edit main.o kbd.o commands.o display.o \
                  insert.o
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

