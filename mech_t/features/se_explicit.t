# Description:
#    Test second expansion in ordinary rules.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST #0: Test handing of '$' in prerequisites with and without second
expansion.

--- source

ifdef SE
  .SECONDEXPANSION:
endif
foo$$bar: bar$$baz bar$$biz ; @echo '$@ : $^'
PRE = one two
bar$$baz: $$(PRE)
baraz: $$(PRE)
PRE = three four
.DEFAULT: ; @echo '$@'

--- stdout
$
bar$biz
foo$bar : bar$baz bar$biz
--- stderr
--- error_code:  0



=== TEST 2:
--- source ditto
--- options:  SE=1
--- stdout
three
four
bariz
foo$bar : baraz bariz
--- stderr
--- error_code:  0



=== TEST #1: automatic variables.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

foo: bar baz

foo: biz | buz

foo: $$@.1 \
     $$<.2 \
     $$(addsuffix .3,$$^) \
     $$(addsuffix .4,$$+) \
     $$|.5 \
     $$*.6


--- stdout
bar
baz
biz
buz
foo.1
bar.2
bar.3
baz.3
biz.3
bar.4
baz.4
biz.4
buz.5
.6

--- stderr
--- error_code:  0



=== Test #2: target/pattern -specific variables.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

foo.x: $$a $$b

foo.x: a := bar

%.x: b := baz


--- stdout
bar
baz

--- stderr
--- error_code:  0



=== Test #3: order of prerequisites.
--- source

.SECONDEXPANSION:
.DEFAULT: ; @echo $@

all: foo bar baz

# Subtest #1
#
foo: foo.1; @:

foo: foo.2

foo: foo.3


# Subtest #2
#
bar: bar.2

bar: bar.1; @:

bar: bar.3


# Subtest #3
#
baz: baz.1

baz: baz.2

baz: ; @:


--- stdout
foo.1
foo.2
foo.3
bar.1
bar.2
bar.3
baz.1
baz.2

--- stderr
--- error_code:  0

