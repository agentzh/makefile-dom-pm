use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: error number
--- source

all:
	-rm cleanit
	-exit 2

--- stdout
rm cleanit
exit 2
--- stderr preprocess
rm: cannot remove `cleanit': No such file or directory
#MAKE#: [all] Error 1 (ignored)
#MAKE#: [all] Error 2 (ignored)
--- error_code
0



=== TEST 2: don't ingore errors by default
--- source

all:
	rm cleanit
	exit 2

--- stdout
rm cleanit
--- stderr preprocess
rm: cannot remove `cleanit': No such file or directory
#MAKE#: *** [all] Error 1
--- error_code
2



=== TEST 3: the --ignore-errors option
--- source

all:
	rm cleanit
	exit 2

--- options: --ignore-errors
--- stdout
rm cleanit
exit 2
--- stderr preprocess
rm: cannot remove `cleanit': No such file or directory
#MAKE#: [all] Error 1 (ignored)
#MAKE#: [all] Error 2 (ignored)
--- error_code
0

