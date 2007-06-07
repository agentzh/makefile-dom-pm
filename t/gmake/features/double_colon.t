#: double_colon.t
#:
#: Description:
#:   Test handling of double-colon rules.
#: Details:
#:   We test these features:
#:     - Multiple commands for the same (double-colon) target
#:     - Different prerequisites for targets: only out-of-date
#:       ones are rebuilt.
#:     - Double-colon targets that aren't the goal target.
#:   Then we do the same thing for parallel builds: double-colon
#:   targets should always be built serially.

use t::Gmake;

plan tests => 3 * blocks;

our $source = <<'_EOC_';

all: baz

foo:: f1.h ; @echo foo FIRST
foo:: f2.h ; @echo foo SECOND

bar:: ; @echo aaa; sleep 1; echo aaa done
bar:: ; @echo bbb

baz:: ; @echo aaa
baz:: ; @echo bbb

biz:: ; @echo aaa
biz:: two ; @echo bbb

two: ; @echo two

f1.h f2.h: ; @echo $@

d :: ; @echo ok
d :: d ; @echo oops

_EOC_

run_tests;

__DATA__

=== TEST 0: A simple double-colon rule that isn't the goal target.
--- source expand:    $::source
--- goals:             all
--- stdout
aaa
bbb
--- stderr
--- error_code
0



=== TEST 1: As above, in parallel
--- source expand:     $::source
--- options:           -j10
--- goals:             all
--- stdout
aaa
bbb
--- stderr
--- error_code
0



=== TEST 2: A simple double-colon rule that is the goal target
--- source expand:     $::source
--- goals:             bar
--- stdout
aaa
aaa done
bbb
--- stderr
--- error_code
0



=== TEST 3: As above, in parallel
--- source expand:     $::source
--- options:           -j10
--- goals:             bar
--- stdout
aaa
aaa done
bbb
--- stderr
--- error_code
0



=== TEST 4: Each double-colon rule is supposed to be run individually
--- source expand:     $::source
--- utouch:            -5 f2.h
--- touch:             foo
--- goals: foo
--- stdout
f1.h
foo FIRST
--- stderr
--- error_code
0



=== TEST 5: Again, in parallel.
--- source expand:     $::source
--- options:           -j10
--- utouch:            -5 f2.h
--- touch:             foo
--- goals:             foo
--- stdout
f1.h
foo FIRST
--- stderr
--- error_code
0



=== TEST 6: Each double-colon rule is supposed to be run individually
--- source expand:     $::source
--- utouch:            -5 f1.h
--- touch:             foo
--- goals:             foo
--- stdout
f2.h
foo SECOND
--- stderr
--- error_code
0



=== TEST 7: Again, in parallel.
--- source expand:        $::source
--- options:              -j10
--- utouch:               -5 f1.h
--- touch:                foo
--- goals:                foo
--- stdout
f2.h
foo SECOND
--- stderr
--- error_code
0



=== TEST 8: Test circular dependency check; PR/1671
--- source expand:        $::source
--- goals:                d
--- stdout
ok
oops
--- stderr preprocess
#MAKE#: Circular d <- d dependency dropped.
--- error_code
0



=== TEST 8: I don't grok why this is different than the above, but it is...
Hmm... further testing indicates this might be timing-dependent?
--- source expand:        $::source
--- goals:                biz
--- options:              -j10
--- stdout
aaa
two
bbb
--- stderr
--- error_code
0



=== TEST 9: make sure all rules in s double colon family get executed (Savannah bug #14334).
--- touch:                one two
--- source
.PHONY: all
all: result

result:: one
	@echo $^ >>$@
	@echo $^

result:: two
	@echo $^ >>$@
	@echo $^

--- stdout
one
two
--- stderr
--- success:           true

