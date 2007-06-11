# Description:
#    The following test creates a makefile to test using 
#    quotes within makefiles.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks() - 1;

run_tests;

__DATA__

=== TEST 1:
--- source
SHELL = /bin/sh
TEXFONTS = NICEFONT
DEFINES = -DDEFAULT_TFM_PATH=\".:$(TEXFONTS)\"
test: ; @"echo" 'DEFINES = $(DEFINES)'

--- stdout
DEFINES = -DDEFAULT_TFM_PATH=\".:NICEFONT\"

--- stderr

