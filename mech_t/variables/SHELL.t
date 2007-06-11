# Description:
#    Test proper handling of SHELL.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
Find the default value when SHELL is not set.  On UNIX it will be /bin/sh,
but on other platforms who knows?
According to POSIX, the value of SHELL in the environment has no impact on
the value in the makefile.
Note %extraENV takes precedence over the default value for the shell.

--- source
all:;@echo "$(SHELL)"

--- pre:  $::ExtraENV{'SHELL'} = '/dev/null';
--- stdout
/bin/sh
--- stderr
--- error_code:  0



=== TEST 2:
According to POSIX, any value of SHELL set in the makefile should _NOT_ be
exported to the subshell!  I wanted to set SHELL to be $^X (perl) in the
makefile, but make runs $(SHELL) -c 'commandline' and that doesn't work at
all when $(SHELL) is perl :-/.  So, we just add an extra initial /./ which
works well on UNIX and seems to work OK on at least some non-UNIX systems.

--- source
SHELL := /.//bin/sh

all:;@echo "$(SHELL) $$SHELL"


--- pre:  $::ExtraENV{'SHELL'} = '/bin/sh';
--- stdout
/.//bin/sh /bin/sh
--- stderr
--- error_code:  0



=== TEST 3:
As a GNU make extension, if make's SHELL variable is explicitly exported,
then we really _DO_ export it.

--- source
export SHELL := /.//bin/sh

all:;@echo "$(SHELL) $$SHELL"


--- pre:  $::ExtraENV{'SHELL'} = '/bin/sh';
--- stdout
/.//bin/sh /.//bin/sh
--- stderr
--- error_code:  0



=== TEST 4:
Test out setting of SHELL, both exported and not, as a target-specific
variable.

--- source
all: SHELL := /.//bin/sh

all:;@echo "$(SHELL) $$SHELL"


--- pre:  $::ExtraENV{'SHELL'} = '/bin/sh';
--- stdout
/.//bin/sh /bin/sh
--- stderr
--- error_code:  0



=== TEST 5:
--- source
all: export SHELL := /.//bin/sh

all:;@echo "$(SHELL) $$SHELL"


--- pre:  $::ExtraENV{'SHELL'} = '/bin/sh';
--- stdout
/.//bin/sh /bin/sh
--- stderr
--- error_code:  0

