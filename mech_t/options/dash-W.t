# Description:
#    Test make -W (what if) option.

#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
Basic build

--- source

a.x: b.x
a.x b.x: ; echo >> $@

--- stdout
echo >> b.x
echo >> a.x
--- stderr
--- error_code:  0



=== TEST 2:
Run it again: nothing should happen

--- source ditto
--- stdout preprocess
#MAKE#: `a.x' is up to date.
--- stderr
--- error_code:  0



=== TEST 3:
Now run it with -W b.x: should rebuild a.x

--- source ditto
--- options:  -W b.x
--- stdout
echo >> a.x
--- stderr
--- error_code:  0



=== TEST 4:
Put the timestamp for a.x into the future; it should still be remade.

--- source ditto
--- utouch:  1000 a.x
--- stdout preprocess
#MAKE#: `a.x' is up to date.
--- stderr
--- error_code:  0



=== TEST 5:
--- source ditto
--- utouch:  1000 a.x
--- options:  -W b.x
--- stdout
echo >> a.x
--- stderr
--- error_code:  0



=== TEST 6:
Clean up
Test -W with the re-exec feature: we don't want to re-exec forever
Savannah bug # 7566
First set it up with a normal build

--- source

all: baz.x ; @:
include foo.x
foo.x: bar.x
	@echo "\$$(info restarts=\$$(MAKE_RESTARTS))" > $@
	@echo "touch $@"
bar.x: ; echo >> $@
baz.x: bar.x ; @echo "touch $@"

--- stdout
echo >> bar.x
touch foo.x
restarts=1
touch baz.x
--- stderr preprocess
#MAKEFILE#:2: foo.x: No such file or directory

--- error_code:  0



=== TEST 7:
Now run with -W bar.x
Tweak foo.x's timestamp so the update will change it.

--- source ditto
--- utouch:  1000 foo.x
--- options:  -W bar.x
--- stdout
restarts=
touch foo.x
restarts=1
touch baz.x
--- stderr
--- error_code:  0



=== TEST 8:
Test -W on vpath-found files: it should take effect.
Savannah bug # 15341

--- source

y: x ; @echo cp $< $@

--- touch:  y
--- utouch:  -20 x-dir/x
--- options:  -W x-dir/x VPATH=x-dir
--- stdout
cp x-dir/x y
--- stderr
--- error_code:  0



=== TEST 9:
Make sure ./ stripping doesn't interfere with the match.

--- source ditto
--- touch:  y
--- utouch:  -20 x-dir/x
--- options:  -W ./x-dir/x VPATH=x-dir
--- stdout
cp x-dir/x y
--- stderr
--- error_code:  0



=== TEST 10:
--- source ditto
--- touch:  y
--- utouch:  -20 x-dir/x
--- options:  -W x-dir/x VPATH=./x-dir
--- stdout
cp ./x-dir/x y
--- stderr
--- error_code:  0

