# Description:
#    Test the .INCLUDE_DIRS special variable.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 2;

run_tests;

__DATA__

=== Test #1: The content of .INCLUDE_DIRS depends on the platform for which
make was built. What we know for sure is that it shouldn't be
empty.

--- source

ifeq ($(.INCLUDE_DIRS),)
$(warning .INCLUDE_DIRS is empty)
endif

.PHONY: all
all:;@:

--- stdout

--- stderr



=== Test #2: Make sure -I paths end up in .INCLUDE_DIRS.
--- source

ifeq ($(dir),)
$(warning dir is empty)
endif

ifeq ($(filter $(dir),$(.INCLUDE_DIRS)),)
$(warning .INCLUDE_DIRS does not contain $(dir))
endif

.PHONY: all
all:;@:

--- options preprocess:  -I#PWD# dir=#PWD#
--- stdout

--- stderr

