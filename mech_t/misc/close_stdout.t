# Description:
#    Make sure make exits with an error if stdout is full.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
--- source

--- options:  -v > /dev/full
--- stdout preprocess
#MAKE#: write error
--- stderr
--- error_code:  1

