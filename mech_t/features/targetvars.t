# Description:
#    Test target-specific variable settings.
#
# Details:
#    
#    Create a makefile containing various flavors of target-specific variable
#    values, override and non-override, and using various variable expansion
#    rules, semicolon interference, etc.

use t::Gmake;

plan tests => 3 * blocks() - 20;

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
--- source
SHELL = /bin/sh
export FOO = foo
export BAR = bar
one: override FOO = one
one two: ; @echo $(FOO) $(BAR)
two: BAR = two
three: ; BAR=1000
	@echo $(FOO) $(BAR)
# Some things that shouldn't be target vars
funk : override
funk : override adelic
adelic override : ; echo $@
# Test per-target recursive variables
four:FOO=x
four:VAR$(FOO)=ok
four: ; @echo '$(FOO) $(VAR$(FOO)) $(VAR) $(VARx)'
five:FOO=x
five six : VAR$(FOO)=good
five six: ;@echo '$(FOO) $(VAR$(FOO)) $(VAR) $(VARx) $(VARfoo)'
# Test per-target variable inheritance
seven: eight
seven eight: ; @echo $@: $(FOO) $(BAR)
seven: BAR = seven
seven: FOO = seven
eight: BAR = eight
# Test the export keyword with per-target variables
nine: ; @echo $(FOO) $(BAR) $$FOO $$BAR
nine: FOO = wallace
nine-a: export BAZ = baz
nine-a: ; @echo $$BAZ
# Test = escaping
EQ = =
ten: one\=two
ten: one \= two
ten one$(EQ)two $(EQ):;@echo $@
.PHONY: one two three four five six seven eight nine ten $(EQ) one$(EQ)two
# Test target-specific vars with pattern/suffix rules
QVAR = qvar
RVAR = =
%.q : ; @echo $(QVAR) $(RVAR)
foo.q : RVAR += rvar
# Target-specific vars with multiple LHS pattern rules
%.r %.s %.t: ; @echo $(QVAR) $(RVAR) $(SVAR) $(TVAR)
foo.r : RVAR += rvar
foo.t : TVAR := $(QVAR)

--- goals:  one two three
--- stdout
one bar
foo two
BAR=1000
foo bar

--- stderr



=== TEST #2
--- source ditto
--- goals:  one two
--- options:  FOO=1 BAR=2
--- stdout
one 2
1 2

--- stderr



=== TEST #3
--- source ditto
--- goals:  four
--- stdout
x ok  ok

--- stderr



=== TEST #4
--- source ditto
--- goals:  seven
--- stdout
eight: seven eight
seven: seven seven

--- stderr



=== TEST #5
--- source ditto
--- goals:  nine
--- stdout
wallace bar wallace bar

--- stderr



=== TEST #5-a
--- source ditto
--- options:  nine-a
--- stdout
baz

--- stderr



=== TEST #6
--- source ditto
--- goals:  ten
--- stdout
one=two
one bar
=
foo two
ten

--- stderr



=== TEST #6
--- source ditto
--- options:  foo.q bar.q
--- stdout
qvar = rvar
qvar =

--- stderr



=== TEST #7
--- source ditto
--- options:  foo.t bar.s
--- stdout
qvar = qvar
qvar =

--- stderr



=== TEST #8
For PR/1378: Target-specific vars don't inherit correctly

--- source
foo: FOO = foo
bar: BAR = bar
foo: bar
bar: baz
baz: ; @echo $(FOO) $(BAR)

--- stdout
foo bar

--- stderr



=== TEST #9
For PR/1380: Using += assignment in target-specific variables sometimes fails
Also PR/1831

--- source
.PHONY: all one
all: FOO += baz
all: one; @echo $(FOO)

FOO = bar

one: FOO += biz
one: FOO += boz
one: ; @echo $(FOO)

--- stdout
bar baz biz boz
bar baz

--- stderr



=== Test #10
--- source ditto
--- goals:  one
--- stdout
bar biz boz

--- stderr



=== Test #11
PR/1709: Test semicolons in target-specific variable values

--- source
foo : FOO = ; ok
foo : ; @echo '$(FOO)'

--- stdout
; ok

--- stderr



=== Test #12
PR/2020: More hassles with += target-specific vars.  I _really_ think
I nailed it this time :-/.

--- source
.PHONY: a

BLAH := foo
COMMAND = echo $(BLAH)

a: ; @$(COMMAND)

a: BLAH := bar
a: COMMAND += snafu $(BLAH)

--- stdout
bar snafu bar

--- stderr



=== Test #13
Test double-colon rules with target-specific variable values

--- source
W = bad
X = bad
foo: W = ok
foo:: ; @echo $(W) $(X) $(Y) $(Z)
foo:: ; @echo $(W) $(X) $(Y) $(Z)
foo: X = ok

Y = foo
bar: foo
bar: Y = bar

Z = nopat
ifdef PATTERN
  fo% : Z = pat
endif


--- goals:  foo
--- stdout
ok ok foo nopat
ok ok foo nopat

--- stderr



=== Test #14
Test double-colon rules with target-specific variable values and
inheritance

--- source ditto
--- goals:  bar
--- stdout
ok ok bar nopat
ok ok bar nopat

--- stderr



=== Test #15
Test double-colon rules with pattern-specific variable values

--- source ditto
--- goals:  foo
--- options:  PATTERN=yes
--- stdout
ok ok foo pat
ok ok foo pat

--- stderr



=== Test #16
Test target-specific variables with very long command line
(> make default buffer length)

--- source
base_metals_fmd_reports.sun5 base_metals_fmd_reports CreateRealPositions        CreateMarginFunds deals_changed_since : BUILD_OBJ=$(shell if [ -f               "build_information.generate" ]; then echo "$(OBJ_DIR)/build_information.o"; else echo "no build information"; fi  )

deals_changed_since: ; @echo $(BUILD_OBJ)


--- stdout
no build information

--- stderr



=== TEST #17
Test a merge of set_lists for files, where one list is much longer
than the other.  See Savannah bug #15757.

--- source

VPATH = t1
include rules.mk
.PHONY: all
all: foo.x
foo.x : rules.mk ; @echo MYVAR=$(MYVAR) FOOVAR=$(FOOVAR) ALLVAR=$(ALLVAR)
all: ALLVAR = xxx
foo.x: FOOVAR = bar
rules.mk : MYVAR = foo
.INTERMEDIATE: foo.x rules.mk

--- touch:  t1/rules.mk
--- goals:  t1
--- options:  -I
--- stdout
MYVAR= FOOVAR=bar ALLVAR=xxx
--- stderr



=== TEST #18
Test appending to a simple variable containing a " : avoid a
double-expansion.  See Savannah bug #15913.

--- source

VAR := $$FOO
foo: VAR += BAR
foo: ; @echo '$(VAR)'
--- stdout
$FOO BAR
--- stderr

