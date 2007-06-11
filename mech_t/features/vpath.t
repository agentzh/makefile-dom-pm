# Description:
#    The following test creates a makefile to test the 
#    vpath directive which allows you to specify a search 
#    path for a particular class of filenames, those that
#    match a particular pattern.
#
# Details:
#    This tests the vpath directive by specifying search directories
#    for one class of filenames with the form: vpath pattern directories
#    In this test, we specify the working directory for all files
#    that end in c or h.  We also test the variables  (which gives
#    target name) and STDOUT_TOP (which is a list of all dependencies 
#    including the directories in which they were found).  It also
#    uses the function firstword used to extract just the first
#    dependency from the entire list.

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
vpath %.c foo
vpath %.c .
vpath %.h .
objects = main.o kbd.o commands.o display.o insert.o
edit:  $(objects)
	@echo cc -o $@ $^
main.o : main.c defs.h
	@echo cc -c $(firstword $^)
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
cc -c ./main.c
cc -c kbd.c
cc -c commands.c
cc -c display.c
cc -c insert.c
cc -o edit main.o kbd.o commands.o display.o insert.o

--- stderr

