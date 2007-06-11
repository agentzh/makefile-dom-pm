# Description:
#    This script tests to make sure that Make looks for
#    default makefiles in the correct order (GNUmakefile,makefile,Makefile)
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 3;

run_tests;

__DATA__

=== TEST 1:
Create a makefile called "GNUmakefile"
DOS/WIN32 platforms preserve case, but Makefile is the same file as makefile.
Just test what we can here (avoid Makefile versus makefile test).
Create another makefile called "Makefile"

--- filename:  
--- stdout
It chose GNUmakefile

--- stderr



=== TEST 2:
--- filename:  
--- stdout
It chose makefile

--- stderr



=== TEST 3:
--- filename:  
--- stdout
It chose Makefile

--- stderr

