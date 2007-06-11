# Description:
#    Run some negative tests (things that should fail).
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST #0
Check that non-terminated variable references are detected (and
reported using the best filename/lineno info

--- source

foo = bar
x = $(foo
y = $x

all: ; @echo $y

--- stdout

--- stderr preprocess
#MAKEFILE#:2: *** unterminated variable reference.  Stop.
--- error_code:  2



=== TEST #1
Bogus variable value passed on the command line.

--- source ditto
--- options:  x=$(other
--- stdout

--- stderr preprocess
#MAKEFILE#:3: *** unterminated variable reference.  Stop.
--- error_code:  2



=== TEST #2
Again, but this time while reading the makefile.

--- source

foo = bar
x = $(foo
y = $x

z := $y

all: ; @echo $y

--- stdout

--- stderr preprocess
#MAKEFILE#:2: *** unterminated variable reference.  Stop.
--- error_code:  2



=== TEST #3
Bogus variable value passed on the command line.

--- source ditto
--- options:  x=$(other
--- stdout

--- stderr preprocess
#MAKEFILE#:3: *** unterminated variable reference.  Stop.
--- error_code:  2

