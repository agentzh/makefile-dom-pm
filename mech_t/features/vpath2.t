# Description:
#    This is part 2 in a series to test the vpath directive
#    It tests the three forms of the directive:
#         vpath pattern directive
#         vpath pattern  (clears path associated with pattern)
#         vpath          (clears all paths specified with vpath)

#
# Details:
#    This test simply adds many search paths using various vpath
#    directive forms and clears them afterwards.  It has a simple
#    rule to print a message at the end to confirm that the makefile
#    ran with no errors.


use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
VPATH = .:
vpath %.c foo
vpath %.c .
vpath %.c 
vpath %.h .
vpath %.c
vpath
all:
	@echo ALL IS WELL

--- stdout
ALL IS WELL

--- stderr

