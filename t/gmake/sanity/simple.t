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

