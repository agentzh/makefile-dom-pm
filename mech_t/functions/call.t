# Description:
#    Test the call function.

#
# Details:
#    Try various uses of call and ensure they all give the correct
#    results.


use t::Gmake;

plan tests => 3 * blocks() - 2;

run_tests;

__DATA__

=== TEST 1:
These won't work until/unless PR/1527 is resolved.
echo '$(call my-foreach,a,x y z,$(a)$(a))'; \
echo '$(call my-if,,$(warning don't print this),ok)'
$answer = "xx yy zz\nok\n";

--- source
# Simple, just reverse two things
#
reverse = $2 $1

# A complex `map' function, using recursive `call'.
#
map = $(foreach a,$2,$(call $1,$a))

# Test using a builtin; this is silly as it's simpler to do without call
#
my-notdir = $(call notdir,$(1))

# Test using non-expanded builtins
#
my-foreach = $(foreach $(1),$(2),$(3))
my-if      = $(if $(1),$(2),$(3))

# Test recursive invocations of call with different arguments
#
one = $(1) $(2) $(3)
two = $(call one,$(1),foo,$(2))

# Test recursion on the user-defined function.  As a special case make
# won't error due to this.
# Implement transitive closure using $(call ...)
#
DEP_foo = bar baz quux
DEP_baz = quux blarp
rest = $(wordlist 2,$(words ${1}),${1})
tclose = $(if $1,$(firstword $1) \
		$(call tclose,$(sort ${DEP_$(firstword $1)} $(call rest,$1))))

all: ; @echo '$(call reverse,bar,foo)'; \
        echo '$(call map,origin,MAKE reverse map)'; \
        echo '$(call my-notdir,a/b   c/d      e/f)'; \
        echo '$(call my-foreach)'; \
        echo '$(call my-foreach,a,,,)'; \
        echo '$(call my-if,a,b,c)'; \
        echo '$(call two,bar,baz)'; \
	echo '$(call tclose,foo)'




--- stdout
foo bar
default file file
b d f


b
bar foo baz
foo bar baz blarp quux 

--- stderr



=== TEST 2:
TEST eclipsing of arguments when invoking sub-calls

--- source

all = $1 $2 $3 $4 $5 $6 $7 $8 $9

level1 = $(call all,$1,$2,$3,$4,$5)
level2 = $(call level1,$1,$2,$3)
level3 = $(call level2,$1,$2,$3,$4,$5)

all:
	@echo $(call all,1,2,3,4,5,6,7,8,9,10,11)
	@echo $(call level1,1,2,3,4,5,6,7,8)
	@echo $(call level2,1,2,3,4,5,6,7,8)
	@echo $(call level3,1,2,3,4,5,6,7,8)

--- stdout
1 2 3 4 5 6 7 8 9
1 2 3 4 5
1 2 3
1 2 3

--- stderr

