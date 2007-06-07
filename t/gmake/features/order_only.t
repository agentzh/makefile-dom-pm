#: order_only.t
#:
#: Description:
#:   Test order-only prerequisites.
#: Details:
#:   Create makefiles with various combinations of normal and order-only
#:   prerequisites and ensure they behave properly.  Test the $| variable.

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST #0 -- Basics
--- source
%r: | baz ; @echo $< $^ $|
bar: foo
foo:;@:
baz:;@:
--- stdout
foo foo baz
--- stderr
--- success:      true



=== TEST #1 -- First try: the order-only prereqs need to be built.
--- source
foo: bar | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

.PHONY: baz

bar baz:
	touch $@
--- stdout
touch bar
touch baz
$^ = bar
$| = baz
touch foo
--- stderr
--- success:      true



=== TEST #2 -- now we do it again: baz is PHONY but foo should _NOT_ be updated
--- source
foo: bar | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

.PHONY: baz

bar baz:
	touch $@
--- touch:        foo bar baz
--- stdout
touch baz
--- stderr
--- success:      true



=== TEST #3 -- Make sure the order-only prereq was promoted to normal.
--- source
foo: bar | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

foo: baz

.PHONY: baz

bar baz:
	touch $@
--- stdout
touch bar
touch baz
$^ = bar baz
$| = 
touch foo
--- stderr
--- success:      true



=== TEST #4 -- now we do it again
--- source
foo: bar | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

foo: baz

.PHONY: baz

bar baz:
	touch $@
--- touch:        bar baz foo
--- stdout
touch baz
$^ = bar baz
$| = 
touch foo
--- stderr
--- success:      true



=== TEST #5 -- make sure the parser was correct.
Test empty normal prereqs
--- source
foo:| baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

.PHONY: baz

baz:
	touch $@
--- stdout
touch baz
$^ = 
$| = baz
touch foo
--- stderr
--- success:      true



=== TEST #6 -- now we do it again: this time foo won't be built
--- source
foo:| baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

.PHONY: baz

baz:
	touch $@
--- touch:        foo baz
--- stdout
touch baz
--- stderr
--- success:      true



=== TEST #7 -- make sure the parser was correct.
Test order-only in pattern rules
--- source
%.w : %.x | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

all: foo.w

.PHONY: baz
foo.x baz:
	touch $@
--- stdout
touch foo.x
touch baz
$^ = foo.x
$| = baz
touch foo.w
--- stderr
--- success:      true



=== TEST #8 -- now we do it again: this time foo.w won't be built
--- source
%.w : %.x | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

all: foo.w

.PHONY: baz
foo.x baz:
	touch $@
--- touch:        foo.w foo.x baz
--- stdout
touch baz
--- stderr
--- success:      true



=== TEST #9 -- make sure that $< is set correctly in the face of order-only prerequisites in pattern rules.
--- source
%r: | baz ; @echo $< $^ $|
bar: foo
foo:;@:
baz:;@:
--- stdout
foo foo baz
--- stderr
--- success:      true
