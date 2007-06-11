# Description:
#    
#    The following test creates a makefile to test the warning function.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== Test #1
--- filename:  test.mk
--- source
ifdef WARNING1
$(warning warning is $(WARNING1))
endif

ifdef WARNING2
$(warning warning is $(WARNING2))
endif

ifdef WARNING3
all: some; @echo hi $(warning warning is $(WARNING3))
endif

ifdef WARNING4
all: some; @echo hi
	@echo there $(warning warning is $(WARNING4))
endif

some: ; @echo Some stuff


--- options:  WARNING1=yes
--- stdout
Some stuff

--- stderr
test.mk:2: warning is yes

--- error_code:  0



=== Test #2
--- filename:  test.mk
--- source ditto
--- options:  WARNING2=no
--- stdout
Some stuff

--- stderr
test.mk:6: warning is no

--- error_code:  0



=== Test #3
--- filename:  test.mk
--- source ditto
--- options:  WARNING3=maybe
--- stdout
Some stuff
hi

--- stderr
test.mk:10: warning is maybe

--- error_code:  0



=== Test #4
--- filename:  test.mk
--- source ditto
--- options:  WARNING4=definitely
--- stdout
Some stuff
hi
there

--- stderr
test.mk:14: warning is definitely

--- error_code:  0

