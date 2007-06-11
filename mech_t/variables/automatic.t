# Description:
#    Test automatic variable setting.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 6;

use_source_ditto;

run_tests;

__DATA__

=== TEST #0 -- simple test
Touch these into the past

--- source preprocess
dir = #PWD#
.SUFFIXES:
.SUFFIXES: .x .y .z
$(dir)/foo.x : baz.z $(dir)/bar.y baz.z
	@echo '$$@ = $@, $$(@D) = $(@D), $$(@F) = $(@F)'
	@echo '$$* = $*, $$(*D) = $(*D), $$(*F) = $(*F)'
	@echo '$$< = $<, $$(<D) = $(<D), $$(<F) = $(<F)'
	@echo '$$^ = $^, $$(^D) = $(^D), $$(^F) = $(^F)'
	@echo '$$+ = $+, $$(+D) = $(+D), $$(+F) = $(+F)'
	@echo '$$? = $?, $$(?D) = $(?D), $$(?F) = $(?F)'
	touch $@

$(dir)/bar.y baz.z : ; touch $@

--- utouch
-10 foo.x
-10 baz.z
--- stdout preprocess
touch #PWD#/bar.y
$@ = #PWD#/foo.x, $(@D) = #PWD#, $(@F) = foo.x
$* = #PWD#/foo, $(*D) = #PWD#, $(*F) = foo
$< = baz.z, $(<D) = ., $(<F) = baz.z
$^ = baz.z #PWD#/bar.y, $(^D) = . #PWD#, $(^F) = baz.z bar.y
$+ = baz.z #PWD#/bar.y baz.z, $(+D) = . #PWD# ., $(+F) = baz.z bar.y baz.z
$? = #PWD#/bar.y, $(?D) = #PWD#, $(?F) = bar.y
touch #PWD#/foo.x

--- stderr



=== TEST #1 -- test the SysV emulation of 15806@ etc.
--- source preprocess
dir = #PWD#
.SECONDEXPANSION:
.SUFFIXES:
.DEFAULT: ; @echo '$@'

$(dir)/foo $(dir)/bar: $@.x $$@.x $$$@.x $$$$@.x $$(@D).x $$(@F).x

$(dir)/x.z $(dir)/y.z: $(dir)/%.z : $@.% $$@.% $$$@.% $$$$@.% $$(@D).% $$(@F).%

$(dir)/biz: $$(@).x $${@}.x $${@D}.x $${@F}.x

--- options preprocess:  #PWD#/foo #PWD#/bar
--- stdout preprocess
.x
#PWD#/foo.x
x
$@.x
#PWD#.x
foo.x
#PWD#/bar.x
bar.x

--- stderr



=== TEST 3:
--- source ditto
--- options preprocess:  #PWD#/x.z #PWD#/y.z
--- stdout preprocess
.x
#PWD#/x.z.x
x
$@.x
#PWD#.x
x.z.x
.y
#PWD#/y.z.y
y
$@.y
#PWD#.y
y.z.y

--- stderr



=== TEST 4:
--- source ditto
--- options preprocess:  #PWD#/biz
--- stdout preprocess
#PWD#/biz.x
#PWD#.x
biz.x

--- stderr



=== TEST #2 -- test for Savannah bug #12320.
--- source

.SUFFIXES: .b .src

mbr.b: mbr.src
	@echo $*

mbr.src: ; @:
--- stdout
mbr
--- stderr



=== TEST #3 -- test for Savannah bug #8154
Make sure that nonexistent prerequisites are listed in 0, since they are
considered reasons for the target to be rebuilt.
See also Savannah bugs #16002 and #16051.

--- source

foo: bar ; @echo "\$$? = $?"
bar: ;
--- touch:  foo
--- stdout
$? = bar
--- stderr

