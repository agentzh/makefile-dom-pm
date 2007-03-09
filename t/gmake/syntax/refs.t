use t::Gmake;

plan tests => 2 * blocks;

run_tests;

__DATA__

=== TEST 1: order
reference expansion happens *after* function parsing
--- source

foo = %.o,a.c b.c
bar = $(patsubst %.c,$(foo))

all: ; echo '$(bar)'

--- stdout
--- stderr preprocess
#MAKEFILE#:2: *** insufficient number of arguments (2) to function `patsubst'.  Stop.

