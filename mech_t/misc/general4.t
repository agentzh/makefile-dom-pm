# Description:
#    
#    This tests random features of make's algorithms, often somewhat obscure,
#    which have either broken at some point in the past or seem likely to
#    break.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 6;

run_tests;

__DATA__

=== TEST 1:
--- source

&X::comment("Make sure that subdirectories built as prerequisites are actually handled");
# properly.

all: dir/subdir/file.a

dir/subdir: ; @echo mkdir -p dir/subdir

dir/subdir/file.b: dir/subdir ; @echo touch dir/subdir/file.b

dir/subdir/%.a: dir/subdir/%.b ; @echo cp $< $@
--- stdout
mkdir -p dir/subdir
touch dir/subdir/file.b
cp dir/subdir/file.b dir/subdir/file.a

--- stderr



=== TEST 2:
Test implicit rules

--- source
foo: foo.o
--- touch:  foo.c
--- options:  CC="@echo cc" OUTPUT_OPTION=
--- stdout
cc -c foo.c
cc foo.o -o foo
--- stderr



=== TEST 3:
Test other implicit rule searching

--- source

test.foo:
%.foo : baz ; @echo done $<
%.foo : bar ; @echo done $<
fox: baz

--- touch:  bar
--- stdout
done bar
--- stderr



=== TEST 4:
Test implicit rules with ' in the name (see se_implicit)

--- source

%.foo : baz$$bar ; @echo 'done $<'
%.foo : bar$$baz ; @echo 'done $<'
test.foo:
baz$$bar bar$$baz: ; @echo '$@'

--- stdout
baz$bar
done baz$bar
--- stderr



=== TEST 5:
Test implicit rules with ' in the name (see se_implicit)
Use the ' in the pattern.

--- source

%.foo : %$$bar ; @echo 'done $<'
test.foo:
test$$bar: ; @echo '$@'

--- stdout
test$bar
done test$bar
--- stderr



=== TEST 6:
properly... this time with '

--- source


all: dir/subdir/file.$$a

dir/subdir: ; @echo mkdir -p '$@'

dir/subdir/file.$$b: dir/subdir ; @echo touch '$@'

dir/subdir/%.$$a: dir/subdir/%.$$b ; @echo 'cp $< $@'

--- stdout
mkdir -p dir/subdir
touch dir/subdir/file.$b
cp dir/subdir/file.$b dir/subdir/file.$a

--- stderr

