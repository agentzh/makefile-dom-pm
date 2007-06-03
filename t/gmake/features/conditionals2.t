#: conditionals2.t
#: 2006-02-10 2006-02-10

use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: what if we escape the single quote in `ifdef' by a backslash?
--- filename:        foo
--- source
arg3 = third
arg4 = cc

all:
ifneq \'$(arg3)\' \'$(arg4)\'
	@echo arg3 NOT equal arg4
else
	@echo arg3 equal arg4
endif

--- stdout
--- stderr
foo:5: *** invalid syntax in conditional.  Stop.
--- success:        false



=== TEST 1: what if we escape the single quote in `else ifdef' by a backslash?
--- filename:        baz.mk
--- source
arg1 = first
arg2 = second
arg5 = fifth

result =

ifeq ($(arg1),$(arg2))
  result += arg1 equals arg2
else ifeq \'$(arg2)\' "$(arg5)"
  result += arg2 equals arg5
else
  result += success
endif

all: ; @echo $(result)

--- stdout
--- stderr_like
baz\.mk:9: Extraneous text after `else' directive
(.|\n)*
--- success:        false



=== TEST 2: what if we omit the parentheses for `ifeq'?
--- filename:       Makefile
--- source
arg1 = first
arg2 = second

all:
ifeq $(arg1), $(arg2)
	@echo arg1 equals arg2
else
	@echo arg1 NOT equal arg2
endif

--- stdout
--- stderr
Makefile:5: *** invalid syntax in conditional.  Stop.
--- success:        false



=== TEST 3: what if we omit the quotes completely?
--- filename:       bar
--- source
arg3 = third
arg4 = cc

all:
ifneq '$(arg3)' $(arg4)
	@echo arg3 NOT equal arg4
else
	@echo arg3 equal to arg4
endif

--- stdout
--- stderr
bar:5: *** invalid syntax in conditional.  Stop.
--- success:        false



=== TEST 4: Does it matter if we add redundant quotes to the `ifndef' directive?
--- source
undefined = blah blah blah
all:
ifndef 'undefined'
	@echo variable $('undefined') is undefined
else
	@echo variable undefined is defined
endif
--- stdout
variable is undefined
--- stderr
--- success:        true



=== TEST 5: Is the whitespace after the `ifeq' directive critical?
--- filename:       foo
--- source
arg1 = first
arg2 = second

all:
ifeq($(arg1),$(arg2))
	@echo arg1 equals arg2
else
	@echo arg1 NOT equal arg2
endif

--- stdout
--- stderr
foo:5: *** missing separator.  Stop.
--- success:        false



=== TEST 6: Is the whitespace between the two quoted arguments critical?
--- filename:       bar
--- source
arg1 = first
arg2 = second

all:
ifeq '$(arg1)''$(arg2)'
	@echo arg1 equals arg2
else
	@echo arg1 NOT equal arg5
endif
--- stdout
arg1 NOT equal arg5
--- stderr
--- success:        true



=== TEST 7: Can we indent variable definitions by tabs?
--- source
	arg1 = first
all: ; @echo $(arg1)
--- stdout
first
--- stderr
--- success:        true



=== TEST 8: White space in target name apparently is not allowed, but what if whitespace in variable names?
--- source
a b = A B
all: ; @echo $(a b)
--- stdout
A B
--- stderr
--- success:        true



=== TEST 9: variable expansion happened like C/C++ macros, no?
--- source
rule = all: h1.h h2.h
$(rule)
	@echo building all...

h1.h: ; @echo h1.h
h2.h: ; @echo h2.h
--- stdout
h1.h
h2.h
building all...
--- stderr
--- success:       true


=== TEST 10: ditto, but trickier
--- source
rule = all:

$(rule)
	@echo building all...

h1.h: ; @echo h1.h
h2.h: ; @echo h2.h

rule = all: h1.h h2.h
--- stdout
building all...
--- stderr
--- success:       true



=== TEST 11: ditto, using chained varaibles
--- source
rule = all:
rule2 = $(rule)

$(rule2)
	@echo building all...

h1.h: ; @echo h1.h
h2.h: ; @echo h2.h

rule = all: h1.h h2.h
--- stdout
building all...
--- stderr
--- success:       true
