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



=== TEST 4: substitution reference
--- source

objects = foo.o bar.o baz.o
all: ; @echo '$(objects:.o=.c)'

--- stdout
foo.c bar.c baz.c

--- success: true



=== TEST 5: strip
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



=== TEST 5: strip
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


=== TEST 6: foundstring
--- source

all:
	echo '$(findstring a,b c)'
	echo '$(findstring a,a b c)'

--- stdout
echo ''

echo 'a'
a

--- success: true


=== TEST 6: sort
--- source

var = $(sort b.c a.c c.c)
all: ; echo '$(var)'

--- stdout
echo 'a.c b.c c.c'
a.c b.c c.c

--- success: true



=== TEST 7: sort
--- source

all: ; @echo '$(sort foo bar lose)'

--- stdout
bar foo lose
--- success: true


