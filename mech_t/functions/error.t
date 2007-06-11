# Description:
#    
#    The following test creates a makefile to test the error function.
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
err = $(error Error found!)

ifdef ERROR1
$(error error is $(ERROR1))
endif

ifdef ERROR2
$(error error is $(ERROR2))
endif

ifdef ERROR3
all: some; @echo $(error error is $(ERROR3))
endif

ifdef ERROR4
all: some; @echo error is $(ERROR4)
	@echo $(error error is $(ERROR4))
endif

some: ; @echo Some stuff

testvar: ; @: $(err)

--- options:  ERROR1=yes
--- stdout
--- stderr
test.mk:4: *** error is yes.  Stop.

--- error_code:  2



=== Test #2
--- filename:  test.mk
--- source ditto
--- options:  ERROR2=no
--- stdout
--- stderr
test.mk:8: *** error is no.  Stop.

--- error_code:  2



=== Test #3
--- filename:  test.mk
--- source ditto
--- options:  ERROR3=maybe
--- stdout
Some stuff

--- stderr
test.mk:12: *** error is maybe.  Stop.

--- error_code:  2



=== Test #4
--- filename:  test.mk
--- source ditto
--- options:  ERROR4=definitely
--- stdout
Some stuff

--- stderr
test.mk:16: *** error is definitely.  Stop.

--- error_code:  2



=== Test #5
--- filename:  test.mk
--- source ditto
--- goals:  testvar
--- stdout
--- stderr
test.mk:22: *** Error found!.  Stop.

--- error_code:  2

