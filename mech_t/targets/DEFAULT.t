# Description:
#    The following test creates a makefile to override part
#    of one Makefile with Another Makefile with the .DEFAULT
#    rule.
#
# Details:
#    This tests the use of the .DEFAULT special target to say that 
#    to remake any target that cannot be made fram the information
#    in the containing makefile, make should look in another makefile
#    This test gives this makefile the target bar which is not 
#    defined here but passes the target bar on to another makefile
#    which does have the target bar defined.


use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
bar:
	@echo Executing rule BAR


--- goals:  bar
--- stdout preprocess
#MAKE#[1]: Entering directory `#PWD#'
Executing rule BAR
#MAKE#[1]: Leaving directory `#PWD#'

--- stderr

