# Description:
#    Test load balancing (-l) option.
#
# Details:
#    
#    This test creates a makefile where all depends on three rules
#    which contain the same body.  Each rule checks for the existence
#    of a temporary file; if it exists an error is generated.  If it
#    doesn't exist then it is created, the rule sleeps, then deletes
#    the temp file again.  Thus if any of the rules are run in
#    parallel the test will fail.  When make is called in this test,
#    it is given the -l option with a value of 0.0001.  This ensures
#    that the load will be above this number and make will therefore
#    decide that it cannot run more than one job even though -j 4 was
#    also specified on the command line.

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__


