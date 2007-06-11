# Description:
#    Test the flavor function.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== Test #1: Test general logic.
--- source

s := s
r = r

$(info u $(flavor u))
$(info s $(flavor s))
$(info r $(flavor r))

ra += ra
rc ?= rc

$(info ra $(flavor ra))
$(info rc $(flavor rc))

s += s
r += r

$(info s $(flavor s))
$(info r $(flavor r))


.PHONY: all
all:;@:

--- stdout
u undefined
s simple
r recursive
ra recursive
rc recursive
s simple
r recursive
--- stderr
--- error_code:  0

