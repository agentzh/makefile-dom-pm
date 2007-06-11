# Description:
#    
#    The following test creates a makefile to test the presence
#    of multiple rules for one target.  One file can be the
#    target of several rules if at most one rule has commands;
#    the other rules can only have dependencies.
#
# Details:
#    
#    The makefile created in this test contains two hardcoded rules
#    for foo.o and bar.o.  It then gives another multiple target rule
#    with the same names as above but adding more dependencies.
#    Additionally, another variable extradeps is listed as a
#    dependency but is defined to be null.  It can however be defined
#    on the make command line as extradeps=extra.h which adds yet
#    another dependency to the targets.

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST 1:
--- source
objects = foo.o bar.o
foo.o : defs.h
bar.o : defs.h test.h
extradeps = 
$(objects) : config.h $(extradeps) 
	@echo EXTRA EXTRA

--- touch:  config.h defs.h test.h
--- options:  extradeps=extra.h
--- stdout

--- stderr preprocess
#MAKE#: *** No rule to make target `extra.h', needed by `foo.o'.  Stop.

--- error_code:  2



=== TEST #2
--- source ditto
--- touch:  config.h defs.h extra.h test.h
--- options:  extradeps=extra.h
--- stdout
EXTRA EXTRA

--- stderr
--- error_code:  0

