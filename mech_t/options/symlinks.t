# Description:
#    Test the -L option.
#
# Details:
#    Verify that symlink handling with and without -L works properly.

use t::Gmake;

plan tests => 3 * blocks() - 9;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
Only run these tests if the system sypports symlinks
Apparently the Windows port of Perl reports that it does support symlinks
(in that the symlink() function doesn't fail) but it really doesn't, so
check for it explicitly.

--- source
targ: sym ; @echo make $@ from $<
--- utouch
-5 targ
-10 dep
--- stdout preprocess
#MAKE#: `targ' is up to date.
--- stderr



=== TEST 2:
--- source ditto
--- utouch
-5 targ
-10 dep
--- options:  -L
--- stdout
make targ from sym
--- stderr



=== TEST 3:
--- source ditto
--- touch:  dep
--- utouch:  -5 targ
--- stdout
make targ from sym
--- stderr



=== TEST 4:
--- source ditto
--- touch:  dep
--- utouch:  -5 targ
--- options:  -L
--- stdout
make targ from sym
--- stderr



=== TEST 5:
--- source ditto
--- touch:  targ dep
--- stdout preprocess
#MAKE#: `targ' is up to date.
--- stderr



=== TEST 6:
--- source ditto
--- touch:  targ dep
--- options:  -L
--- stdout preprocess
#MAKE#: `targ' is up to date.
--- stderr



=== TEST 7:
--- source ditto
--- touch:  targ dep
--- stdout preprocess
#MAKE#: `targ' is up to date.
--- stderr



=== TEST 8:
--- source ditto
--- touch:  targ dep
--- options:  -L
--- stdout
make targ from sym
--- stderr



=== TEST 9:
--- source ditto
--- stdout

--- stderr preprocess
#MAKE#: *** No rule to make target `sym', needed by `targ'.  Stop.
--- error_code:  2



=== TEST 10:
--- source ditto
--- options:  -L
--- stdout
make targ from sym
--- stderr

