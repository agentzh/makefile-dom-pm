# Description:
#    Test the and & or functions.

#
# Details:
#    Try various uses of and & or to ensure they all give the correct
#    results.


use t::Gmake;

plan tests => 3 * blocks() - 2;

run_tests;

__DATA__

=== TEST #0
For 1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4and ...), it will either be empty or the last value

--- source

NEQ = $(subst $1,,$2)
f =
t = true

all:
	@echo 1 $(and    ,$t)
	@echo 2 $(and $t)
	@echo 3 $(and $t,)
	@echo 4 $(and z,true,$f,false)
	@echo 5 $(and $t,$f,$(info bad short-circuit))
	@echo 6 $(and $(call NEQ,a,b),true)
	@echo 7 $(and $(call NEQ,a,a),true)
	@echo 8 $(and z,true,fal,se) hi
	@echo 9 $(and ,true,fal,se)there
	@echo 10 $(and   $(e) ,$t)
--- stdout
1
2 true
3
4
5
6 true
7
8 se hi
9 there
10

--- stderr



=== TEST #1
For 1000 1001 1000 118 114 113 111 110 46 44 30 29 25 24 20 4or ...), it will either be empty or the first true value

--- source

NEQ = $(subst $1,,$2)
f =
t = true

all:
	@echo 1 $(or    ,    )
	@echo 2 $(or $t)
	@echo 3 $(or ,$t)
	@echo 4 $(or z,true,$f,false)
	@echo 5 $(or $t,$(info bad short-circuit))
	@echo 6 $(or $(info short-circuit),$t)
	@echo 7 $(or $(call NEQ,a,b),true)
	@echo 8 $(or $(call NEQ,a,a),true)
	@echo 9 $(or z,true,fal,se) hi
	@echo 10 $(or ,true,fal,se)there
	@echo 11 $(or   $(e) ,$f)
--- stdout
short-circuit
1
2 true
3 true
4 z
5 true
6 true
7 b
8 true
9 z hi
10 truethere
11

--- stderr

