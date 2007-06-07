use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1
--- source
define foo
@echo First comes the definition.
@echo Then comes the override.
endef
all: 
	$(foo)
--- options:      'foo=echo hello'
--- stdout
echo hello
hello
--- stderr
--- error_code: 0



=== TEST 2
--- source
override define foo
    echo First comes the definition.
    echo Then comes the override.
endef
all: 
	@$(foo)
--- options:      foo=Hello
--- stdout
First comes the definition.
Then comes the override.
--- stderr
--- error_code: 0



=== TEST 3
--- source
override define foo
-exit 1
exit 1
endef
all:
	@$(foo)
--- options:      foo=Hello
--- stdout
--- stderr preprocess
#MAKE#: [all] Error 1 (ignored)
#MAKE#: *** [all] Error 1
--- error_code: 2


