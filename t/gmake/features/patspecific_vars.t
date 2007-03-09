#: patspecific_vars.t
#:
#: Description:
#:   Test pattern-specific variable settings.
#: Details:
#:   Create a makefile containing various flavors of pattern-specific variable
#:   settings, override and non-override, and using various variable expansion
#:   rules, semicolon interference, etc.
#:
#: 2006-02-12 2006-02-13

use t::Gmake;

plan tests => 3 * blocks();

our $source = <<'_EOC_';

all: one.x two.x three.x
FOO = foo
BAR = bar
BAZ = baz
one.x: override FOO = one
%.x: BAR = two
t%.x: BAR = four
thr% : override BAZ = three
one.x two.x three.x: ; @echo $@: $(FOO) $(BAR) $(BAZ)
four.x: baz ; @echo $@: $(FOO) $(BAR) $(BAZ)
baz: ; @echo $@: $(FOO) $(BAR) $(BAZ)

# test matching multiple patterns
a%: AAA = aaa
%b: BBB = ccc
a%: BBB += ddd
%b: AAA ?= xxx
%b: AAA += bbb
.PHONY: ab
ab: ; @echo $(AAA); echo $(BBB)

_EOC_

our $source2 = <<'_EOC_';

.PHONY: all

all: inherit := good $$t
all: bar baz

b%: pattern := good $$t

global := orginal $$t


# normal target
#
ifdef rec
bar: a = global: $(global) pattern: $(pattern) inherit: $(inherit)
else
bar: a := global: $(global) pattern: $(pattern) inherit: $(inherit)
endif

bar: ; @echo 'normal: $a;'


# pattern target
#
ifdef rec
%z: a = global: $(global) pattern: $(pattern) inherit: $(inherit)
else
%z: a := global: $(global) pattern: $(pattern) inherit: $(inherit)
endif

%z: ; @echo 'pattrn: $a;'


global := new $$t

_EOC_

run_tests;

__DATA__

=== TEST #1 -- basics
--- source expand:      $::source
--- stdout
one.x: one two baz
two.x: foo four baz
three.x: foo four three
--- stderr
--- success:            true



=== TEST #2 -- try the override feature
--- source expand:      $::source
--- options:            BAZ=five
--- stdout
one.x: one two five
two.x: foo four five
three.x: foo four three
--- stderr
--- success:            true



=== TEST #3 -- make sure patterns are inherited properly
--- source expand:      $::source
--- options:            four.x
--- stdout
baz: foo two baz
four.x: foo two baz
--- stderr
--- success:            true



=== TEST #4 -- test multiple patterns matching the same target
--- source expand:      $::source
--- options:            ab
--- stdout
aaa bbb
ccc ddd
--- stderr
--- success:            true



=== TEST #5 -- test pattern-specific exported variables
--- source
/%: export foo := foo

/bar:
	@echo $(foo) $$foo
--- stdout
foo foo
--- stderr
--- success:            true



=== TEST #6 -- test expansion of pattern-specific simple variables
--- source expand:     $::source2
--- stdout
normal: global: orginal $t pattern:  inherit: ;
pattrn: global: orginal $t pattern:  inherit: ;
--- stderr
--- success:            true



=== TEST #7 -- test expansion of pattern-specific recursive variables
--- source expand:      $::source2
--- options:            rec=1
--- stdout
normal: global: new $t pattern: good $t inherit: good $t;
pattrn: global: new $t pattern: good $t inherit: good $t;
--- stderr
--- success:            true
