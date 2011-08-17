#: escape2.t
#: extention of escape.t
#: Copyright (c) 2006 Zhang "agentzh" Yichun
#: 2006-02-10 2006-02-14

use t::Gmake;

plan tests => 3 * blocks;

run_tests;

__DATA__

=== TEST 1: The `#' in the command is really part of the shell
--- source
sharp: foo\#bar.ext
foo\#bar.ext: ; @echo foo#bar.ext = '$@'
--- stdout
foo#bar.ext = foo#bar.ext
--- stderr
--- success:        true



=== TEST 2: When the escape char for `#' is also escaped...
--- source
sharp: foo\\#bar.ext
foo\#bar.ext: ; @echo foo#bar.ext = '$@'
--- stdout
--- stderr preprocess
#MAKE#: *** No rule to make target `foo\', needed by `sharp'.  Stop.
--- success:        false



=== TEST 3: Test the variable expansion time
--- source
a = A
b = $(a)$(c)
all: ; @echo $(b)
c = C
--- stdout
AC
--- stderr
--- success:        true



=== TEST 4: variable reassignment
--- source
a = A
b = $(a)
all: foo bar
foo: ; @echo b = $(b)
a = W
bar: ; @echo b = $(b)
--- stdout
b = W
b = W
--- stderr
--- success:       true
