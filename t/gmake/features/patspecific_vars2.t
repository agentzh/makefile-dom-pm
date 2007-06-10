use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: basics
--- source

FOO = foo
all: FOO = one
all: ; @echo $(FOO)

--- stdout
one
--- stderr
--- error_code:  0



=== TEST 2: reverse the order
--- source

all: ; @echo ${FOO}
all: FOO = one
FOO = foo

--- stdout
one
--- stderr
--- error_code:  0



=== TEST 3: recursively-expanded var
--- source

all: FOO = $(BAR)
BAR = bar
all: ; @echo '$(FOO) got'

--- stdout
bar got
--- stderr
--- error_code:  0



=== TEST 4: simply-expanded variables
--- source

all: FOO := $(BAR)
BAR = bar
all: ; @echo '$(FOO) got'

--- stdout
 got
--- stderr
--- error_code:  0



=== TEST 5: cmd line vars take the precedence
--- source

all: FOO = foo
all: ; @echo $(FOO)

--- options:  FOO=cmd
--- stdout
cmd
--- stderr
--- error_code:  0



=== TEST 6: override cmd line vars
--- source

all: override FOO = foo
all: ; @echo $(FOO)
--- options:  FOO=cmd
--- stdout
foo
--- stderr
--- error_code:  0



=== TEST 7: var inheritance
--- source

all: FOO = one
all: one
one: ; @echo $(FOO)
FOO = foo

--- stdout
one
--- stderr
--- error_code:  0



=== TEST 8: destry while leaving the scope
--- source

all: one two
one: FOO = foo
one:
two: ; @echo '$(FOO) got'

--- stdout
 got
--- stderr
--- error_code:  0



=== TEST 9: error...
no rule leaks from the DB output
--- source

all: one two
one: FOO = foo
two: ; @echo '$(FOO) got'

--- stdout
--- stderr preprocess
#MAKE#: *** No rule to make target `one', needed by `all'.  Stop.
--- error_code:  2



=== TEST 10: override vars from inheritance
--- source

all: FOO = foo
all: one

one: FOO = new
one: two

two: ; @echo '$(FOO) got'

--- stdout
new got
--- stderr
--- error_code:  0



=== TEST 11: override vars of oneself
--- source

all: FOO = foo
all: FOO = new
all: ; @echo $(FOO)

--- stdout
new
--- stderr
--- error_code:  0



=== TEST 12: multiple target-specific vars for the same target
--- source

all:FOO=foo
all:BAR=bar
all:;@echo $(FOO) $(BAR)

--- stdout
foo bar
--- stderr
--- error_code:  0



=== TEST 13: +=
--- source

FOO = foo
all: FOO += one
all: ; @echo $(FOO)

--- stdout
foo one
--- stderr
--- error_code:  0



=== TEST 14: +=
--- source

FOO = foo
default: all any
all: FOO += one
all: FOO += two
all: BAR = bar
all: FOO += three
all: BAR += baz
all: ; @echo $(FOO); echo $(BAR)
any: ; @echo $(FOO); echo $(BAR) end

--- stdout
foo one two three
bar baz
foo
end
--- stderr
--- error_code:  0



=== TEST 15: ?=
--- source

FOO = foo
all: FOO ?= bar
all: ; @echo $(FOO)

--- stdout
foo
--- stderr
--- error_code:  0


