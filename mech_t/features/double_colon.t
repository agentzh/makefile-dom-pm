# Description:
#    Test handling of double-colon rules.
#
# Details:
#    
#    We test these features:
#    
#      - Multiple commands for the same (double-colon) target
#      - Different prerequisites for targets: only out-of-date
#        ones are rebuilt.
#      - Double-colon targets that aren't the goal target.
#    
#    Then we do the same thing for parallel builds: double-colon
#    targets should always be built serially.

use t::Gmake;

plan tests => 3 * blocks() - 1;

use_source_ditto;

run_tests;

__DATA__

=== TEST 0: A simple double-colon rule that isn't the goal target.
--- source

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


--- goals:  all
--- stdout
aaa
bbb

--- stderr
--- error_code:  0



=== TEST 1: As above, in parallel
--- source ditto
--- goals:  all
--- options:  -j10
--- stdout
aaa
bbb

--- stderr
--- error_code:  0



=== TEST 2: A simple double-colon rule that is the goal target
--- source ditto
--- goals:  bar
--- stdout
aaa
aaa done
bbb

--- stderr
--- error_code:  0



=== TEST 3: As above, in parallel
--- source ditto
--- goals:  bar
--- options:  -j10
--- stdout
aaa
aaa done
bbb

--- stderr
--- error_code:  0



=== TEST 4: Each double-colon rule is supposed to be run individually
--- source ditto
--- touch:  foo
--- utouch:  -5 f2.h
--- goals:  foo
--- stdout
f1.h
foo FIRST

--- stderr
--- error_code:  0



=== TEST 5: Again, in parallel.
--- source ditto
--- touch:  foo
--- utouch:  -5 f2.h
--- goals:  foo
--- options:  -j10
--- stdout
f1.h
foo FIRST

--- stderr
--- error_code:  0



=== TEST 6: Each double-colon rule is supposed to be run individually
--- source ditto
--- touch:  foo
--- utouch:  -5 f1.h
--- goals:  foo
--- stdout
f2.h
foo SECOND

--- stderr
--- error_code:  0



=== TEST 7: Again, in parallel.
--- source ditto
--- touch:  foo
--- utouch:  -5 f1.h
--- goals:  foo
--- options:  -j10
--- stdout
f2.h
foo SECOND

--- stderr
--- error_code:  0



=== TEST 8: Test circular dependency check; PR/1671
--- source ditto
--- touch:  foo
--- utouch:  -5 f1.h
--- goals:  d
--- stdout preprocess
ok
#MAKE#: Circular d <- d dependency dropped.
oops

--- stderr
--- error_code:  0



=== TEST 9: make sure all rules in s double colon family get executed
Hmm... further testing indicates this might be timing-dependent?
#if (1) {
&run_make_with_options(test.mk, "-j10 biz", &get_logfile, 0);
ok
#MAKE#: Circular d <- d dependency dropped.
oops
 = "aaa
two
bbb
";
&compare_output(ok
#MAKE#: Circular d <- d dependency dropped.
oops
, &get_logfile(1));
#}
(Savannah bug #14334).

--- source

.PHONY: all
all: result

result:: one
	@echo $^ >>$@
	@echo $^

result:: two
	@echo $^ >>$@
	@echo $^


--- touch:  one two
--- stdout
one
two
--- stderr

