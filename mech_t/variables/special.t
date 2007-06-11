# Description:
#    Test special GNU make variables.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source


X1 := $(sort $(filter FOO BAR,$(.VARIABLES)))

FOO := foo

X2 := $(sort $(filter FOO BAR,$(.VARIABLES)))

BAR := bar

all:
	@echo X1 = $(X1)
	@echo X2 = $(X2)
	@echo LAST = $(sort $(filter FOO BAR,$(.VARIABLES)))

--- stdout
X1 =
X2 = FOO
LAST = BAR FOO

--- stderr

