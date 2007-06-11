# Description:
#    Test the value function.
#
# Details:
#    This is a test of the value function in GNU make.
#    This function will evaluate to the value of the named variable with no
#    further expansion performed on it.


use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
export FOO = foo

recurse = FOO = $FOO
static := FOO = $(value FOO)

all: ; @echo $(recurse) $(value recurse) $(static) $(value static)

--- stdout
FOO = OO FOO = foo FOO = foo FOO = foo

--- stderr

