# Description:
#    The following test creates a makefile to test command 
#    echoing.  It tests that when a command line starts with 
#    a '@', the echoing of that line is suppressed.  It also 
#    tests the -n option which tells make to ONLY echo the  
#    commands and no execution happens.  In this case, even 
#    the commands with '@' are printed. Lastly, it tests the 
#    -s flag which tells make to prevent all echoing, as if 
#    all commands started with a '@'.
#
# Details:
#    This test is similar to the 'clean' test except that a '@' has
#    been placed in front of the delete command line.  Four tests 
#    are run here.  First, make is run normally and the first echo
#    command should be executed.  In this case there is no '@' so 
#    we should expect make to display the command AND display the 
#    echoed message.  Secondly, make is run with the clean target, 
#    but since there is a '@' at the beginning of the command, we
#    expect no output; just the deletion of a file which we check 
#    for.  Third, we give the clean target again except this time
#    we give make the -n option.  We now expect the command to be 
#    displayed but not to be executed.  In this case we need only 
#    to check the output since an error message would be displayed
#    if it actually tried to run the delete command again and the 
#    file didn't exist. Lastly, we run the first test again with 
#    the -s option and check that make did not echo the echo 
#    command before printing the message.

use t::Gmake;

plan tests => 3 * blocks() + 1;

use_source_ditto;

run_tests;

__DATA__

=== TEST #1
--- source
all: 
	echo This makefile did not clean the dir... good
clean: 
	@rm EXAMPLE_FILE

--- touch:  EXAMPLE_FILE
--- stdout
echo This makefile did not clean the dir... good
This makefile did not clean the dir... good

--- stderr
--- error_code:  0



=== TEST 2:
TEST #2n

--- source ditto
--- touch:  EXAMPLE_FILE
--- goals:  clean
--- stdout

--- stderr
--- error_code:  0
--- not_found:  EXAMPLE_FILE



=== TEST #3
--- source ditto
--- touch:  EXAMPLE_FILE
--- goals:  clean
--- options:  -n
--- stdout
rm EXAMPLE_FILE

--- stderr
--- error_code:  0



=== TEST #4
--- source ditto
--- touch:  EXAMPLE_FILE
--- options:  -s
--- stdout
This makefile did not clean the dir... good

--- stderr
--- error_code:  0

