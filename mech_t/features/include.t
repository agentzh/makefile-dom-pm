# Description:
#    Test various forms of the GNU make `include' command.
#
# Details:
#    
#    Test include, -include, sinclude and various regressions involving them.
#    Test extra whitespace at the end of the include, multiple -includes and
#    sincludes (should not give an error) and make sure that errors are reported
#    for targets that were also -included.

use t::Gmake;

plan tests => 3 * blocks() - 6;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
-*-mode: perl; rm-trailing-spaces: nil-*-
The contents of the Makefile ...

--- source
ANOTHER: ; @echo This is another included makefile

--- goals:  all
--- stdout
There should be no errors for this makefile.

--- stderr



=== TEST 2:
--- source ditto
--- goals:  ANOTHER
--- stdout
This is another included makefile

--- stderr



=== TEST 3:
Try to build the "error" target; this will fail since we don't know
how to create makeit.mk, but we should also get a message (even though
the -include suppressed it during the makefile read phase, we should
see one during the makefile run phase).

--- source

-include foo.mk
error: foo.mk ; @echo $@

--- stdout

--- stderr preprocess
#MAKE#: *** No rule to make target `foo.mk', needed by `error'.  Stop.

--- error_code:  2



=== TEST 4:
Make sure that target-specific variables don't impact things.  This could
happen because a file record is created when a target-specific variable is
set.

--- source

bar.mk: foo := baz
-include bar.mk
hello: ; @echo hello

--- stdout
hello

--- stderr



=== TEST 5:
Test inheritance of dontcare flag when rebuilding makefiles.

--- source

.PHONY: all
all: ; @:

-include foo

foo: bar; @:

--- stdout

--- stderr



=== TEST 6:
Make sure that we don't die when the command fails but we dontcare.
(Savannah bug #13216).

--- source

.PHONY: all
all:; @:

-include foo

foo: bar; @:

bar:; @exit 1

--- stdout

--- stderr



=== TEST 7:
Check include, sinclude, -include with no filenames.
(Savannah bug #1761).

--- source

.PHONY: all
all:; @:
include
-include
sinclude
--- stdout

--- stderr

