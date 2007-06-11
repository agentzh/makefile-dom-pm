# Description:
#    
#    Test the word, words, wordlist, firstword, and lastword functions.

#
# Details:
#    
#    Produce a variable with a large number of words in it,
#    determine the number of words, and then read each one back.


use t::Gmake;

plan tests => 3 * blocks() - 1;

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source
string  := word.pl general_test2.pl   FORCE.pl word.pl generic_test.perl MAKEFILES_variable.pl
string2 := $(string) $(string) $(string) $(string) $(string) $(string) $(string)
string3 := $(string2) $(string2) $(string2) $(string2) $(string2) $(string2) $(string2)
string4 := $(string3) $(string3) $(string3) $(string3) $(string3) $(string3) $(string3)
all:
	@echo $(words $(string))
	@echo $(words $(string4))
	@echo $(word 1, $(string))
	@echo $(word 100, $(string))
	@echo $(word 1, $(string))
	@echo $(word 1000, $(string3))
	@echo $(wordlist 3, 4, $(string))
	@echo $(wordlist 4, 3, $(string))
	@echo $(wordlist 1, 6, $(string))
	@echo $(wordlist 5, 7, $(string))
	@echo $(wordlist 100, 110, $(string))
	@echo $(wordlist 7, 10, $(string2))

--- stdout
6
2058
word.pl

word.pl

FORCE.pl word.pl

word.pl general_test2.pl FORCE.pl word.pl generic_test.perl MAKEFILES_variable.pl
generic_test.perl MAKEFILES_variable.pl

word.pl general_test2.pl FORCE.pl word.pl

--- stderr



=== TEST 2:
Test error conditions

--- source
FOO = foo bar biz baz

word-e1: ; @echo $(word ,$(FOO))
word-e2: ; @echo $(word abc ,$(FOO))
word-e3: ; @echo $(word 1a,$(FOO))

wordlist-e1: ; @echo $(wordlist ,,$(FOO))
wordlist-e2: ; @echo $(wordlist abc ,,$(FOO))
wordlist-e3: ; @echo $(wordlist 1, 12a ,$(FOO))
--- options:  word-e1
--- stdout

--- stderr preprocess
#MAKEFILE#:3: *** non-numeric first argument to `word' function: ''.  Stop.
--- error_code:  2



=== TEST 3:
--- source ditto
--- options:  word-e2
--- stdout

--- stderr preprocess
#MAKEFILE#:4: *** non-numeric first argument to `word' function: 'abc '.  Stop.
--- error_code:  2



=== TEST 4:
--- source ditto
--- options:  word-e3
--- stdout

--- stderr preprocess
#MAKEFILE#:5: *** non-numeric first argument to `word' function: '1a'.  Stop.
--- error_code:  2



=== TEST 5:
--- source ditto
--- options:  wordlist-e1
--- stdout

--- stderr preprocess
#MAKEFILE#:7: *** non-numeric first argument to `wordlist' function: ''.  Stop.
--- error_code:  2



=== TEST 6:
--- source ditto
--- options:  wordlist-e2
--- stdout

--- stderr preprocess
#MAKEFILE#:8: *** non-numeric first argument to `wordlist' function: 'abc '.  Stop.
--- error_code:  2



=== TEST 7:
--- source ditto
--- options:  wordlist-e3
--- stdout

--- stderr preprocess
#MAKEFILE#:9: *** non-numeric second argument to `wordlist' function: ' 12a '.  Stop.
--- error_code:  2



=== TEST 8:
Test error conditions again, but this time in a variable reference

--- source
FOO = foo bar biz baz

W = $(word $x,$(FOO))
WL = $(wordlist $s,$e,$(FOO))

word-e: ; @echo $(W)
wordlist-e: ; @echo $(WL)
--- options:  word-e x=
--- stdout

--- stderr preprocess
#MAKEFILE#:3: *** non-numeric first argument to `word' function: ''.  Stop.
--- error_code:  2



=== TEST 9:
--- source ditto
--- options:  word-e x=abc
--- stdout

--- stderr preprocess
#MAKEFILE#:3: *** non-numeric first argument to `word' function: 'abc'.  Stop.
--- error_code:  2



=== TEST 10:
--- source ditto
--- options:  word-e x=0
--- stdout

--- stderr preprocess
#MAKEFILE#:3: *** first argument to `word' function must be greater than 0.  Stop.
--- error_code:  2



=== TEST 11:
--- source ditto
--- options:  wordlist-e s= e=
--- stdout

--- stderr preprocess
#MAKEFILE#:4: *** non-numeric first argument to `wordlist' function: ''.  Stop.
--- error_code:  2



=== TEST 12:
--- source ditto
--- options:  wordlist-e s=abc e=
--- stdout

--- stderr preprocess
#MAKEFILE#:4: *** non-numeric first argument to `wordlist' function: 'abc'.  Stop.
--- error_code:  2



=== TEST 13:
--- source ditto
--- options:  wordlist-e s=4 e=12a
--- stdout

--- stderr preprocess
#MAKEFILE#:4: *** non-numeric second argument to `wordlist' function: '12a'.  Stop.
--- error_code:  2



=== TEST 14:
--- source ditto
--- options:  wordlist-e s=0 e=12
--- stdout

--- stderr preprocess
#MAKEFILE#:4: *** invalid first argument to `wordlist' function: `0'.  Stop.
--- error_code:  2



=== TEST #8 -- test $(firstword )
--- source

void :=
list := $(void) foo bar baz #

a := $(word 1,$(list))
b := $(firstword $(list))

.PHONY: all

all:
	@test "$a" = "$b" && echo $a

--- stdout
foo
--- stderr
--- error_code:  0



=== TEST #9 -- test $(lastword )
--- source

void :=
list := $(void) foo bar baz #

a := $(word $(words $(list)),$(list))
b := $(lastword $(list))

.PHONY: all

all:
	@test "$a" = "$b" && echo $a

--- stdout
baz
--- stderr
--- error_code:  0

