# Description:
#    Test the --warn-undefined-variables option.
#
# Details:
#    Verify that warnings are printed for referencing undefined variables.

use t::Gmake;

plan tests => 3 * blocks() - 2;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
Without --warn-undefined-variables, nothing should happen

--- source

EMPTY =
EREF = $(EMPTY)
UREF = $(UNDEFINED)

SEREF := $(EREF)
SUREF := $(UREF)

all: ; @echo ref $(EREF) $(UREF)
--- stdout
ref
--- stderr



=== TEST 2:
With --warn-undefined-variables, it should warn me

--- source ditto
--- options:  --warn-undefined-variables
--- stdout
ref
--- stderr preprocess
#MAKEFILE#:6: warning: undefined variable `UNDEFINED'
#MAKEFILE#:8: warning: undefined variable `UNDEFINED'


