# Description:
#    Test the MAKECMDGOALS variable.
#
# Details:
#    
#    We construct a makefile with various targets, all of which print out
#    $(MAKECMDGOALS), then call it different ways.

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
--- source

.DEFAULT all:
	@echo $(MAKECMDGOALS)

--- stdout eval:  "\n"
--- stderr
--- error_code:  0



=== TEST #2
--- source ditto
--- goals:  all
--- stdout
all

--- stderr
--- error_code:  0



=== TEST #3
--- source ditto
--- goals:  foo bar baz yaz
--- stdout
foo bar baz yaz
foo bar baz yaz
foo bar baz yaz
foo bar baz yaz

--- stderr
--- error_code:  0

