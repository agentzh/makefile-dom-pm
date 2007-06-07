#: conditionals.t
#:
#: Description:
#:   Check GNU make conditionals.
#: Details:
#:   Attempt various different flavors of GNU make conditionals.
#:
#: 2006-01-29 2006-02-10

use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 0:
--- source

objects = foo.obj
arg1 = first
arg2 = second
arg3 = third
arg4 = cc
arg5 = second

all:
ifeq ($(arg1),$(arg2))
	@echo arg1 equals arg2
else
	@echo arg1 NOT equal arg2
endif

ifeq '$(arg2)' "$(arg5)"
	@echo arg2 equals arg5
else
	@echo arg2 NOT equal arg5
endif

ifneq '$(arg3)' '$(arg4)'
	@echo arg3 NOT equal arg4
else
	@echo arg3 equal arg4
endif

ifndef undefined
	@echo variable is undefined
else
	@echo variable undefined is defined
endif
ifdef arg4
	@echo arg4 is defined
else
	@echo arg4 is NOT defined
endif

--- stdout
arg1 NOT equal arg2
arg2 equals arg5
arg3 NOT equal arg4
variable is undefined
arg4 is defined
--- stderr
--- success:        true



=== TEST 1: Test expansion of variables inside ifdef
The following test is rejected by GNU make 3.80,
but is accepted by version 3.81 beta4
--- source
foo = 1

FOO = foo
F = f

DEF = no
DEF2 = no

ifdef $(FOO)
DEF = yes
endif

ifdef $(F)oo
DEF2 = yes
endif


DEF3 = no
FUNC = $1
ifdef $(call FUNC,DEF)3
  DEF3 = yes
endif

all:; @echo DEF=$(DEF) DEF2=$(DEF2) DEF3=$(DEF3)
--- stdout
DEF=yes DEF2=yes DEF3=yes
--- stderr
--- success:        true



=== TEST 2: Test all the different "else if..." constructs
--- source
arg1 = first
arg2 = second
arg3 = third
arg4 = cc
arg5 = fifth

result =

ifeq ($(arg1),$(arg2))
  result += arg1 equals arg2
else ifeq '$(arg2)' "$(arg5)"
  result += arg2 equals arg5
else ifneq '$(arg3)' '$(arg3)'
  result += arg3 NOT equal arg4
else ifndef arg5
  result += variable is undefined
else ifdef undefined
  result += arg4 is defined
else
  result += success
endif


all: ; @echo $(result)
--- stdout
success
--- stderr
--- success:        true


=== TEST 3: Test some random "else if..." construct nesting
--- source

arg1 = first
arg2 = second
arg3 = third
arg4 = cc
arg5 = second

ifeq ($(arg1),$(arg2))
  $(info failed 1)
else ifeq '$(arg2)' "$(arg2)"
  ifdef undefined
    $(info failed 2)
  else
    $(info success)
  endif
else ifneq '$(arg3)' '$(arg3)'
  $(info failed 3)
else ifdef arg5
  $(info failed 4)
else ifdef undefined
  $(info failed 5)
else
  $(info failed 6)
endif

.PHONY: all
all: ; @:

--- stdout
success
--- stderr
--- error_code: 0

