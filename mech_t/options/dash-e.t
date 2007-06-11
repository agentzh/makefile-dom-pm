# Description:
#    The following test creates a makefile to ...
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
GOOGLE = bazzle
all:; @echo "$(GOOGLE)"


--- pre:  $::ExtraENV{'GOOGLE'} = 'boggle';
--- options:  -e
--- stdout
boggle

--- stderr

