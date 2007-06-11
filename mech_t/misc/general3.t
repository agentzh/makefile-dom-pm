# Description:
#    
#    This tests random features of the parser that need to be supported, and
#    which have either broken at some point in the past or seem likely to
#    break.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 10;

run_tests;

__DATA__

=== TEST 1:
--- source

# We want to allow both empty commands _and_ commands that resolve to empty.
EMPTY =

.PHONY: all a1 a2 a3 a4
all: a1 a2 a3 a4

a1:;
a2:
	
a3:;$(EMPTY)
a4:
	$(EMPTY)

# Non-empty lines that expand to nothing should also be ignored.
STR =     # Some spaces
TAB =   	  # A TAB and some spaces

$(STR)

$(STR) $(TAB)
--- stdout preprocess
#MAKE#: Nothing to be done for `all'.
--- stderr



=== TEST 2
Make sure files without trailing newlines are handled properly.
Have to use the old style invocation to test this.

--- source
all:;@echo FOO = $(FOO)
FOO = foo
--- stdout
FOO = foo

--- stderr



=== TEST 3
Check semicolons in variable references

--- source

$(if true,$(info true; true))
all: ; @:

--- stdout
true; true
--- stderr



=== TEST 4
Check that backslashes in command scripts are handled according to POSIX.
Checks Savannah bug # 1332.
Test the fastpath / no quotes

--- source

all:
	@echo foo\
bar
	@echo foo\
	bar
	@echo foo\
    bar
	@echo foo\
	    bar
	@echo foo \
bar
	@echo foo \
	bar
	@echo foo \
    bar
	@echo foo \
	    bar

--- stdout
foobar
foobar
foo bar
foo bar
foo bar
foo bar
foo bar
foo bar
--- stderr



=== TEST 5:
Test the fastpath / single quotes

--- source

all:
	@echo 'foo\
bar'
	@echo 'foo\
	bar'
	@echo 'foo\
    bar'
	@echo 'foo\
	    bar'
	@echo 'foo \
bar'
	@echo 'foo \
	bar'
	@echo 'foo \
    bar'
	@echo 'foo \
	    bar'

--- stdout
foo\
bar
foo\
bar
foo\
    bar
foo\
    bar
foo \
bar
foo \
bar
foo \
    bar
foo \
    bar
--- stderr



=== TEST 6:
Test the fastpath / double quotes

--- source

all:
	@echo "foo\
bar"
	@echo "foo\
	bar"
	@echo "foo\
    bar"
	@echo "foo\
	    bar"
	@echo "foo \
bar"
	@echo "foo \
	bar"
	@echo "foo \
    bar"
	@echo "foo \
	    bar"

--- stdout
foobar
foobar
foo    bar
foo    bar
foo bar
foo bar
foo     bar
foo     bar
--- stderr



=== TEST 7:
Test the slow path / no quotes

--- source

all:
	@echo hi; echo foo\
bar
	@echo hi; echo foo\
	bar
	@echo hi; echo foo\
 bar
	@echo hi; echo foo\
	 bar
	@echo hi; echo foo \
bar
	@echo hi; echo foo \
	bar
	@echo hi; echo foo \
 bar
	@echo hi; echo foo \
	 bar

--- stdout
hi
foobar
hi
foobar
hi
foo bar
hi
foo bar
hi
foo bar
hi
foo bar
hi
foo bar
hi
foo bar
--- stderr



=== TEST 8:
Test the slow path / no quotes.  This time we put the slow path
determination _after_ the backslash-newline handling.

--- source

all:
	@echo foo\
bar; echo hi
	@echo foo\
	bar; echo hi
	@echo foo\
 bar; echo hi
	@echo foo\
	 bar; echo hi
	@echo foo \
bar; echo hi
	@echo foo \
	bar; echo hi
	@echo foo \
 bar; echo hi
	@echo foo \
	 bar; echo hi

--- stdout
foobar
hi
foobar
hi
foo bar
hi
foo bar
hi
foo bar
hi
foo bar
hi
foo bar
hi
foo bar
hi
--- stderr



=== TEST 9:
Test the slow path / single quotes

--- source

all:
	@echo hi; echo 'foo\
bar'
	@echo hi; echo 'foo\
	bar'
	@echo hi; echo 'foo\
    bar'
	@echo hi; echo 'foo\
	    bar'
	@echo hi; echo 'foo \
bar'
	@echo hi; echo 'foo \
	bar'
	@echo hi; echo 'foo \
    bar'
	@echo hi; echo 'foo \
	    bar'

--- stdout
hi
foo\
bar
hi
foo\
bar
hi
foo\
    bar
hi
foo\
    bar
hi
foo \
bar
hi
foo \
bar
hi
foo \
    bar
hi
foo \
    bar
--- stderr



=== TEST 10:
Test the slow path / double quotes

--- source

all:
	@echo hi; echo "foo\
bar"
	@echo hi; echo "foo\
	bar"
	@echo hi; echo "foo\
    bar"
	@echo hi; echo "foo\
	    bar"
	@echo hi; echo "foo \
bar"
	@echo hi; echo "foo \
	bar"
	@echo hi; echo "foo \
    bar"
	@echo hi; echo "foo \
	    bar"

--- stdout
hi
foobar
hi
foobar
hi
foo    bar
hi
foo    bar
hi
foo bar
hi
foo bar
hi
foo     bar
hi
foo     bar
--- stderr

