# Description:
#    Test various flavors of make variable setting.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 9;

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
--- source
foo = $(bar)
bar = ${ugh}
ugh = Hello

all: multi ; @echo $(foo)

multi: ; $(multi)

x := foo
y := $(x) bar
x := later

nullstring :=
space := $(nullstring) $(nullstring)

next: ; @echo $x$(space)$y

define multi
@echo hi
echo there
endef

ifdef BOGUS
define
@echo error
endef
endif

define outer
 define inner
  A = B
 endef
endef

$(eval $(outer))

outer: ; @echo $(inner)


--- stdout
hi
echo there
there
Hello

--- stderr



=== TEST #2
--- source ditto
--- goals:  next
--- stdout
later foo bar

--- stderr



=== TEST #3
--- filename:  test.mk
--- source ditto
--- options:  BOGUS=true
--- stdout

--- stderr
test.mk:24: *** empty variable name.  Stop.

--- error_code:  2



=== TEST #4
--- source ditto
--- goals:  outer
--- stdout
A = B

--- stderr



=== TEST #5
Clean up from "old style" testing.  If all the above tests are converted to
run_make_test() syntax than this line can be removed.
Make sure that prefix characters apply properly to define/endef values.
There's a bit of oddness here if you try to use a variable to hold the
prefix character for a define.  Even though something like this:
define foo
echo bar
endef
all: ; 1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4V)1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4foo)
(where V=@) can be seen by the user to be obviously different than this:
define foo
1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4V)echo bar
endef
all: ; 1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4foo)
and the user thinks it should behave the same as when the "@" is literal
instead of in a variable, that can't happen because by the time make
expands the variables for the command line and sees it begins with a "@" it
can't know anymore whether the prefix character came before the variable
reference or was included in the first line of the variable reference.

--- source

define FOO
$(V1)echo hello
$(V2)echo world
endef
all: ; @$(FOO)

--- stdout
hello
world
--- stderr



=== TEST #6
--- source ditto
--- options:  V1=@ V2=@
--- stdout
hello
world
--- stderr



=== TEST #7
--- source

define FOO
$(V1)echo hello
$(V2)echo world
endef
all: ; $(FOO)

--- options:  V1=@
--- stdout
hello
echo world
world
--- stderr



=== TEST #8
--- source ditto
--- options:  V2=@
--- stdout
echo hello
hello
world
--- stderr



=== TEST #9
--- source ditto
--- options:  V1=@ V2=@
--- stdout
hello
world
--- stderr



=== TEST #10
Test the basics; a "@" internally to the variable applies to only one line.
A "@" before the variable applies to the entire variable.

--- source

define FOO
@echo hello
echo world
endef
define BAR
echo hello
echo world
endef

all: foo bar
foo: ; $(FOO)
bar: ; @$(BAR)

--- stdout
hello
echo world
world
hello
world

--- stderr

