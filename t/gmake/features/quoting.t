#: quoting.t
#:
#: Description:
#:   The following test creates a makefile to test using
#:   quotes within makefiles.
#: Details:
#:
#: 2006-02-13 2006-02-13

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 0:
The first line is actually a no-op since we're always using 
Bourne Shell by passing `SHELL=script/sh' via the command
line
--- source
SHELL = /bin/sh
TEXFONTS = NICEFONT
DEFINES = -DDEFAULT_TFM_PATH=\".:$(TEXFONTS)\"
test: ; @"echo" 'DEFINES = $(DEFINES)'
--- stdout
DEFINES = -DDEFAULT_TFM_PATH=\".:NICEFONT\"
--- stderr
--- success:            true
