# Description:
#    The following test creates a makefile to test the suffix
#    function. 

#
# Details:
#    The suffix function will return the string following the last _._
#    the list provided. It will provide all of the unique suffixes found
#    in the list. The long strings are sorted to remove duplicates.


use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
IF YOU NEED >1 MAKEFILE FOR THIS TEST, USE &get_tmpfile; TO GET
THE NAME OF THE MAKEFILE.  THIS INSURES CONSISTENCY AND KEEPS TRACK OF
HOW MANY MAKEFILES EXIST FOR EASY DELETION AT THE END.
EXAMPLE:  = &get_tmpfile;
In this call to compare output, you should use the call &get_logfile(1)
to send the name of the last logfile created.  You may also use
the special call &get_logfile(1) which returns the same as &get_logfile(1).

--- source
string  := word.pl general_test2.pl1 FORCE.pl word.pl3 generic_test.perl /tmp.c/bar foo.baz/bar.c MAKEFILES_variable.c
string2 := $(string) $(string) $(string) $(string) $(string) $(string) $(string)
string3 := $(string2) $(string2) $(string2) $(string2) $(string2) $(string2) $(string2)
string4 := $(string3) $(string3) $(string3) $(string3) $(string3) $(string3) $(string3)
all: 
	@echo $(suffix $(string)) 
	@echo $(sort $(suffix $(string4))) 
	@echo $(suffix $(string) a.out) 
	@echo $(sort $(suffix $(string3))) 

--- stdout
.pl .pl1 .pl .pl3 .perl .c .c
.c .perl .pl .pl1 .pl3
.pl .pl1 .pl .pl3 .perl .c .c .out
.c .perl .pl .pl1 .pl3

--- stderr
--- error_code:  0

