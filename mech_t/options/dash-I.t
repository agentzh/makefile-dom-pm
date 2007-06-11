# Description:
#    The following test creates a makefile to test the -I option.
#
# Details:
#    
#    This test tests the -I option by including a filename in
#    another directory and giving make that directory name
#    under -I in the command line.  Without this option, the make
#    would fail to find the included file.  It also checks to make
#    sure that the -I option gets passed to recursive makes.

use t::Gmake;

plan tests => 3 * blocks() - 3;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- filename:  test.mk
--- source
ANOTHER:
	@echo This is another included makefile
recurse:
	$(MAKE) ANOTHER -f test.mk

--- goals:  all
--- options:  -I .
--- stdout
There should be no errors for this makefile.

--- stderr



=== TEST 2:
--- source ditto
--- goals:  ANOTHER
--- options:  -I .
--- stdout
This is another included makefile

--- stderr



=== TEST 3:
--- filename:  test.mk
--- source ditto
--- goals:  recurse
--- options:  -I .
--- stdout preprocess
#MAKE# ANOTHER -f test.mk
#MAKE#[1]: Entering directory `#PWD#'
This is another included makefile
#MAKE#[1]: Leaving directory `#PWD#'

--- stderr

