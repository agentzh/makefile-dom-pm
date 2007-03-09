#: mult_targets.t
#:
#: Description:
#:   The following test creates a makefile to test that a
#:   rule with multiple targets is equivalent to writing
#:   many rules, each with one target, and all identical aside
#:   from that.
#: Details:
#:   A makefile is created with one rule and two targets.  Make
#:   is called twice, once for each target, and the output which
#:   contains the target name with $@ is looked at for the changes.
#:   This test also tests the substitute function by replacing
#:   the word output with nothing in the target name giving either
#:   an output of "I am little" or "I am big"
#:
#: 2006-02-11 2006-02-11

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 0
--- source
bigoutput littleoutput: test.h
	@echo I am $(subst output,,$@)
--- touch:        test.h
--- goals:        bigoutput
--- stdout
I am big
--- stderr
--- success:      true



=== TEST 1
--- source
bigoutput littleoutput: test.h
	@echo I am $(subst output,,$@)
--- touch:        test.h
--- goals:        littleoutput
--- stdout
I am little
--- stderr
--- success:      true
