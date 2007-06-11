# Description:
#    Tests VPATH+/GPATH functionality.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
Run the general-case test

--- source
VPATH = ./

GPATH = $(VPATH)

.SUFFIXES: .a .b .c .d
.PHONY: general rename notarget intermediate

%.a:
%.b:
%.c:
%.d:

%.a : %.b ; cat $^ > $@
%.b : %.c ; cat $^ > $@
%.c :: %.d ; cat $^ > $@

# General testing info:

general: foo.b
foo.b: foo.c bar.c


--- utouch
-460 foo.b
-480 ./foo.c
-450 bar.d
-470 ./bar.c
-490 ./bar.d
-500 ./foo.d
--- goals:  general
--- stdout preprocess
#MAKE#: Nothing to be done for `general'.

--- stderr

