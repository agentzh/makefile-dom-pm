# Description:
#    The following test creates a makefile to ...
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
x = variable1
variable2 := Hello
y = $(subst 1,2,$(x))
z = y
a := $($($(z)))
all: 
	@echo $(a)

--- stdout
Hello

--- stderr

