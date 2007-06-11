# Description:
#    The following test creates a makefile to test the addprefix function.
#
# Details:
#    

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
string := $(addprefix src/,a.b.z.foo hacks) 
all: 
	@echo $(string) 

--- stdout
src/a.b.z.foo src/hacks

--- stderr
--- error_code:  0

