# Description:
#    Test the addsuffix function.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 2;

use_source_ditto;

run_tests;

__DATA__

=== TEST 0
--- source
string := $(addsuffix .c,src/a.b.z.foo hacks)
one: ; @echo $(string)

two: ; @echo $(addsuffix foo,)

--- stdout
src/a.b.z.foo.c hacks.c

--- stderr



=== TEST 1
--- source ditto
--- goals:  two
--- stdout eval:  "\n"
--- stderr

