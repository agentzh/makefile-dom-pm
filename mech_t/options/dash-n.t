# Description:
#    Test the -n option.

#
# Details:
#    Try various uses of -n and ensure they all give the correct results.


use t::Gmake;

plan tests => 3 * blocks() - 4;

use_source_ditto;

run_tests;

__DATA__

=== TEST 0
--- source

final: intermediate ; echo >> $@
intermediate: orig ; echo >> $@


--- touch:  orig
--- stdout
echo >> intermediate
echo >> final

--- stderr



=== TEST 1
--- source ditto
--- touch:  orig
--- options:  -Worig -n
--- stdout
echo >> intermediate
echo >> final

--- stderr



=== TEST 2
We consider the actual updated timestamp of targets with all
recursive commands, even with -n.

--- source
.SUFFIXES:
BAR =     # nothing
FOO = +$(BAR)
a: b; echo > $@
b: c; $(FOO)

--- touch:  c
--- utouch
-10 a
-20 b
--- stdout preprocess
#MAKE#: `a' is up to date.

--- stderr



=== TEST 3
--- source ditto
--- touch:  c
--- utouch
-10 a
-20 b
--- options:  -n
--- stdout preprocess
#MAKE#: `a' is up to date.

--- stderr

