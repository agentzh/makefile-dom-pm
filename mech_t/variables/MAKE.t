# Description:
#    The following test creates a makefile to test MAKE 
#    (very generic)
#
# Details:
#    DETAILS

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
--- filename:  test.mk
--- source
TMP  := $(MAKE)
MAKE := $(subst X=$(X),,$(MAKE))

all:
	@echo $(TMP)
	$(MAKE) -f test.mk foo

foo:
	@echo $(MAKE)

--- stdout preprocess
#MAKE#
#MAKE# -f test.mk foo
#MAKE#[1]: Entering directory `#PWD#'
#MAKE#
#MAKE#[1]: Leaving directory `#PWD#'

--- stderr
--- error_code:  0

