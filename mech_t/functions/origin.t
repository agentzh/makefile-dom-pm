# Description:
#    Test the origin function.
#
# Details:
#    This is a test of the origin function in gnu make.
#    This function will report on where a variable was
#    defined per the following list:
#    
#    'undefined'            never defined
#    'default'              default definition
#    'environment'          environment var without -e
#    'environment override' environment var with    -e
#    'file'                 defined in makefile
#    'command line'         defined on the command line
#    'override'             defined by override in makefile
#    'automatic'            Automatic variable


use t::Gmake;

plan tests => 3 * blocks();

run_tests;

__DATA__

=== TEST 1:
Set an environment variable

--- source

foo := bletch garf
auto_var = undefined CC MAKETEST MAKE foo CFLAGS WHITE @
av = $(foreach var, $(auto_var), $(origin $(var)) )
override WHITE := BLACK
all: auto
	@echo $(origin undefined)
	@echo $(origin CC)
	@echo $(origin MAKETEST)
	@echo $(origin MAKE)
	@echo $(origin foo)
	@echo $(origin CFLAGS)
	@echo $(origin WHITE)
	@echo $(origin @)
auto :
	@echo $(av)

--- pre:  $::ExtraENV{'MAKETEST'} = '1';
--- options:  -e WHITE=WHITE CFLAGS=
--- stdout
undefined default environment default file command line override automatic
undefined
default
environment
default
file
command line
override
automatic
--- stderr
--- error_code:  0

