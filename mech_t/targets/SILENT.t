# Description:
#    The following tests the special target .SILENT.  By simply
#    mentioning this as a target, it tells make not to print
#    commands before executing them.
#
# Details:
#    This test is the same as the clean test except that it should
#    not echo its command before deleting the specified file.


use t::Gmake;

plan tests => 3 * blocks() + 1;

run_tests;

__DATA__

=== TEST 1:
--- source
.SILENT : clean
clean: 
	rm EXAMPLE_FILE

--- touch:  EXAMPLE_FILE
--- goals:  clean
--- stdout
--- stderr
--- error_code:  0
--- not_found:  EXAMPLE_FILE

