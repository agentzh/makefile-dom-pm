# Description:
#    The following test creates a makefile to test that a 
#     rule with multiple targets is equivalent to writing 
#    many rules, each with one target, and all identical aside
#    from that.
#
# Details:
#    A makefile is created with one rule and two targets.  Make 
#    is called twice, once for each target, and the output which 
#    contains the target name with $@ is looked at for the changes.
#    This test also tests the substitute function by replacing 
#    the word output with nothing in the target name giving either
#    an output of "I am little" or "I am big"

use t::Gmake;

plan tests => 3 * blocks() - 2;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source
bigoutput littleoutput: test.h
	@echo I am $(subst output,,$@)

--- touch:  test.h
--- goals:  bigoutput
--- stdout
I am big

--- stderr



=== TEST 2:
--- source ditto
--- touch:  test.h
--- goals:  littleoutput
--- stdout
I am little

--- stderr

