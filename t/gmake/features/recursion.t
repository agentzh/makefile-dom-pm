#: recursion.t
#:
#: Description:
#:   Test recursion.
#: Details:
#:   DETAILS
#:
#: 2006-02-14 2006-02-14

use t::Gmake;

plan tests => 3 * blocks();

filters {
    source   => [qw< preprocess >],
    stdout   => [qw< preprocess >],
    stderr   => [qw< preprocess >],
};

run_tests;

__DATA__

=== TEST 0: Test some basic recursion.
--- source
all:
	$(MAKE) -f #MAKEFILE# foo
foo:
	@echo $(MAKE)
	@echo MAKELEVEL = $(MAKELEVEL)
	$(MAKE) -f #MAKEFILE# last
last:
	@echo $(MAKE)
	@echo MAKELEVEL = $(MAKELEVEL)
	@echo THE END

--- options
CFLAGS=-O -w
--- stdout
#MAKE#: Entering directory `#PWD#'
#MAKEPATH# -f #MAKEFILE# foo
#MAKE#[1]: Entering directory `#PWD#'
#MAKEPATH#
MAKELEVEL = 1
#MAKEPATH# -f #MAKEFILE# last
#MAKE#[2]: Entering directory `#PWD#'
#MAKEPATH#
MAKELEVEL = 2
THE END
#MAKE#[2]: Leaving directory `#PWD#'
#MAKE#[1]: Leaving directory `#PWD#'
#MAKE#: Leaving directory `#PWD#'
--- stderr
--- error_code
0



=== TEST 1: As above. parallel
--- source
all:
	$(MAKE) -f #MAKEFILE# foo
foo:
	@echo $(MAKE)
	@echo MAKELEVEL = $(MAKELEVEL)
	$(MAKE) -f #MAKEFILE# last
last:
	@echo $(MAKE)
	@echo MAKELEVEL = $(MAKELEVEL)
	@echo THE END

--- options
CFLAGS=-O -w -j 2
--- stdout
#MAKE#: Entering directory `#PWD#'
#MAKEPATH# -f #MAKEFILE# foo
#MAKE#[1]: Entering directory `#PWD#'
#MAKEPATH#
MAKELEVEL = 1
#MAKEPATH# -f #MAKEFILE# last
#MAKE#[2]: Entering directory `#PWD#'
#MAKEPATH#
MAKELEVEL = 2
THE END
#MAKE#[2]: Leaving directory `#PWD#'
#MAKE#[1]: Leaving directory `#PWD#'
#MAKE#: Leaving directory `#PWD#'
--- stderr
--- error_code
0



=== TEST 2: Test command line overrides.
--- source
recur: all ; @$(MAKE) --no-print-directory -f #MAKEFILE# a=AA all
all: ; @echo "MAKEOVERRIDES = $(MAKEOVERRIDES)"
--- options
a=ZZ
--- stdout_like
MAKEOVERRIDES = .*a=ZZ.*
MAKEOVERRIDES = .*a=AA.*
--- stderr
--- error_code
0
