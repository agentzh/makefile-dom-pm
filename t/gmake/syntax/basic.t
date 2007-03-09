use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: rules with no command
--- source
a: b
b: c
c:; echo  'hello!'
--- stdout
echo  'hello!'
hello!
--- stderr
--- error_code
0



=== TEST 2: command at beginning
--- source
	a: b
b: c
c:; echo  'hello!'
--- stdout
--- stderr_like
.*?commands commence before first target.*?
--- error_code
512



=== TEST 3: escaped line continuator
--- source
a: # \\
b: c
c:; echo  'hello!'
--- stdout preprocess
#MAKE#: Nothing to be done for `a'.
--- stderr
--- error_code
0



=== TEST 4: rule context
--- source
a: b

	echo "a"
b: ; echo "b"
--- stdout
echo "b"
b
echo "a"
a
--- stderr
--- success:    true



=== TEST 5: empty command
--- source
a: b
	
	echo "a"
b: ; echo "b"
--- stdout
echo "b"
b
echo "a"
a
--- stderr
--- success:    true



=== TEST 6: escaped '#'
--- source
a: \#b
	echo "a"
--- stdout
--- stderr preprocess
#MAKE#: *** No rule to make target `#b', needed by `a'.  Stop.
--- error_code
512



=== TEST 7: escaped '3'
--- source
a: \3b
	echo "a"

3b: ; echo "3b"
--- stdout
--- stderr preprocess
#MAKE#: *** No rule to make target `\3b', needed by `a'.  Stop.
--- error_code
512



=== TEST 8: line continuation
--- source
a: \
	echo c
	echo "a"

echo: ; echo $@

c: ; echo $@

--- stdout
echo echo
echo
echo c
c
echo "a"
a
--- stderr
--- error_code
0



=== TEST 9: line continuation
--- source
a: \
	b; \
    echo $@

b: ; echo $@

--- stdout
echo b
b
\
    echo a
a
--- stderr
--- error_code
0



=== TEST 10: variables with a single character name:
--- source
a = foo
all: ; echo $a
--- stdout
echo foo
foo
--- stderr
--- error_code
0



=== TEST 11: escaped $
--- source
a = foo
all: ; echo \$a
--- stdout
echo \foo
foo
--- stderr
--- error_code
0



=== TEST 12: unescaped '#'
--- source

all: foo\\# hello
foo\\: ; echo $@

--- stdout
echo foo\
foo\
--- stderr
--- error_code
0



=== TEST 13: when no space between words and '#'
--- source

\#a: foo#hello

foo:;echo $@

--- stdout
echo foo
foo
--- stderr
--- error_code
0



=== TEST 14: comment indented with tabs
--- source
	# blah
a: ; echo hi
--- stdout
echo hi
hi
--- stderr
--- error_code
0



=== TEST 15: multi-line comment indented with tabs
--- source
	# blah \
hello!\
	# hehe
a: ; echo hi
--- stdout
echo hi
hi
--- stderr
--- error_code
0



=== TEST 16: dynamics of rules
--- source
foo = : b
a $(foo)
	echo $@
b:; echo $@
--- stdout
echo b
b
echo a
a
--- stderr
--- error_code
0



=== TEST 17: disabled suffix rules
--- source
.SUFFIXES:

all: .c.o
.c.o:
	echo "hello $<!"
--- stdout
echo "hello !"
hello !
--- stderr
--- error_code
0



=== TEST 18: static pattern rules with ";" command
--- source

foo.o bar.o: %.o: %.c ; echo blah

%.c: ; echo $@

--- stdout
echo foo.c
foo.c
echo blah
blah
--- stderr
--- error_code
0



=== TEST 19: var assignment changed the "rule context" to VOID
--- source

a: b
foo = bar
	echo $@

--- stdout
--- stderr preprocess
#MAKEFILE#:3: *** commands commence before first target.  Stop.
--- error_code
512



=== TEST 20: whitespace before command modifier
--- source

all:
	  @ echo $@

--- stdout
all
--- stderr
--- error_code
0



=== TEST 21: multi-word define directive
--- source

define a b
foo
endef

$(a b):
	echo $@

--- stdout
echo foo
foo
--- stderr
--- error_code
0



=== TEST 22: odd define directive
--- source

define a = 3
foo
endef

$(a = 3):
	echo $@

--- stdout
echo foo
foo
--- stderr
--- error_code
0



=== TEST 23: define directive with a preceding tab
--- source

	define a
foo
endef

$(a):
	echo $@

--- stdout
echo foo
foo
--- stderr
--- error_code
0



=== TEST 24: variable assignment with a preceding tab
--- source

	a = foo

$(a):
	echo $@

--- stdout
echo foo
foo
--- stderr
--- error_code
0
