# Description:
#    Tests the new VPATH+ functionality added in 3.76.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 3;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
Run the general-case test

--- source
VPATH = ./

SHELL = /bin/sh

.SUFFIXES: .a .b .c .d
.PHONY: general rename notarget intermediate

%.a:
%.b:
%.c:
%.d:

%.a : %.b
	cat $^ > $@
%.b : %.c
	cat $^ > $@ 2>/dev/null || exit 1
%.c :: %.d
	cat $^ > $@

# General testing info:

general: foo.b
foo.b: foo.c bar.c

# Rename testing info:

rename: $(VPATH)/foo.c foo.d

# Target not made testing info:

notarget: notarget.b
notarget.c: notarget.d
	-@echo "not creating $@ from $^"

# Intermediate files:

intermediate: inter.a


--- utouch
-460 foo.b
-480 .//foo.c
-450 bar.d
-470 .//bar.c
-490 .//bar.d
-500 .//foo.d
--- goals:  general
--- stdout
cat bar.d > bar.c
cat ./foo.c bar.c > foo.b 2>/dev/null || exit 1

--- stderr



=== TEST 2:
Test rules that don't make the target correctly

--- source ditto
--- utouch
-450 bar.d
-420 notarget.d
-500 .//foo.d
-480 .//foo.c
-460 foo.b
-440 .//notarget.c
-430 notarget.b
-470 .//bar.c
-490 .//bar.d
--- goals:  notarget
--- stdout
not creating notarget.c from notarget.d
cat notarget.c > notarget.b 2>/dev/null || exit 1

--- stderr preprocess
#MAKE#: *** [notarget.b] Error 1

--- error_code:  2



=== TEST 3:
Test intermediate file handling (part 1)

--- source ditto
--- utouch
-450 bar.d
-410 .//inter.d
-420 notarget.d
-500 .//foo.d
-460 foo.b
-480 .//foo.c
-430 notarget.b
-440 .//notarget.c
-470 .//bar.c
-490 .//bar.d
--- goals:  intermediate
--- stdout
cat ./inter.d > inter.c
cat inter.c > inter.b 2>/dev/null || exit 1
cat inter.b > inter.a
rm inter.b inter.c

--- stderr



=== TEST 4:
Test intermediate file handling (part 2)

--- source ditto
--- touch:  .//inter.d
--- utouch
-450 bar.d
-10 .//inter.b
-420 notarget.d
-500 .//foo.d
-460 foo.b
-480 .//foo.c
-440 .//notarget.c
-430 notarget.b
-20 inter.a
-470 .//bar.c
-490 .//bar.d
--- goals:  intermediate
--- stdout
cat ./inter.d > inter.c
cat inter.c > inter.b 2>/dev/null || exit 1
cat inter.b > inter.a
rm inter.c

--- stderr

