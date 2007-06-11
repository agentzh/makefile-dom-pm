# Description:
#    Test the MAKEFILE_LIST variable.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- filename:  test.mk
--- source
m2 := $(MAKEFILE_LIST)

--- stdout
test.mk
test.mk test.mk
test.mk test.mk

--- stderr

