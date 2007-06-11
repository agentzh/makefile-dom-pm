# Description:
#    The following test creates a makefile to test the suffix function.
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
EXAMPLE: $makefile2 = &get_tmpfile;
In this call to compare output, you should use the call &get_logfile(1)
to send the name of the last logfile created.  You may also use
the special call &get_logfile(1) which returns the same as &get_logfile(1).

--- source
string := $(basename src/a.b.z.foo.c src/hacks src.bar/a.b.z.foo.c src.bar/hacks hacks) 
all: 
	@echo $(string) 

--- stdout
src/a.b.z.foo src/hacks src.bar/a.b.z.foo src.bar/hacks hacks

--- stderr
--- error_code:  0

