# Description:
#    This tests the CURDIR varaible.
#
# Details:
#    Echo CURDIR both with and without -C.  Also ensure overrides work.

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST #1
--- source
all: ; @echo $(CURDIR)

--- stdout preprocess
#PWD#

--- stderr

