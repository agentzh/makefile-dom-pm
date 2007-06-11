# Description:
#    The following test creates a makefile to test
#    makelevels in Make. It prints $(MAKELEVEL) and then
#    prints the environment variable MAKELEVEL
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
RUN MAKE
SET ANSWER

--- source
all:
	@echo MAKELEVEL is $(MAKELEVEL)
	echo $$MAKELEVEL

--- stdout
MAKELEVEL is 0
echo $MAKELEVEL
1

--- stderr

