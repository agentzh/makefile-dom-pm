#: include.t
#:
#: Description:
#:   Test various forms of the GNU make `include' command.
#: Details:
#:   Test include, -include, sinclude and various regressions involving them.
#:   Test extra whitespace at the end of the include, multiple -includes and
#:   sincludes (should not give an error) and make sure that errors are reported
#:   for targets that were also -included.
#:
#: 2006-02-11 2006-02-14

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 0: Invoke the target in the host-makefile
--- source
#Extra space at the end of the following file name
include makefile2  
all: ; @echo There should be no errors for this makefile.

-include nonexistent.mk
-include nonexistent.mk
sinclude nonexistent.mk
sinclude nonexistent-2.mk
-include makeit.mk
sinclude makeit.mk

error: makeit.mk
--- pre
create_file('makefile2', "ANOTHER: ; \@echo This is another included makefile\n");
--- goals:        all
--- stdout
There should be no errors for this makefile.
--- stderr
--- success:      true



=== TEST 1: Invoke the target in included makefile
--- source
#Extra space at the end of the following file name
include makefile2  
all: ; @echo There should be no errors for this makefile.

-include nonexistent.mk
-include nonexistent.mk
sinclude nonexistent.mk
sinclude nonexistent-2.mk
-include makeit.mk
sinclude makeit.mk

error: makeit.mk
--- pre
create_file('makefile2', "ANOTHER: ; \@echo This is another included makefile\n");
--- goals:        ANOTHER
--- stdout
This is another included makefile
--- stderr
--- success:      true



=== TEST 2: Try to build the "error" target
this will fail since we don't know how to create makeit.mk, but we
should also get a message (even though the -include suppressed it
during the makefile read phase, we should see one during the
makefile run phase).
--- source

-include foo.mk
error: foo.mk ; @echo $@

--- stdout
--- stderr preprocess
#MAKE#: *** No rule to make target `foo.mk', needed by `error'.  Stop.
--- success:      false



=== TEST 3: Make sure that target-specific variables don't impact things.
This could happen because a file record is created when a target-specific
variable is set.
--- source

bar.mk: foo := baz
-include bar.mk
hello: ; @echo hello

--- stdout
hello
--- stderr
--- success:      true



=== TEST 4: Test inheritance of dontcare flag when rebuilding makefiles.
--- source
.PHONY: all
all: ; @:

-include foo

foo: bar; @:
--- stdout
--- stderr
--- success:      true



=== TEST 5: Make sure that we don't die when the command fails but we dontcare.
(Savannah bug #13216).
--- source
.PHONY: all
all:; @:

-include foo

foo: bar; @:

bar:; @exit 1
--- stdout
--- stderr
--- success:      true



=== TEST 6: Check include, sinclude, -include with no filenames.
(Savannah bug #1761).
--- source
.PHONY: all
all:; @:
include
-include
sinclude
--- stdout
--- stderr
--- success:      true
