# Description:
#    Test second expansion in static pattern rules.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== Test #1: automatic variables.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

foo.a foo.b: foo.%: bar.% baz.%

foo.a foo.b: foo.%: biz.% | buz.%

foo.a foo.b: foo.%: $$@.1 \
                    $$<.2 \
                    $$(addsuffix .3,$$^) \
                    $$(addsuffix .4,$$+) \
                    $$|.5 \
                    $$*.6


--- stdout
bar.a
baz.a
biz.a
buz.a
foo.a.1
bar.a.2
bar.a.3
baz.a.3
biz.a.3
bar.a.4
baz.a.4
biz.a.4
buz.a.5
a.6

--- stderr
--- error_code:  0



=== Test #2: target/pattern -specific variables.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

foo.x foo.y: foo.%: $$(%_a) $$($$*_b)

foo.x: x_a := bar

%.x: x_b := baz



--- stdout
bar
baz

--- stderr
--- error_code:  0



=== Test #3: order of prerequisites.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

all: foo.a bar.a baz.a

# Subtest #1
#
foo.a foo.b: foo.%: foo.%.1; @:

foo.a foo.b: foo.%: foo.%.2

foo.a foo.b: foo.%: foo.%.3


# Subtest #2
#
bar.a bar.b: bar.%: bar.%.2

bar.a bar.b: bar.%: bar.%.1; @:

bar.a bar.b: bar.%: bar.%.3


# Subtest #3
#
baz.a baz.b: baz.%: baz.%.1

baz.a baz.b: baz.%: baz.%.2

baz.a baz.b: ; @:


--- stdout
foo.a.1
foo.a.2
foo.a.3
bar.a.1
bar.a.2
bar.a.3
baz.a.1
baz.a.2

--- stderr
--- error_code:  0



=== Test #4: Make sure stem triple-expansion does not happen.
--- source

.SECONDEXPANSION:
foo$$bar: f%r: % $$*.1
	@echo '$*'

oo$$ba oo$$ba.1:
	@echo '$@'


--- stdout
oo$ba
oo$ba.1
oo$ba

--- stderr
--- error_code:  0

