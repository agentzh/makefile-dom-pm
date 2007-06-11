# Description:
#    The following tests the -i option and the '-' in front of 
#    commands to test that make ignores errors in these commands
#    and continues processing.
#
# Details:
#    This test runs two makes.  The first runs on a target with a 
#    command that has a '-' in front of it (and a command that is 
#    intended to fail) and then a delete command after that is 
#    intended to succeed.  If make ignores the failure of the first
#    command as it is supposed to, then the second command should 
#    delete a file and this is what we check for.  The second make
#    that is run in this test is identical except that the make 
#    command is given with the -i option instead of the '-' in 
#    front of the command.  They should run the same. 

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
If make acted as planned, it should ignore the error from the first
command in the target and execute the second which deletes the file "foo"
This file, therefore, should not exist if the test PASSES.
The output for this on VOS is too hard to replicate, so we only check it
on unix.

--- source
clean:
	-rm cleanit
	rm foo
clean2: 
	rm cleanit
	rm foo

--- touch:  foo
--- stdout
rm cleanit
rm foo

--- stderr preprocess
rm: cannot remove `cleanit': No such file or directory
#MAKE#: [clean] Error 1 (ignored)

--- not_found:  foo



=== TEST #2
--- source ditto
--- touch:  foo
--- goals:  clean2
--- options:  -i
--- stdout
rm cleanit
rm foo

--- stderr preprocess
rm: cannot remove `cleanit': No such file or directory
#MAKE#: [clean2] Error 1 (ignored)

--- not_found:  foo

