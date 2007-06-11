# Description:
#    Test the MAKEFILES variable.
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
M3 = m3
NDEF3: ; @echo RULE FROM MAKEFILE 3

--- options:  MAKEFILES='test.mk test.mk'
--- stdout
DEFAULT RULE: M2=m2 M3=m3

--- stderr

