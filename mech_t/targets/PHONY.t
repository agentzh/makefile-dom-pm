# Description:
#    The following tests the use of a PHONY target.  It makes
#    sure that the rules under a target get executed even if
#    a filename of the same name of the target exists in the
#    directory.

#
# Details:
#    This makefile in this test declares the target clean to be a 
#    PHONY target.  We then create a file named "clean" in the 
#    directory.  Although this file exists, the rule under the target
#    clean should still execute because of it's phony status.

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
Create a file named "clean".  This is the same name as the target clean
and tricks the target into thinking that it is up to date.  (Unless you
use the .PHONY target.

--- source
.PHONY : clean 
all: 
	@echo This makefile did not clean the dir ... good
clean: 
	rm EXAMPLE_FILE clean

--- touch:  EXAMPLE_FILE clean
--- goals:  clean
--- stdout
rm EXAMPLE_FILE clean

--- stderr
--- not_found:  EXAMPLE_FILE

