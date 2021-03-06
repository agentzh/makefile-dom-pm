# Description:
#    Test the realpath functions.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
--- source

ifneq ($(realpath .),$(CURDIR))
  $(error )
endif

ifneq ($(realpath ./),$(CURDIR))
  $(error )
endif

ifneq ($(realpath .///),$(CURDIR))
  $(error )
endif

ifneq ($(realpath /),/)
  $(error )
endif

ifneq ($(realpath /.),/)
  $(error )
endif

ifneq ($(realpath /./),/)
  $(error )
endif

ifneq ($(realpath /.///),/)
  $(error )
endif

ifneq ($(realpath /..),/)
  $(error )
endif

ifneq ($(realpath /../),/)
  $(error )
endif

ifneq ($(realpath /..///),/)
  $(error )
endif

ifneq ($(realpath . /..),$(CURDIR) /)
  $(error )
endif

.PHONY: all
all: ; @:

--- stdout
--- stderr
--- error_code:  0



=== TEST 2:
On Windows platforms, "//" means something special.  So, don't do these
tests there.

--- source

ifneq ($(realpath ///),/)
  $(error )
endif

ifneq ($(realpath ///.),/)
  $(error )
endif

ifneq ($(realpath ///..),/)
  $(error )
endif

.PHONY: all
all: ; @:
--- stdout
--- stderr
--- error_code:  0

