# Description:
#    Test the eval function.
#
# Details:
#    This is a test of the eval function in GNU make.
#    This function will evaluate inline makefile syntax and incorporate the
#    results into its internal database.


use t::Gmake;

plan tests => 3 * blocks() - 6;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source
define Y
  all:: ; @echo $AA
  A = B
endef

X = $(eval $(value Y))

$(eval $(shell echo A = A))
$(eval $(Y))
$(eval A = C)
$(eval $(X))

--- stdout
AA
BA

--- stderr



=== TEST 2:
Test to make sure defining variables when we have extra scope pushed works
as expected.

--- source
VARS = A B

VARSET = $(1) = $(2)

$(foreach v,$(VARS),$(eval $(call VARSET,$v,$v)))

all: ; @echo A = $(A) B = $(B)

--- stdout
A = A B = B

--- stderr



=== TEST 3:
Test to make sure eval'ing inside conditionals works properly

--- source
FOO = foo

all:: ; @echo it

define Y
  all:: ; @echo worked
endef

ifdef BAR
$(eval $(Y))
endif


--- stdout
it

--- stderr



=== TEST 4:
--- source ditto
--- options:  BAR=1
--- stdout
it
worked

--- stderr



=== TEST 5:
TEST very recursive invocation of eval

--- source
..9 := 0 1 2 3 4 5 6 7 8 9
rev=$(eval res:=)$(foreach word,$1,$(eval res:=${word} ${res}))${res}
a:=$(call rev,${..9})
all: ; @echo '[$(a)]'


--- stdout
[         9 8 7 6 5 4 3 2 1 0 ]

--- stderr



=== TEST 6:
TEST eval with no filename context.
The trick here is that because EVAR is taken from the environment, it must
be evaluated before every command is invoked.  Make sure that works, when
we have no file context for reading_file (bug # 6195)

--- source
EVAR = $(eval FOBAR = 1)
all: ; @echo "OK"



--- pre:  $::ExtraENV{'EVAR'} = '1';
--- stdout
OK

--- stderr



=== TEST 7:
Clean out previous information to allow new run_make_test() interface.
If we ever convert all the above to run_make_test() we can remove this line.
Test handling of backslashes in strings to be evaled.

--- source

define FOO
all: ; @echo hello \
world
endef
$(eval $(FOO))


--- pre:  $::ExtraENV{'EVAR'} = '1';
--- stdout
hello world
--- stderr
--- error_code:  0



=== TEST 8:
--- source

define FOO
all: ; @echo 'he\llo'
	@echo world
endef
$(eval $(FOO))


--- pre:  $::ExtraENV{'EVAR'} = '1';
--- stdout
he\llo
world
--- stderr
--- error_code:  0



=== TEST 9:
We don't allow new target/prerequisite relationships to be defined within a
command script, because these are evaluated after snap_deps() and that
causes lots of problems (like core dumps!)
See Savannah bug # 12124.

--- source
deps: ; $(eval deps: foo)

--- pre:  $::ExtraENV{'EVAR'} = '1';
--- stdout

--- stderr preprocess
#MAKEFILE#:1: *** prerequisites cannot be defined in command scripts.  Stop.
--- error_code:  2

