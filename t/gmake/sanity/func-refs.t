use t::Gmake;

plan tests => 2 * blocks() + 21;

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
--- TODO



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
--- error_code: 0



=== TEST 45: word (zero n)
--- source

all: ; @echo '$(word 0,a b c)'

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
--- TODO



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



=== TEST 84: basename
--- source

all: ; @echo '$(basename src/foo.c src-1.0/bar.c hacks)'

--- stdout
src/foo src-1.0/bar hacks
--- success: true



=== TEST 85: basename (empty arg)
--- source

all: ; @echo '$(basename )'

--- stdout eval: "\n"
--- success: true



=== TEST 86: basename
--- source

all: ; @echo '$(basename a.c.v readme.txt foo. bar/)'

--- stdout
a.c readme foo bar/
--- success: true



=== TEST 87: addsuffix
--- source

all: ; @echo '$(addsuffix .c,foo bar)'

--- stdout
foo.c bar.c
--- success: true



=== TEST 88: addsuffix (trailing/leading spaces)
--- source

all: ; @echo '$(addsuffix .c  , foo bar )'

--- stdout
foo.c   bar.c  
--- success: true



=== TEST 89: addsuffix
--- source

all: ; @echo '$(addsuffix .c,a.c.v readme.txt foo. bar/)'

--- stdout
a.c.v.c readme.txt.c foo..c bar/.c
--- success: true



=== TEST 90: addsuffix
--- source

all: ; @echo '$(addsuffix zzz,agent  ~/tmp)'
--- stdout
agentzzz ~/tmpzzz
--- success: true



=== TEST 91: addprefix
--- source

all: ; @echo '$(addprefix src/,foo bar)'

--- stdout
src/foo src/bar
--- success: true



=== TEST 92: addprefix (leading/trailing spaces)
--- source

all: ; @echo '$(addprefix src/ ,  foo  bar  )'

--- stdout
src/ foo src/ bar
--- success: true



=== TEST 93: join
--- source

all:
	@echo '$(join a b,.c .o)'
	@echo '$(join a b,.c)'
	@echo '$(join a b,.c .o .h)'
	@echo '$(join a b,)'
	@echo '$(join , a  b )'

--- stdout
a.c b.o
a.c b
a.c b.o .h
a b
a b
--- success: true



=== TEST 94: wildcard (existing files)
--- touch: foo.c bar.c baz.c global.h
--- source

all:
	@echo '$(sort $(wildcard *.c))'
	@echo '$(sort $(wildcard *.h))'
	@echo '$(sort $(wildcard *b*.[ch]))'

--- stdout
bar.c baz.c foo.c
global.h
bar.c baz.c global.h
--- success: true



=== TEST 95: wildcard (non-existing files)
--- source

all: ; @echo '$(wildcard This_file_not_exist)'
--- stdout eval: "\n"
--- success: true



=== TEST 96: wildcard (~)
--- source

all: ; @echo '$(wildcard ~/*)'

--- stdout_like: /home/[^/]+/\S+.*
--- success: true



=== TEST 97: realpath
--- pre
mkdir 'x';
mkdir 'x/.y';
mkdir 'x/.y/z';
--- source

all: ; @echo '$(realpath x/.y/././/z/../..)'
	@echo '$(realpath x/.y/../.y/././z/..)'

--- stdout preprocess
#PWD#/x
#PWD#/x/.y
--- success: true



=== TEST 98: realpath (non-existing entries)
--- source

all: ; @echo '$(realpath x/.y/././/z/../..)'

--- stdout eval: "\n"
--- success: true



=== TEST 99: abspath
--- source

all: ; @echo '$(abspath ././/a.c)'

--- stdout preprocess
#PWD#/a.c
--- success: true



=== TEST 100: abspath (.. and .)
--- source

all:
	@echo '$(abspath x/.y/././/z/../../)'

--- stdout preprocess
#PWD#/x
--- success: true



=== TEST 101: abspath (plain file)
--- source

all: ; @echo '$(abspath foo.c)'

--- stdout preprocess
#PWD#/foo.c
--- success: true



=== TEST 102: shell (newlines)
--- source

all: ; echo '$(shell echo "hello \nworld!\n")'

--- stdout
echo 'hello  world!'
hello  world!

--- success: true



=== TEST 103: shell (trailing newlines)
--- source

all: ; echo '$(shell echo "hello\n\n")'

--- stdout
echo 'hello'
hello
--- success: true



=== TEST 104: shell (\r\n)
--- source

all: ; echo '$(shell echo "hello, \r\nworld!\r\n")'

--- stdout
echo 'hello,  world!'
hello,  world!

--- success: true



=== TEST 105: shell (\r)
--- source

all: ; @echo '$(shell echo "hello, \rworld!")'

--- stdout eval: "hello, \rworld!\n"
--- success: true



=== TEST 106: shell (stdout not polluted)
--- source

var = $(shell echo "dog cat")
all : ; @echo "$(lastword $(var)) $(firstword $(var))"

--- stdout
cat dog
--- success: true



=== TEST 107: nested shell
--- source

foo := $(shell echo "$(shell echo "hello"), $(shell echo "world")!")
all: ; @echo '$(foo)'

--- stdout
hello, world!

--- success: true



=== TEST 108: if (empty)
--- source

empty =
all: ; @echo '$(if $(empty),yes,no)'
	@echo '$(if  $(empty) , yes , no )'

--- stdout
no
 no 
--- success: true



=== TEST 109: if (space)
--- source

all: ; @echo '$(if $(shell echo " "),yes,no)'

--- stdout
yes
--- success: true



=== TEST 110: if (plain string)
--- source

all: ; echo '$(if okay, yes , no )'

--- stdout
echo ' yes '
 yes 
--- success: true



=== TEST 111: if (empty argument)
--- source

all: ; echo '$(if ,yes,no)'
	echo '$(if ,,no)'
	echo '$(if ,,) found'

--- stdout
echo 'no'
no
echo 'no'
no
echo ' found'
 found

--- success: true



=== TEST 112: if (side-effects)
--- source

foo := $(if okay,$(shell touch foo_yes),$(shell touch foo_no))
bar := $(if ,$(shell touch bar_yes),$(shell touch bar_no))
all: ;

--- found: foo_yes bar_no
--- not_found: foo_no bar_yes
--- success: true



=== TEST 113: if (0 is true)
--- source

all: ; @echo '$(if 0,yes,no)'

--- stdout
yes
--- success: true



=== TEST 114: if (no else)
--- source

output = yes!
all: ; @echo '$(if true,$(output))'
	@echo '$(if ,$(output)) found'

--- stdout
yes!
 found
--- success: true



=== TEST 115: or
--- source

empty =
all: ; echo '$(or $(empty),$(empty))'
	echo '$(or $(empty),second)'
	echo '$(or first,$(empty))'

--- stdout
echo ''

echo 'second'
second
echo 'first'
first
--- success: true



=== TEST 116: or (0 is true)
--- source

empty =
all: ; echo '$(or $(empty),0,2)'

--- stdout
echo '0'
0

--- success: true



=== TEST 117: or (multiple args)
--- source

empty =
all: ; echo '$(or $(empty),$(empty),,foo)'

--- stdout
echo 'foo'
foo
--- success: true



=== TEST 118: or (trim first? Yes!)
--- source

empty =
all: ; echo '$(or $(empty) , other)'

--- stdout
echo 'other'
other
--- success: true



=== TEST 119: or (1 arg)
--- source

empty =
all: ; @echo '$(or foo) $(or $(empty)) found'

--- stdout
foo  found
--- success: true



=== TEST 120: or (0 arg)
--- source

empty =
all: ; @echo '$(or ) found'

--- stdout
 found
--- success: true



=== TEST 121: or (trim after? No!)
--- source

all: ; echo '$(or $(shell echo " "),other) found'

--- stdout
echo '  found'
  found
--- success: true



=== TEST 122: or (nonempty arguments)
--- source

all: ; echo '$(or foo,bar,baz)'

--- stdout
echo 'foo'
foo
--- success: true



=== TEST 123: or (false values)
--- source

empty =
all: ; @echo '$(or $(empty),,$(shell echo ""),foo,bar)'

--- stdout
foo
--- success: true



=== TEST 124: or (side-effects)
--- source

var := $(or $(shell touch a),$(shell touch b),foo,$(shell touch c))
all: ; @echo '$(var)'

--- found: a b
--- not_found: c
--- stdout
foo
--- success: true



=== TEST 125: and
--- source

all: ; echo '$(and a,b,,d) found'

--- stdout
echo ' found'
 found
--- success: true



=== TEST 126: and (0 is true)
--- source

all: ; @echo '$(and a,b,0,d)'

--- stdout
d
--- success: true



=== TEST 127: and (side-effects)
--- source

empty =
var := $(and $(shell touch a && echo a),$(shell touch b && echo b),$(empty),$(shell touch d && echo d))
all: ; @echo '$(var) found'

--- stdout
 found
--- found: a b
--- not_found: d
--- success: true



=== TEST 128: and (spaces before expansion trimmed)
--- source

empty =
all: ; @echo '$(and a,b,  ,d) found'
	@echo '$(and a,b, $(empty) ,d) found'

--- stdout
 found
 found
--- success: true



=== TEST 129: and (spaces after expansion are NOT trimmed)
--- source

all: ; @echo '$(and a,b,$(shell echo " "),d) found'

--- stdout
d found
--- success: true



=== TEST 130: foreach
--- source

var = dude
comma = ,
foo := $(foreach var,a b c,$(var)$(comma))
all:
	@echo '$(foo)'
	@echo '$(var)'

--- stdout
a, b, c,
dude
--- success: true



=== TEST 131: foreach (dynamic binding)
--- source

var = dude
comma = ,
rvar = var
list = a b c
foo := $(foreach $(rvar),$(shell echo "$(list)"),$(var)$(comma))
all:
	@echo '$(foo)'
	@echo '$(var)'

--- stdout
a, b, c,
dude
--- success: true



=== TEST 132: foreach (var not defined initially)
--- source

comma = ,
rvar = var
list = a b c
foo := $(foreach $(rvar),$(shell echo "$(list)"),$(var)$(comma))
all:
	@echo '$(foo)'
	@echo '$(var) found'

--- stdout
a, b, c,
 found
--- success: true
--- TODO



=== TEST 133: error (with args)
--- source

var = found
all: ; echo '$(error hello, world! ) $(var)'

--- stdout
--- stderr preprocess
#MAKEFILE#:2: *** hello, world! .  Stop.
--- error_code: 2



=== TEST 134: error (with nested func refs)
--- source

# this is
 ## a comment
all: ; echo '$(error $(shell echo "hello, world!")) found'

--- stdout
--- stderr preprocess
#MAKEFILE#:3: *** hello, world!.  Stop.
--- error_code: 2



=== TEST 135: error (empty arg)
--- source

all: ; $(error )

--- stdout
--- stderr preprocess
#MAKEFILE#:1: *** .  Stop.
--- error_code: 2



=== TEST 136: warning (with args)
--- source

all: ; echo '$(warning hello, world! ) found'

--- stdout
echo ' found'
 found
--- stderr preprocess
#MAKEFILE#:1: hello, world! 
--- success: true



=== TEST 137: warning (with nested func refs)
--- source

all: ; echo '$(warning $(shell echo "hello, world!")) found'

--- stdout
echo ' found'
 found
--- stderr preprocess
#MAKEFILE#:1: hello, world!
--- success: true



=== TEST 138: warning (empty arg)
--- source

all: ; echo '$(warning ) found'

--- stdout
echo ' found'
 found
--- stderr preprocess
#MAKEFILE#:1: 
--- success: true



=== TEST 139: info (with args)
--- source

all: ; echo '$(info hello, world! ) found'

--- stdout
hello, world! 
echo ' found'
 found
--- stderr
--- success: true



=== TEST 140: info (with nested func refs)
--- source

all: ; echo '$(info $(shell echo "hello, world!")) found'

--- stdout
hello, world!
echo ' found'
 found
--- stderr
--- success: true



=== TEST 141: info (empty arg)
--- source

all: ; @echo 'hey! $(info ) found'

--- stdout eval: "\nhey!  found\n"
--- stderr
--- success: true

