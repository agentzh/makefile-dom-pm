#: comments2.t
#: some complementary tests for comments.t
#: 2006-02-10 2006-02-14

use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: When the comment is not continued to the next line, the first echo command should be executed
--- source
# Test comment vs semicolon parsing and line continuation
target: # this ; is just a comment
	@echo This is within a comment. 
	@echo There should be no errors for this makefile.
--- stdout
This is within a comment.
There should be no errors for this makefile.
--- stderr
--- error_code
0



=== TEST 2: When there's no comment at all, `make' should complaint that it doesn't know how to make `this'.
--- source
# Test comment vs semicolon parsing and line continuation
target: this ; is just a comment
	@echo This is within a comment. 
	@echo There should be no errors for this makefile.
--- stdout
--- stderr preprocess
#MAKE#: *** No rule to make target `this', needed by `target'.  Stop.
--- success:    false



=== TEST 3: Comment that spans multiple lines
--- source
# Test comment vs semicolon parsing and line continuation
target: # this ; is just a comment \
	@echo This is within a comment. \
	@echo There should be no errors for this makefile.
--- stdout preprocess
#MAKE#: Nothing to be done for `target'.
--- stderr
--- success:    true

