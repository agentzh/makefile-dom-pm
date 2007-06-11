# Description:
#    The following test tests that if you specify greater 
#    than one '-f makefilename' on the command line, 
#    that make concatenates them.  This test creates three 
#    makefiles and specifies all of them with the -f option 
#    on the command line.  To make sure they were concatenated, 
#    we then call make with the rules from the concatenated 
#    makefiles one at a time.  Finally, it calls all three 
#    rules in one call to make and checks that the output
#    is in the correct order.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
Create a second makefile
Create a third makefile
Run make to catch the default rule

--- filename:  test.mk
--- source
THREE: 
	@echo This is the output from makefile 3

--- options:  -f test.mk -f test.mk
--- stdout
This is the output from the original makefile

--- stderr
--- error_code:  0



=== TEST 2:
Run Make again with the rule from the second makefile: TWO

--- filename:  test.mk
--- source ditto
--- goals:  TWO
--- options:  -f test.mk -f test.mk
--- stdout
This is the output from makefile 2

--- stderr
--- error_code:  0



=== TEST 3:
Run Make again with the rule from the third makefile: THREE

--- filename:  test.mk
--- source ditto
--- goals:  THREE
--- options:  -f test.mk -f test.mk
--- stdout
This is the output from makefile 3

--- stderr
--- error_code:  0



=== TEST 4:
Run Make again with ALL three rules in the order 2 1 3 to make sure
that all rules are executed in the proper order

--- filename:  test.mk
--- source ditto
--- goals:  TWO all THREE
--- options:  -f test.mk -f test.mk
--- stdout
This is the output from makefile 2
This is the output from the original makefile
This is the output from makefile 3

--- stderr
--- error_code:  0

