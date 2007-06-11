# Description:
#    Test the -C option to GNU make.
#
# Details:
#    
#    This test is similar to the clean test except that this test creates the file
#    to delete in the work directory instead of the current directory.  Make is
#    called from another directory using the -C workdir option so that it can both
#    find the makefile and the file to delete in the work directory.

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__


