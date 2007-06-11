# Description:
#    Test generic option processing.

#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1
This test prints the usage string; I don't really know a good way to
test it.  I guess I could invoke make with a known-bad option to see
what the usage looks like, then compare it to what I get here... :(
If I were always on UNIX, I could invoke it with 2>/dev/null, then
just check the error code.

--- source
foo 1foo: ; @echo $@

--- options:  -j1foo 2>/dev/null
--- stdout
--- stderr
--- error_code:  2

