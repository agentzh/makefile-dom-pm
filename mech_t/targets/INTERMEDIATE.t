# Description:
#    Test the behaviour of the .INTERMEDIATE target.
#
# Details:
#    
#    Test the behavior of the .INTERMEDIATE special target.
#    Create a makefile where a file would not normally be considered
#    intermediate, then specify it as .INTERMEDIATE.  Build and ensure it's
#    deleted properly.  Rebuild to ensure that it's not created if it doesn't
#    exist but doesn't need to be built.  Change the original and ensure
#    that the intermediate file and the ultimate target are both rebuilt, and
#    that the intermediate file is again deleted.
#    
#    Try this with implicit rules and explicit rules: both should work.


use t::Gmake;

plan tests => 3 * blocks() - 8;

use_source_ditto;

run_tests;

__DATA__

=== TEST #0
--- source

.INTERMEDIATE: foo.e bar.e

# Implicit rule test
%.d : %.e ; cp $< $@
%.e : %.f ; cp $< $@

foo.d: foo.e

# Explicit rule test
foo.c: foo.e bar.e; cat $^ > $@

--- utouch
-20 bar.f
-20 foo.f
--- options:  foo.d
--- stdout
cp foo.f foo.e
cp foo.e foo.d
rm foo.e

--- stderr



=== TEST #1
--- source ditto
--- utouch
-20 bar.f
-20 foo.f
--- options:  foo.d
--- stdout preprocess
#MAKE#: `foo.d' is up to date.

--- stderr



=== TEST #2
--- source ditto
--- touch:  foo.f
--- utouch
-20 bar.f
-10 foo.d
--- options:  foo.d
--- stdout
cp foo.f foo.e
cp foo.e foo.d
rm foo.e

--- stderr



=== TEST #3
--- source ditto
--- touch:  foo.f
--- utouch
-20 bar.f
-10 foo.d
--- options:  foo.c
--- stdout
cp foo.f foo.e
cp bar.f bar.e
cat foo.e bar.e > foo.c
rm bar.e foo.e

--- stderr



=== TEST #4
--- source ditto
--- touch:  foo.f
--- utouch
-20 bar.f
-10 foo.d
--- options:  foo.c
--- stdout preprocess
#MAKE#: `foo.c' is up to date.

--- stderr



=== TEST #5
--- source ditto
--- touch:  foo.f
--- utouch
-10 foo.c
-20 bar.f
-10 foo.d
--- options:  foo.c
--- stdout
cp foo.f foo.e
cp bar.f bar.e
cat foo.e bar.e > foo.c
rm bar.e foo.e

--- stderr



=== TEST #6 -- added for PR/1669: don't remove files mentioned on the cmd line.
--- source ditto
--- touch:  foo.f
--- utouch
-10 foo.c
-20 bar.f
-10 foo.d
--- options:  foo.e
--- stdout
cp foo.f foo.e

--- stderr



=== TEST #7 -- added for PR/1423
--- source
all: foo
foo.a: ; touch $@
%: %.a ; touch $@
.INTERMEDIATE: foo.a

--- options:  -R
--- stdout
touch foo.a
touch foo
rm foo.a

--- stderr

