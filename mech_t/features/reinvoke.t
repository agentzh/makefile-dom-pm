# Description:
#    Test GNU make's auto-reinvocation feature.
#
# Details:
#    
#    If the makefile or one it includes can be rebuilt then it is, and make
#    is reinvoked.  We create a rule to rebuild the makefile from a temp
#    file, then touch the temp file to make it newer than the makefile.

use t::Gmake;

plan tests => 3 * blocks() - 4;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
-*-mode: perl-*-
For some reason if we don't do this then the test fails for systems
with sub-second timestamps, maybe + NFS?  Not sure.

--- source preprocess

all: ; @echo running rules.

#MAKEFILE# incl.mk: incl-1.mk
	@echo rebuilding $@
	@echo >> $@

include incl.mk
--- utouch
-1 incl-1.mk
-600 incl.mk
--- stdout
rebuilding incl.mk
running rules.

--- stderr



=== TEST 2:
Make sure updating the makefile itself also works

--- source ditto
--- utouch
-600 test.mk
-1 incl-1.mk
-600 incl.mk
--- stdout preprocess
rebuilding #MAKEFILE#
running rules.

--- stderr



=== TEST 3:
In this test we create an included file that's out-of-date, but then
the rule doesn't update it.  Make shouldn't re-exec.
#&utouch(-10, 'a');

--- source

SHELL = /bin/sh

all: ; @echo hello

a : b ; echo >> $@

b : c ; [ -f $@ ] || echo >> $@

c: ; echo >> $@

include $(F)
--- touch:  c
--- utouch
-600 a
-600 test.mk
-600 b
--- options:  F=a
--- stdout
[ -f b ] || echo >> b
hello

--- stderr



=== TEST 4:
Now try with the file we're not updating being the actual file we're
including: this and the previous one test different parts of the code.

--- source ditto
--- touch:  c
--- utouch
-600 a
-600 test.mk
-600 b
--- options:  F=b
--- stdout
[ -f b ] || echo >> b
hello

--- stderr

