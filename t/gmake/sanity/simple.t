use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: set_make
--- options: -f /no/no/no
--- stdout
--- stderr preprocess
#MAKE#: /no/no/no: No such file or directory
#MAKE#: *** No rule to make target `/no/no/no'.  Stop.
--- error_code: 2



=== TEST 2:
cmd modifiers are recognized after variable
expansion
--- source
NOECHO = @
CMD = echo 'hello, world!'
all:
	$(NOECHO) $(CMD)
--- stdout
hello, world!
--- stderr
--- error_code: 0



=== TEST 3: recursive vars (deep)
--- source
foo = hello
bar = $(foo), world
baz = $(bar)!

all:;@echo '$(baz)'

--- stdout
hello, world!
--- stderr
--- error_code: 0



=== TEST 4: stacked cmd modifiers
--- source
all:
	@ - exit 1
	-@ exit 1
	@-exit 1
--- stderr preprocess
#MAKE#: [all] Error 1 (ignored)
#MAKE#: [all] Error 1 (ignored)
#MAKE#: [all] Error 1 (ignored)

--- stdout
--- error_code: 0



=== TEST 5: canned seq of commands
the last newline should be excluded from
the verbatim variable's value
--- source
define foo
    echo wow
    echo '
endef

all:; $(foo)hello'

--- stdout
echo wow
wow
echo 'hello'
hello
--- stderr
--- error_code: 0



=== TEST 6: Simple implicit rule
--- source
all: foo.c

%.c : %.in
	touch $*.c

foo.in: ; @:
--- stdout
touch foo.c
--- stderr
--- error_code: 0

