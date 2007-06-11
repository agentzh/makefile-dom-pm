# Description:
#    Check GNU make export/unexport commands.
#
# Details:
#    

use t::Gmake;

plan tests => 3 * blocks();

use_source_ditto;

run_tests;

__DATA__

=== TEST 0: basics
The test driver cleans out our environment for us so we don't have to worry
about that here.

--- source

FOO = foo
BAR = bar
BOZ = boz

export BAZ = baz
export BOZ

BITZ = bitz
BOTZ = botz

export BITZ BOTZ
unexport BOTZ

ifdef EXPORT_ALL
export
endif

ifdef UNEXPORT_ALL
unexport
endif

ifdef EXPORT_ALL_PSEUDO
.EXPORT_ALL_VARIABLES:
endif

all:
	@echo "FOO=$(FOO) BAR=$(BAR) BAZ=$(BAZ) BOZ=$(BOZ) BITZ=$(BITZ) BOTZ=$(BOTZ)"
	@echo "FOO=$$FOO BAR=$$BAR BAZ=$$BAZ BOZ=$$BOZ BITZ=$$BITZ BOTZ=$$BOTZ"


--- stdout
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=botz
FOO= BAR= BAZ=baz BOZ=boz BITZ=bitz BOTZ=

--- stderr
--- error_code:  0



=== TEST 1: make sure vars inherited from the parent are exported
--- source ditto

--- pre:  $::ExtraENV{'FOO'} = '1';
--- stdout
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=botz
FOO=foo BAR= BAZ=baz BOZ=boz BITZ=bitz BOTZ=

--- stderr
--- error_code:  0



=== TEST 2: global export.  Explicit unexport takes precedence.
--- source ditto

--- pre:  $::ExtraENV{'FOO'} = '1';
--- options:  EXPORT_ALL=1
--- stdout
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=botz
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=

--- stderr
--- error_code:  0



=== TEST 3: global unexport.  Explicit export takes precedence.
--- source ditto

--- pre:  $::ExtraENV{'FOO'} = '1';
--- options:  UNEXPORT_ALL=1
--- stdout
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=botz
FOO= BAR= BAZ=baz BOZ=boz BITZ=bitz BOTZ=

--- stderr
--- error_code:  0



=== TEST 4: both: in the above makefile the unexport comes last so that rules.
--- source ditto

--- pre:  $::ExtraENV{'FOO'} = '1';
--- options:  EXPORT_ALL=1 UNEXPORT_ALL=1
--- stdout
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=botz
FOO= BAR= BAZ=baz BOZ=boz BITZ=bitz BOTZ=

--- stderr
--- error_code:  0



=== TEST 5: test the pseudo target.
--- source ditto

--- pre:  $::ExtraENV{'FOO'} = '1';
--- options:  EXPORT_ALL_PSEUDO=1
--- stdout
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=botz
FOO=foo BAR=bar BAZ=baz BOZ=boz BITZ=bitz BOTZ=

--- stderr
--- error_code:  0



=== TEST 6: Test the expansion of variables inside export
--- source

foo = f-ok
bar = b-ok

FOO = foo
F = f

BAR = bar
B = b

export $(FOO)
export $(B)ar

all:
	@echo foo=$(foo) bar=$(bar)
	@echo foo=$$foo bar=$$bar



--- pre:  $::ExtraENV{'FOO'} = '1';
--- stdout
foo=f-ok bar=b-ok
foo=f-ok bar=b-ok

--- stderr
--- error_code:  0



=== TEST 7: Test the expansion of variables inside unexport
--- source

foo = f-ok
bar = b-ok

FOO = foo
F = f

BAR = bar
B = b

export foo bar

unexport $(FOO)
unexport $(B)ar

all:
	@echo foo=$(foo) bar=$(bar)
	@echo foo=$$foo bar=$$bar



--- pre:  $::ExtraENV{'FOO'} = '1';
--- stdout
foo=f-ok bar=b-ok
foo= bar=

--- stderr
--- error_code:  0



=== TEST 7: Test exporting multiple variables on the same line
--- source

A = a
B = b
C = c
D = d
E = e
F = f
G = g
H = h
I = i
J = j

SOME = A B C

export F G H I J

export D E $(SOME)

all: ; @echo A=$$A B=$$B C=$$C D=$$D E=$$E F=$$F G=$$G H=$$H I=$$I J=$$J


--- pre:  $::ExtraENV{'FOO'} = '1';
--- stdout
A=a B=b C=c D=d E=e F=f G=g H=h I=i J=j

--- stderr
--- error_code:  0



=== TEST 8: Test unexporting multiple variables on the same line
--- source

A = a
B = b
C = c
D = d
E = e
F = f
G = g
H = h
I = i
J = j

SOME = A B C

unexport F G H I J

unexport D E $(SOME)

all: ; @echo A=$$A B=$$B C=$$C D=$$D E=$$E F=$$F G=$$G H=$$H I=$$I J=$$J


--- pre
$::ExtraENV{'F'} = '6';
$::ExtraENV{'A'} = '1';
$::ExtraENV{'J'} = '10';
$::ExtraENV{'E'} = '5';
$::ExtraENV{'B'} = '2';
$::ExtraENV{'H'} = '8';
$::ExtraENV{'C'} = '3';
$::ExtraENV{'D'} = '4';
$::ExtraENV{'I'} = '9';
$::ExtraENV{'G'} = '7';
$::ExtraENV{'FOO'} = '1';
--- stdout
A= B= C= D= E= F= G= H= I= J=

--- stderr
--- error_code:  0

