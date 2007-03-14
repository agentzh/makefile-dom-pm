use t::Gmake;

plan tests => 2 * blocks() + 3;

run_tests;

__DATA__

=== TEST 1: subst
--- source

all:; echo '$(subst ee,EE,feet on the street)'

--- stdout
echo 'fEEt on the strEEt'
fEEt on the strEEt

--- success: true



=== TEST 2: subst (colon)
--- source

path = /home/agentz:/usr/bin:/bin/
all: ; @echo '$(subst :, ,$(path))'

--- stdout
/home/agentz /usr/bin /bin/
--- success: true



=== TEST 3: subst (empty arg)
--- source

all: ; @echo '$(subst b,,abc)'

--- stdout
ac
--- success: true



=== TEST 4: subst (leading/trailing space)
--- source

all: ; echo '$(subst a,b, abc )'

--- stdout
echo ' bbc '
 bbc 
--- success: true



=== TEST 5: subst (trailing space in from)
--- source

all: ; @echo '$(subst a ,b, a b)'

--- stdout
 bb
--- success: true



=== TEST 6: subst (too many args)
--- source

all: ; @echo '$(subst l,k,hello, world)'

--- stdout
hekko, workd
--- success: true



=== TEST 7: patsubst
--- source

c_files = editor.c main.c  buffer.c
var = $(patsubst %.c,%.o,  $(c_files) )
all: ; echo '$(var)'

--- stdout
echo 'editor.o main.o buffer.o'
editor.o main.o buffer.o

--- success: true



=== TEST 8: patsubst (-I...)
--- source
path = src:../headers
all: ; @echo '$(patsubst %,-I%,$(subst :, ,$(path)))'

--- stdout
-Isrc -I../headers

--- success: true



=== TEST 9: patsubst
--- source

all: ; @echo '$(patsubst %.c,%.o,x.c.c bar.c)'

--- stdout
x.c.o bar.o

--- success: true



=== TEST 10: patsubst (no % in replacement)
--- source

all: ; @echo '${patsubst %,foo,a b c}'
--- stdout
foo foo foo
--- success: true



=== TEST 11: patsubst (no % in pattern nor replacement)
--- source
all: ; @echo '$(patsubst a,foo,a ab abc)'
--- stdout
foo ab abc
--- success: true



=== TEST 12: patsubst (non-matching items)
--- source

all: ; @echo '$(patsubst %.c,%.o,a.c.v b.c)'

--- stdout
a.c.v b.o
--- success: true



=== TEST 13: patsubst (curly braces)
--- source

all: ; @echo '${patsubst %.c, %.o ,a.c b.c }'

--- stdout
 a.o   b.o 
--- success: true



=== TEST 14: patsubst (too many args)
--- source
all: ; @echo '$(patsubst %.c,%.o,a,b.c b,f.c)'
--- stdout
a,b.o b,f.o
--- success: true



=== TEST 15: substitution reference
--- source

objects = foo.o bar.o baz.o
all: ; @echo '$(objects:.o=.c)'

--- stdout
foo.c bar.c baz.c

--- success: true



=== TEST 16: strip
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



=== TEST 17: strip
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



=== TEST 18: strip (too many args)
--- source

all: ; @echo '$(strip hello, world )'
--- stdout
hello, world
--- success: true



=== TEST 19: findstring
--- source

all:
	echo '$(findstring a,b c)'
	echo '$(findstring a,a b c)'

--- stdout
echo ''

echo 'a'
a

--- success: true



=== TEST 20: findstring (partial match)
--- source

all: ; @echo '$(findstring  b,abc) found'

--- stdout
b found
--- success: true



=== TEST 21: findstring (too many args)
--- source

pat = hello,world
all: ; @echo '$(findstring $(pat),hello,world foo)'

--- stdout
hello,world
--- success: true



=== TEST 22: filter (2 patterns)
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter %.c %.s,$(sources))'

--- stdout
foo.c bar.c baz.s
--- success: true



=== TEST 23: filter (1 pattern)
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter %.s,$(sources))'

--- stdout
baz.s
--- success: true



=== TEST 24: filter (no %)
--- source

objects=main1.o foo.o main2.o bar.o
mains=main2.o main1.o

all: ; @echo '$(filter $(mains),$(objects))'

--- stdout
main1.o main2.o

--- success: true



=== TEST 25: filter (too many args)
--- source

pat = hello,world
all: ; @echo '$(filter $(pat),foo hello,world)'

--- stdout
hello,world
--- success: true



=== TEST 26: filter (with duplicate items)
--- source

all: ; @echo '$(filter %.c,foo.c foo.c)'

--- stdout
foo.c foo.c
--- success: true



=== TEST 27: filter (no hit)
--- source

all: ; @echo '$(filter %.cpp,foo.c foo.c)'

--- stdout eval: "\n"
--- success: true



=== TEST 28: filter (partial match)
--- source

all: ; @echo '$(filter %.c,a.c.v b.c)'

--- stdout
b.c
--- success: true



=== TEST 29: filter-out
--- source

sources := foo.c bar.c baz.s ugh.h
all: ; @echo '$(filter-out %.c %.s,$(sources))'

--- stdout
ugh.h
--- success: true



=== TEST 30: filter-out (no %)
--- source

objects=main1.o foo.o main2.o bar.o
mains=main2.o main1.o

all: ; @echo '$(filter-out $(mains),$(objects))'

--- stdout
foo.o bar.o
--- success: true



=== TEST 31: filter-out (too many args)
--- source

all: ; @echo '$(filter-out foo,foo hello,world)'

--- stdout
hello,world
--- success: true



=== TEST 32: sort
--- source

var = $(sort b.c a.c c.c)
all: ; echo '$(var)'

--- stdout
echo 'a.c b.c c.c'
a.c b.c c.c

--- success: true



=== TEST 33: sort
--- source

all: ; @echo '$(sort foo bar lose)'

--- stdout
bar foo lose
--- success: true



=== TEST 34: sort (0 is not empty)
--- source

a = 0
b = 0
all: ; @echo $(sort $a $b)
--- stdout
0
--- success: true



=== TEST 35: sort (empty arg)
--- source

all: ; echo '$(sort ) found'

--- stdout
echo ' found'
 found
--- success: true



=== TEST 36: sort (multi-args)
--- source

all: ; echo '$(sort b,a,c)'

--- stdout
echo 'b,a,c'
b,a,c
--- success: true



=== TEST 37: sort (empty string)
--- source

a =
all: ; @echo '$(sort $a)'
--- stdout eval: "\n"
--- success: true



=== TEST 38: sort (duplicate items)
--- source

all: ; @echo '$(sort b aa aa b)'

--- stdout
aa b
--- success: true



=== TEST 39: sort (extra spaces)
--- source

all: ; echo '${sort   z    b  }'

--- stdout
echo 'b z'
b z
--- success: true



=== TEST 40: word
--- source

all: ; @echo '$(word 2, foo bar baz)'
--- stdout
bar
--- success: true



=== TEST 41: word
--- source

all: ; @echo '$(word 1,foo bar baz )'

--- stdout
foo
--- success: true



=== TEST 42: word (trailing space in n)
--- source

all: ; @echo '$(word 1 ,foo bar baz )'

--- stdout
foo
--- success: true



=== TEST 43: word (overflow)
--- source

all: ; @echo '$(word 4,foo bar baz)'

--- stdout eval: "\n"
--- success: true



=== TEST 44: word (words are not necessarily \w+)
--- source

all: ; @echo '$(word 2,5:3 2)'

--- stdout
2
--- success: true



=== TEST 45: word (zero n)
--- source

all: @echo '$(word 0,a b c)'

--- stdout
--- stderr preprocess
#MAKEFILE#:1: *** first argument to `word' function must be greater than 0.  Stop.
--- error_code: 2



=== TEST 46: word (non-numeric n)
--- source

all: ; @echo '$(word a,b)'

--- stdout
--- stderr preprocess
#MAKEFILE#:1: *** non-numeric first argument to `word' function: 'a'.  Stop.

--- error_code: 2



=== TEST 47: wordlist (e == words)
--- source

all: ; @echo '$(wordlist 2 , 3 , foo bar baz)'
--- stdout
bar baz
--- success: true



=== TEST 48: wordlist
--- source

all: ; @echo '$(wordlist 2,2,foo bar baz)'

--- stdout
bar
--- success: true



=== TEST 49: wordlist (s > e)
--- source

all: ; @echo '$(wordlist 2,1,foo bar baz)'

--- stdout eval: "\n"
--- success: true



=== TEST 50: wordlist (s == e)
--- source

all: ; @echo '$(wordlist 1,1,foo bar baz)'

--- stdout
foo
--- success: true



=== TEST 51: wordlist (more words than s)
--- source

all: ; @echo '$(wordlist 2,3,foo bar baz boz lose)'

--- stdout
bar baz
--- success: true



=== TEST 52: wordlist (e > words)
--- source

all: ; @echo '$(wordlist 2,5, foo bar baz)'

--- stdout
bar baz
--- success: true



=== TEST 53: wordlist (too many args)
--- source

all: ; @echo '$(wordlist 2,3, hello,world bar baz)'

--- stdout
bar baz
--- success: true



=== TEST 54: wordlist (too few args)
--- source

all: ; @echo '$(wordlist 2,foo bar)'

--- stdout
--- stderr preprocess
#MAKEFILE#:1: *** insufficient number of arguments (2) to function `wordlist'.  Stop.

--- success: false



=== TEST 55: wordlist (s = limit, e = limit)
--- source

all: ; @echo '$(wordlist 1, 0, foo bar baz)'

--- stdout eval: "\n"
--- success: true



=== TEST 56: words
--- source

all: ; @echo '$(words foo   bar baz )'

--- stdout
3
--- success: true



=== TEST 57: words (comma in args)
--- source

all: ; @echo '$(words hello,word   bar baz )'

--- stdout
3
--- success: true



=== TEST 58: words (empty args)
--- source

all: ; @echo '$(words ) found'

--- stdout
0 found
--- success: true



=== TEST 59: words (empty args and no space)
--- source

all: ; @echo '$(words) found'

--- stdout
 found
--- success: true
--- SKIP



=== TEST 60: words (1 arg)
--- source

all: ; @echo '$(words foo)'

--- stdout
1
--- success: true



=== TEST 61: words (colon)
--- source

all: ; @echo '$(words foo:bar baz)'

--- stdout
2
--- success: true



=== TEST 62: words (empty var)
--- source

empty =
all: ; @echo '$(words $(empty)) found'

--- stdout
0 found
--- success: true



=== TEST 63: firstword (2 args)
--- source

all: ; @echo '$(firstword foo bar)'

--- stdout
foo
--- success: true



=== TEST 64: firstword (1 arg)
--- source

all: ; @echo '$(firstword foo)'

--- stdout
foo
--- success: true



=== TEST 65: firstword (0 arg)
--- source

all: ; @echo '$(firstword )'

--- stdout eval: "\n"
--- success: true



=== TEST 66: firstword (empty var as arg)
--- source

empty =
all: ; @echo '$(firstword $(empty))'

--- stdout eval: "\n"
--- success: true



=== TEST 67: firstword (too many args)
--- source

all: ; @echo '$(firstword hello,world haha)'

--- stdout
hello,world
--- success: true



=== TEST 68: lastword (2 args)
--- source

all: ; @echo '$(lastword foo bar)'

--- stdout
bar
--- success: true



=== TEST 69: lastword (1 arg)
--- source

all: ; @echo '$(lastword foo)'

--- stdout
foo
--- success: true



=== TEST 70: lastword (0 arg)
--- source

all: ; @echo '$(lastword )'

--- stdout eval: "\n"
--- success: true



=== TEST 71: lastword (empty var as arg)
--- source

empty =
all: ; @echo '$(lastword $(empty))'

--- stdout eval: "\n"
--- success: true



=== TEST 72: lastword (too many args)
--- source

all: ; @echo '$(lastword haha hello,world )'

--- stdout
hello,world
--- success: true



=== TEST 73: dir
--- source

all: ; @echo '$(dir src/foo.c hacks)'

--- stdout
src/ ./
--- success: true



=== TEST 74: dir (too many args)
--- source

all: ; @echo '$(dir a,b,c foo/)'

--- stdout
./ foo/
--- success: true



=== TEST 75: dir (~/...)
--- source

all: ; @echo '$(dir ~/tmp/pugs/ readme.txt)'

--- stdout
~/tmp/pugs/ ./

--- success: true



=== TEST 76: dir (empty arg)
--- source

all: ; @echo '$(dir )'

--- stdout eval: "\n"
--- success: true



=== TEST 77: notdir
--- source

all: ; @echo '$(notdir src/foo.c hacks)'

--- stdout
foo.c hacks
--- success: true



=== TEST 78: notdir (too many args)
--- source

all: ; @echo '$(notdir a,b,c foo/)'

--- stdout
a,b,c 
--- success: true



=== TEST 79: notdir (~/...)
--- source

all: ; @echo '$(notdir ~/tmp/pugs/ readme.txt)'

--- stdout
 readme.txt
--- success: true



=== TEST 80: notdir (empty arg)
--- source

all: ; @echo '$(notdir )'

--- stdout eval: "\n"
--- success: true



=== TEST 81: suffix
--- source

all: ; @echo '$(suffix src/foo.c src-1.0/bar.c hacks)'

--- stdout
.c .c
--- success: true



=== TEST 82: suffix (empty arg)
--- source

all: ; @echo '$(suffix )'

--- stdout eval: "\n"
--- success: true

=== TEST 83: suffix
--- source

all: ; @echo '$(suffix a.c.v readme.txt foo. bar/)'

--- stdout
.v .txt .
--- success: true

