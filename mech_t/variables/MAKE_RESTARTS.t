# Description:
#    Test the MAKE_RESTARTS variable.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
Test basic capability

--- source

all: ; @:
$(info MAKE_RESTARTS=$(MAKE_RESTARTS))
include foo.x
foo.x: ; @touch $@

--- stdout
MAKE_RESTARTS=
MAKE_RESTARTS=1
--- stderr preprocess
#MAKEFILE#:3: foo.x: No such file or directory

--- error_code:  0



=== TEST 2:
Test multiple restarts

--- source

all: ; @:
$(info MAKE_RESTARTS=$(MAKE_RESTARTS))
include foo.x
foo.x: ; @echo "include bar.x" > $@
bar.x: ; @touch $@

--- stdout
MAKE_RESTARTS=
MAKE_RESTARTS=1
MAKE_RESTARTS=2
--- stderr preprocess
#MAKEFILE#:3: foo.x: No such file or directory
foo.x:1: bar.x: No such file or directory

--- error_code:  0



=== TEST 3:
Test multiple restarts and make sure the variable is cleaned up

--- source preprocess

recurse:
	@echo recurse MAKE_RESTARTS=$$MAKE_RESTARTS
	@$(MAKE) -f #MAKEFILE# all
all:
	@echo all MAKE_RESTARTS=$$MAKE_RESTARTS
$(info MAKE_RESTARTS=$(MAKE_RESTARTS))
include foo.x
foo.x: ; @echo "include bar.x" > $@
bar.x: ; @touch $@

--- stdout preprocess
MAKE_RESTARTS=
MAKE_RESTARTS=1
MAKE_RESTARTS=2
recurse MAKE_RESTARTS=
MAKE_RESTARTS=
#MAKE#[1]: Entering directory `#PWD#'
all MAKE_RESTARTS=
#MAKE#[1]: Leaving directory `#PWD#'
--- stderr preprocess
#MAKEFILE#:7: foo.x: No such file or directory
foo.x:1: bar.x: No such file or directory

--- error_code:  0

