# Description:
#    The following test creates a makefile to delete a 
#    file in the directory.  It tests to see if make will 
#    NOT execute the command unless the rule is given in 
#    the make command line.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() + 1;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source
all: 
	@echo This makefile did not clean the dir... good
clean: 
	rm EXAMPLE_FILE

--- touch:  EXAMPLE_FILE
--- stdout
This makefile did not clean the dir... good

--- stderr
--- error_code:  0



=== TEST 2:
--- source ditto
--- touch:  EXAMPLE_FILE
--- goals:  clean
--- stdout
rm EXAMPLE_FILE

--- stderr
--- error_code:  0
--- not_found:  EXAMPLE_FILE

