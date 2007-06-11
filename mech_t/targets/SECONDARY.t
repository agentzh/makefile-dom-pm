# Description:
#    Test the behaviour of the .SECONDARY target.
#
# Details:
#    
#    Test the behavior of the .SECONDARY special target.
#    Create a makefile where a file would not normally be considered
#    intermediate, then specify it as .SECONDARY.  Build and note that it's
#    not automatically deleted.  Delete the file.  Rebuild to ensure that
#    it's not created if it doesn't exist but doesn't need to be built.
#    Change the original and ensure that the secondary file and the ultimate
#    target are both rebuilt, and that the secondary file is not deleted.
#    
#    Try this with implicit rules and explicit rules: both should work.


use t::Gmake;

plan tests => 3 * blocks() - 7;

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
--- source

.SECONDARY: foo.e

# Implicit rule test
%.d : %.e ; cp $< $@
%.e : %.f ; cp $< $@

foo.d: foo.e

# Explicit rule test
foo.c: foo.e ; cp $< $@

--- utouch:  -20 foo.f
--- options:  foo.d
--- stdout
cp foo.f foo.e
cp foo.e foo.d

--- stderr



=== TEST #2
--- source ditto
--- utouch:  -20 foo.f
--- options:  foo.d
--- stdout preprocess
#MAKE#: `foo.d' is up to date.

--- stderr



=== TEST #3
--- source ditto
--- touch:  foo.f
--- utouch:  -10 foo.d
--- options:  foo.d
--- stdout
cp foo.f foo.e
cp foo.e foo.d

--- stderr



=== TEST #4
--- source ditto
--- touch:  foo.f
--- utouch:  -10 foo.d
--- options:  foo.c
--- stdout
cp foo.e foo.c

--- stderr



=== TEST #5
--- source ditto
--- touch:  foo.f
--- utouch:  -10 foo.d
--- options:  foo.c
--- stdout preprocess
#MAKE#: `foo.c' is up to date.

--- stderr



=== TEST #6
--- source ditto
--- touch:  foo.f
--- utouch
-10 foo.c
-10 foo.d
--- options:  foo.c
--- stdout
cp foo.f foo.e
cp foo.e foo.c

--- stderr



=== TEST #7 -- test the "global" .SECONDARY, with no targets.
--- source
.SECONDARY:

final: intermediate
intermediate: source

final intermediate source:
	echo $< > $@

--- touch:  final
--- utouch:  -10 source
--- stdout preprocess
#MAKE#: `final' is up to date.

--- stderr



=== TEST #8 -- test the "global" .SECONDARY, with .PHONY.
--- source

.PHONY: version
.SECONDARY:
version2: version ; @echo GOOD
all: version2
--- touch:  version2
--- goals:  all
--- stdout
GOOD
--- stderr
--- error_code:  0

