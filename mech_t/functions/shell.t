# Description:
#    Test the $(shell ...) function.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 2;

run_tests;

__DATA__

=== TEST 1:
Test shells inside rules.

--- source
.PHONY: all
all: ; @echo $(shell echo hi)

--- stdout
hi
--- stderr



=== TEST 2:
Test shells inside exported environment variables.
This is the test that fails if we try to put make exported variables into
the environment for a 1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4shell ...) call.

--- source

export HI = $(shell echo hi)
.PHONY: all
all: ; @echo $$HI

--- stdout
hi
--- stderr

