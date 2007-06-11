# Description:
#    Test the $(shell ...) function.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

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
--- error_code:  0



=== TEST 2:
Test shells inside exported environment variables.
This is the test that fails if we try to put make exported variables into
the environment for a $(shell ...) call.

--- source

export HI = $(shell echo hi)
.PHONY: all
all: ; @echo $$HI

--- stdout
hi
--- stderr
--- error_code:  0

