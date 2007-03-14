use t::Gmake;

plan tests => 2 * blocks();

run_tests;

__DATA__

=== TEST 1: subst
--- source

all:; echo '$(subst ee,EE,feet on the street)'

--- stdout
echo 'fEEt on the strEEt'
fEEt on the strEEt

--- success: true



=== TEST 2: subst (empty arg)
--- source

all: ; @echo '$(subst b,,abc)'

--- stdout
ac
--- success: true



=== TEST 3: subst (leading/trailing space)
--- source

all: ; echo '$(subst a,b, abc )'

--- stdout
echo ' bbc '
 bbc 
--- success: true



=== TEST 4: patsubst
--- source

c_files = editor.c main.c  buffer.c
var = $(patsubst %.c,%.o,  $(c_files) )
all: ; echo '$(var)'

--- stdout
echo 'editor.o main.o buffer.o'
editor.o main.o buffer.o

--- success: true



=== TEST 5: patsubst
--- source

all: ; @echo '$(patsubst %.c,%.o,x.c.c bar.c)'

--- stdout
x.c.o bar.o

--- success: true



=== TEST 6: patsubst (no % in replacement)
--- source

all: ; @echo '${patsubst %,foo,a b c}'
--- stdout
foo foo foo
--- success: true



=== TEST 7: patsubst (no % in pattern nor replacement)
--- source
all: ; @echo '$(patsubst a,foo,a ab abc)'
--- stdout
foo ab abc
--- success: true



=== TEST 8: patsubst (non-matching items)
--- source

all: ; @echo '$(patsubst %.c,%.o,a.c.v b.c)'

--- stdout
a.c.v b.o
--- success: true



=== TEST 9: patsubst (curly braces)
--- source

all: ; @echo '${patsubst %.c, %.o ,a.c b.c }'

--- stdout
 a.o   b.o 
--- success: true



=== TEST 10: substitution reference
--- source

objects = foo.o bar.o baz.o
all: ; @echo '$(objects:.o=.c)'

--- stdout
foo.c bar.c baz.c

--- success: true



=== TEST 11: strip
--- source

empty =
a = a  b  $(empty)
all: ;
	echo '$(strip $a)'
	echo '$a'

--- stdout
echo 'a b'
a b
echo 'a  b  '
a  b  

--- success: true



=== TEST 12: strip
--- source

empty =
a = $(empty)  a  b  $(empty)
all: ;
	echo '$(strip $a)'
	echo '$a'

--- stdout
echo 'a b'
a b
echo '  a  b  '
  a  b  

--- success: true
--- SKIP



=== TEST 13: findstring
--- source

all:
	echo '$(findstring a,b c)'
	echo '$(findstring a,a b c)'

--- stdout
echo ''

echo 'a'
a

--- success: true



=== TEST 14: findstring (partial match)
--- source

all: ; @echo '$(findstring  b,abc) found'

--- stdout
b found
--- success: true



=== TEST 15: filter (2 patterns)
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter %.c %.s,$(sources))'

--- stdout
foo.c bar.c baz.s
--- success: true



=== TEST 16: filter (1 pattern)
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter %.s,$(sources))'

--- stdout
baz.s
--- success: true



=== TEST 17: filter (no %)
--- source

objects=main1.o foo.o main2.o bar.o
mains=main2.o main1.o

all: ; @echo '$(filter $(mains),$(objects))'

--- stdout
main1.o main2.o

--- success: true



=== TEST 18: filter (with duplicate items)
--- source

all: ; @echo '$(filter %.c,foo.c foo.c)'

--- stdout
foo.c foo.c
--- success: true



=== TEST 19: filter (no hit)
--- source

all: ; @echo '$(filter %.cpp,foo.c foo.c)'

--- stdout eval: "\n"
--- success: true



=== TEST 20: filter (partial match)
--- source

all: ; @echo '$(filter %.c,a.c.v b.c)'

--- stdout
b.c
--- success: true



=== TEST 21: filter-out
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter-out %.c %.s,$(sources))'

--- stdout
ugh.h
--- success: true



=== TEST 22: filter-out (no %)
--- source

objects=main1.o foo.o main2.o bar.o
mains=main2.o main1.o

all: ; @echo '$(filter-out $(mains),$(objects))'

--- stdout
foo.o bar.o
--- success: true



=== TEST 23: sort
--- source

var = $(sort b.c a.c c.c)
all: ; echo '$(var)'

--- stdout
echo 'a.c b.c c.c'
a.c b.c c.c

--- success: true



=== TEST 24: sort
--- source

all: ; @echo '$(sort foo bar lose)'

--- stdout
bar foo lose
--- success: true



=== TEST 25: sort (0 is not empty)
--- source

a = 0
b = 0
all: ; @echo $(sort $a $b)
--- stdout
0
--- success: true



=== TEST 26: sort (empty arg)
--- source

all: ; echo '$(sort ) found'

--- stdout
echo ' found'
 found
--- success: true



=== TEST 27: sort (multi-args)
--- source

all: ; echo '$(sort b,a,c)'

--- stdout
echo 'b,a,c'
b,a,c
--- success: true



=== TEST 28: sort (empty string)
--- source

a =
all: ; @echo '$(sort $a)'
--- stdout eval: "\n"
--- success: true



=== TEST 29: sort (duplicate items)
--- source

all: ; @echo '$(sort b aa aa b)'

--- stdout
aa b
--- success: true



=== TEST 30: sort (extra spaces)
--- source

all: ; echo '${sort   z    b  }'

--- stdout
echo 'b z'
b z
--- success: true



=== TEST 31: word
--- source

all: ; @echo '$(word 2, foo bar baz)'
--- stdout
bar
--- success: true

