#: order_only2.t
#: Extension to order_only.t
#: Copyright (c) 2006 Zhang "agentzh" Yichun
#: 2006-02-11 2006-02-11

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1 -- Basics
--- source
%r: | baz ; @echo '$$<=$< $$^=$^ $$|=$|'
bar: foo
foo:;@:
baz:;@:
--- stdout
$<=foo $^=foo $|=baz
--- stderr
--- success:      true



=== TEST 2: when foo does not exist, then remaking still happen
--- source
foo: bar | baz
	@echo '$$^ = $^'
	@echo '$$| = $|'
	touch $@

.PHONY: baz

bar baz:
	touch $@
--- touch:        bar baz
--- stdout
touch baz
$^ = bar
$| = baz
touch foo
--- stderr
--- success:      true



=== TEST 3 -- make sure that $< is set correctly
--- source
%r: | baz ; @echo '$$<=$< $$^=$^ $$|=$|'
bar: foo
foo:;@:
baz:;@:
--- stdout
$<=foo $^=foo $|=baz
--- stderr
--- success:      true
