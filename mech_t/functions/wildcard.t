# Description:
#    The following test creates a makefile to test wildcard
#    expansions and the ability to put a command on the same
#    line as the target name separated by a semi-colon.
#
# Details:
#    
#    This test creates 4 files by the names of 1.example,
#    two.example and 3.example.  We execute three tests.  The first
#    executes the print1 target which tests the '*' wildcard by
#    echoing all filenames by the name of '*.example'.  The second
#    test echo's all files which match '?.example' and
#    [a-z0-9].example.  Lastly we clean up all of the files using
#    the '*' wildcard as in the first test

use t::Gmake;

plan tests => 3 * blocks() + 1;

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
--- source
.PHONY: print1 print2 clean
print1: ;@echo $(sort $(wildcard example.*))
print2:
	@echo $(sort $(wildcard example.?))
	@echo $(sort $(wildcard example.[a-z0-9]))
	@echo $(sort $(wildcard example.[!A-Za-z_\!]))
clean:
	rm $(sort $(wildcard example.*))

--- touch:  example._ example.for example.3 example.1 example.two
--- goals:  print1
--- stdout
example.1 example.3 example._ example.for example.two

--- stderr



=== TEST #2
--- source ditto
--- touch:  example._ example.for example.3 example.1 example.two
--- goals:  print2
--- stdout
example.1 example.3 example._
example.1 example.3
example.1 example.3

--- stderr



=== TEST #3
--- source ditto
--- touch:  example._ example.for example.3 example.1 example.two
--- goals:  clean
--- stdout
rm example.1 example.3 example._ example.for example.two

--- stderr
--- not_found:  example.1 example.two example.3 example.for

