#: mult_rules2.t
#: Extension to mult_rules.t
#: Copyright (c) 2006 Agent Zhang

use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1: Which is the default goal?
--- touch:        extra.h defs.h test.h config.h
--- options:      extradeps=extra.h
--- source
objects = foo.o bar.o
foo.o : defs.h
bar.o : defs.h test.h
extradeps = 
$(objects) : config.h $(extradeps) 
	@echo $@

--- stderr
--- stdout
foo.o
--- success:      true



=== TEST 2: simple
--- touch:        defs.h
--- source
foo.o: defs.h
foo.o: test.h
	@echo hello
--- stderr preprocess
#MAKE#: *** No rule to make target `test.h', needed by `foo.o'.  Stop.
--- stdout
--- success:      false



=== TEST 3: ditto, but another environment
--- touch:        test.h
--- source
foo.o: defs.h
foo.o: test.h
	@echo hello
--- stderr preprocess
#MAKE#: *** No rule to make target `defs.h', needed by `foo.o'.  Stop.
--- stdout
--- success:      false



=== TEST 4: ditto, but yet another configuration
--- touch:        defs.h test.h
--- source
foo.o: defs.h
foo.o: test.h
	@echo hello
--- stderr
--- stdout
hello
--- success:      true



=== TEST 5: two rules for the same target, both with commands
--- touch:        defs.h test.h
--- filename:     abc.mk
--- source
foo.o: defs.h
	@echo fail!
foo.o: test.h
	@echo no,no,no
--- stderr
abc.mk:4: warning: overriding commands for target `foo.o'
abc.mk:2: warning: ignoring old commands for target `foo.o'
--- stdout
no,no,no
--- success:      true

