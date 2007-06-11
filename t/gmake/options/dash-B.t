# Description:
#    Test make -B (always remake) option.

#
# Details:
#    
#    Construct a simple makefile that builds a target.
#    Invoke make once, so it builds everything.  Invoke it again and verify
#    that nothing is built.  Then invoke it with -B and verify that everything
#    is built again.

use t::Gmake;

#plan tests => 3 * blocks() - 2;
plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source

.SUFFIXES:

.PHONY: all
all: foo

foo: bar.x
	@echo cp $< $@
	@echo "" > $@

--- touch:  bar.x
--- stdout
cp bar.x foo
--- stderr
--- error_code:  0



=== TEST 2:
--- source ditto
--- touch:  bar.x foo
--- stdout preprocess
#MAKE#: Nothing to be done for `all'.
--- stderr
--- error_code:  0



=== TEST 3:
--- source ditto
--- touch:  bar.x foo
--- options:  -B
--- stdout
cp bar.x foo
--- stderr
--- error_code:  0



=== TEST 4:
Put the timestamp for foo into the future; it should still be remade.

--- source ditto
--- touch:  bar.x
--- utouch:  1000 foo
--- stdout preprocess
#MAKE#: Nothing to be done for `all'.
--- stderr
--- error_code:  0



=== TEST 5:
--- source ditto
--- touch:  bar.x
--- utouch:  1000 foo
--- options:  -B
--- stdout
cp bar.x foo
--- stderr
--- error_code:  0



=== TEST 6:
Clean up
Test -B with the re-exec feature: we don't want to re-exec forever
Savannah bug # 7566

--- source

all: ; @:
$(info MAKE_RESTARTS=$(MAKE_RESTARTS))
include foo.x
foo.x: ; @touch $@

--- options:  -B
--- stdout
MAKE_RESTARTS=
MAKE_RESTARTS=1
--- stderr preprocess
#MAKEFILE#:3: foo.x: No such file or directory
--- error_code:  0
--- SKIP



=== TEST 7:
Test -B with the re-exec feature: we DO want -B in the "normal" part of the
makefile.

--- source

all: blah.x ; @echo $@
$(info MAKE_RESTARTS=$(MAKE_RESTARTS))
include foo.x
foo.x: ; @touch $@
blah.x: ; @echo $@

--- touch:  blah.x
--- options:  -B
--- stdout
MAKE_RESTARTS=
MAKE_RESTARTS=1
blah.x
all
--- stderr preprocess
#MAKEFILE#:3: foo.x: No such file or directory
--- error_code:  0
--- SKIP

