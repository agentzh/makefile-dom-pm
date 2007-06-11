# Description:
#    The following tests rules without Commands or Dependencies.
#
# Details:
#    If the rule ...


use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
Create a file named "clean".  This is the same name as the target clean
and tricks the target into thinking that it is up to date.  (Unless you
use the .PHONY target.

--- source
.IGNORE :
clean: FORCE
	rm clean
FORCE:

--- touch:  clean
--- goals:  clean
--- stdout
rm clean

--- stderr

