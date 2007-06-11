# Description:
#    The following test creates a makefile to verify
#    the ability of make to strip white space from lists of object.

#
# Details:
#    The make file is built with a list of objects that contain white space
#    These are then run through the strip command to remove it. This is then
#    verified by echoing the result.


use t::Gmake;

plan tests => 3 * blocks() - 2;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source
TEST1 := "Is this TERMINAL fun?                                                               What makes you believe is this terminal fun?                                                                                                                                               JAPAN is a WONDERFUL planet -- I wonder if we will ever reach                                         their level of COMPARATIVE SHOPPING..."
E :=
TEST2 := $E   try this     and		this     	$E

define TEST3

and these	        test out


some
blank lines



endef

.PHONY: all
all:
	@echo '$(strip  $(TEST1) )'
	@echo '$(strip  $(TEST2) )'
	@echo '$(strip  $(TEST3) )'

space: ; @echo '$(strip ) $(strip  	   )'


--- stdout
"Is this TERMINAL fun? What makes you believe is this terminal fun? JAPAN is a WONDERFUL planet -- I wonder if we will ever reach their level of COMPARATIVE SHOPPING..."
try this and this
and these test out some blank lines

--- stderr



=== TEST 2:
--- source ditto
--- goals:  space
--- stdout eval:  " \n"
--- stderr

