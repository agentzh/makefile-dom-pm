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



=== TEST 2: patsubst
--- source

c_files = editor.c main.c  buffer.c
var = $(patsubst %.c,%.o,  $(c_files) )
all: ; echo '$(var)'

--- stdout
echo 'editor.o main.o buffer.o'
editor.o main.o buffer.o

--- success: true



=== TEST 3: patsubst
--- source

all: ; @echo '$(patsubst %.c,%.o,x.c.c bar.c)'

--- stdout
x.c.o bar.o

--- success: true



=== TEST 4: patsubst (no % in replacement)
--- source

all: ; @echo '${patsubst %,foo,a b c}'
--- stdout
foo foo foo
--- success: true



=== TEST 5: patsubst (no % in pattern nor replacement)
--- source
all: ; @echo '$(patsubst a,foo,a ab abc)'
--- stdout
foo ab abc
--- success: true



=== TEST 6: patsubst (non-matching items)
--- source

all: ; @echo '$(patsubst %.c,%.o,a.c.v b.c)'

--- stdout
a.c.v b.o
--- success: true



=== TEST 7: patsubst (curly braces)
--- source

all: ; @echo '${patsubst %.c, %.o ,a.c b.c }'

--- stdout
 a.o   b.o 
--- success: true



=== TEST 8: substitution reference
--- source

objects = foo.o bar.o baz.o
all: ; @echo '$(objects:.o=.c)'

--- stdout
foo.c bar.c baz.c

--- success: true



=== TEST 9: strip
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



=== TEST 10: strip
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



=== TEST 11: findstring
--- source

all:
	echo '$(findstring a,b c)'
	echo '$(findstring a,a b c)'

--- stdout
echo ''

echo 'a'
a

--- success: true



=== TEST 12: findstring (partial match)
--- source

all: ; @echo '$(findstring  b,abc) found'

--- stdout
b found
--- success: true



=== TEST 13: filter (2 patterns)
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter %.c %.s,$(sources))'

--- stdout
foo.c bar.c baz.s
--- success: true



=== TEST 14: filter (1 pattern)
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter %.s,$(sources))'

--- stdout
baz.s
--- success: true



=== TEST 15: filter (no %)
--- source

objects=main1.o foo.o main2.o bar.o
mains=main1.o main2.o

all: ; @echo '$(filter $(mains),$(objects))'

--- stdout
main1.o main2.o

--- success: true



=== TEST 16: filter (with duplicate items)
--- source

all: ; @echo '$(filter %.c,foo.c foo.c)'

--- stdout
foo.c foo.c
--- success: true



=== TEST 17: filter (no hit)
--- source

all: ; @echo '$(filter %.cpp,foo.c foo.c)'

--- stdout eval: "\n"
--- success: true



=== TEST 18: sort
--- source

var = $(sort b.c a.c c.c)
all: ; echo '$(var)'

--- stdout
echo 'a.c b.c c.c'
a.c b.c c.c

--- success: true



=== TEST 19: sort
--- source

all: ; @echo '$(sort foo bar lose)'

--- stdout
bar foo lose
--- success: true



=== TEST 20: sort (duplicate items)
--- source

all: ; @echo '$(sort b aa aa b)'

--- stdout
aa b
--- success: true



=== TEST 21: sort (extra spaces)
--- source

all: ; echo '${sort   z    b  }'

--- stdout
echo 'b z'
b z
--- success: true

