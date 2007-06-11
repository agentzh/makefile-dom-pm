# Description:
#    Test the -q option.

#
# Details:
#    Try various uses of -q and ensure they all give the correct results.


use t::Gmake;

plan tests => 3 * blocks() - 5;

use_source_ditto;

run_tests;

__DATA__

=== TEST 0
--- source

one:
two: ;
three: ; :
four: ; $(.XY)
five: ; \
 $(.XY)
six: ; \
 $(.XY)
	$(.XY)
seven: ; \
 $(.XY)
	: foo
	$(.XY)

--- goals:  one
--- options:  -q
--- stdout

--- stderr



=== TEST 1
--- source ditto
--- goals:  two
--- options:  -q
--- stdout

--- stderr



=== TEST 2
--- source ditto
--- goals:  three
--- options:  -q
--- stdout

--- stderr
--- error_code:  1



=== TEST 3
--- source ditto
--- goals:  four
--- options:  -q
--- stdout

--- stderr



=== TEST 4
--- source ditto
--- goals:  five
--- options:  -q
--- stdout

--- stderr



=== TEST 5
--- source ditto
--- goals:  six
--- options:  -q
--- stdout

--- stderr



=== TEST 6
--- source ditto
--- goals:  seven
--- options:  -q
--- stdout

--- stderr
--- error_code:  1



=== TEST 7 : Savannah bug # 7144
--- source

one:: ; @echo one
one:: ; @echo two

--- options:  -q
--- stdout

--- stderr
--- error_code:  1

