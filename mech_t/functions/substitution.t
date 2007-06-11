# Description:
#    Test the subst and patsubst functions
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
Generic patsubst test: test both the function and variable form.

--- source

foo := a.o b.o c.o
bar := $(foo:.o=.c)
bar2:= $(foo:%.o=%.c)
bar3:= $(patsubst %.c,%.o,x.c.c bar.c)
all:;@echo $(bar); echo $(bar2); echo $(bar3)
--- stdout
a.c b.c c.c
a.c b.c c.c
x.c.o bar.o
--- stderr
--- error_code:  0



=== TEST 2:
Patsubst without '%'--shouldn't match because the whole word has to match
in patsubst.  Based on a bug report by Markus Mauhart <qwe123@chello.at>

--- source
all:;@echo $(patsubst Foo,Repl,FooFoo)
--- stdout
FooFoo
--- stderr
--- error_code:  0



=== TEST 3:
Variable subst where a pattern matches multiple times in a single word.
Based on a bug report by Markus Mauhart <qwe123@chello.at>

--- source

A := fooBARfooBARfoo
all:;@echo $(A:fooBARfoo=REPL)
--- stdout
fooBARREPL
--- stderr
--- error_code:  0

