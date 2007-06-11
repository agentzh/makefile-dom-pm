# Description:
#    Test the .DEFAULT_GOAL special variable.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 2;

run_tests;

__DATA__

=== Test #1: basic logic.
--- source

# Basics.
#
foo: ; @:

ifneq ($(.DEFAULT_GOAL),foo)
$(error )
endif

# Reset to empty.
#
.DEFAULT_GOAL :=

bar: ; @:

ifneq ($(.DEFAULT_GOAL),bar)
$(error )
endif

# Change to a different goal.
#

.DEFAULT_GOAL := baz

baz: ; @echo $@

--- stdout
baz
--- stderr



=== Test #2: unknown goal.
--- source

.DEFAULT_GOAL = foo

--- stdout

--- stderr preprocess
#MAKE#: *** No rule to make target `foo'.  Stop.
--- error_code:  2



=== Test #3: more than one goal.
--- source

.DEFAULT_GOAL := foo bar

--- stdout

--- stderr preprocess
#MAKE#: *** .DEFAULT_GOAL contains more than one target.  Stop.
--- error_code:  2



=== Test #4: Savannah bug #12226.
--- source

define rule
foo: ; @echo $$@
endef

define make-rule
$(eval $(rule))
endef

$(call make-rule)


--- stdout
foo
--- stderr

