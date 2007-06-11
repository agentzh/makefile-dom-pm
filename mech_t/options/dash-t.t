# Description:
#    Test the -t option.

#
# Details:
#    Look out for regressions of prior bugs related to -t.


use t::Gmake;

plan tests => 3 * blocks() - 2;

run_tests;

__DATA__

=== TEST 0
That means, nobody has even tried to make the tests below comprehensive
bug reported by Henning Makholm <henning@makholm.net> on 2001-11-03:
make 3.79.1 touches only interm-[ab] but reports final-[a] as
'up to date' without touching them.
The 'obvious' fix didn't work for double-colon rules, so pay special
attention to them.

--- source
final-a: interm-a ; echo >> $@
final-b: interm-b ; echo >> $@
interm-a:: orig1-a ; echo >> $@
interm-a:: orig2-a ; echo >> $@
interm-b:: orig1-b ; echo >> $@
interm-b:: orig2-b ; echo >> $@

--- touch:  orig1-b orig2-a
--- utouch
-10 final-a
-20 interm-a
-30 orig1-a
-30 orig2-b
-10 final-b
-20 interm-b
--- options:  -t final-a final-b
--- stdout
touch interm-a
touch final-a
touch interm-b
touch final-b

--- stderr



=== TEST 1
-t should not touch files with no commands.

--- source

PHOOEY: xxx
xxx: ; @:


--- options:  -t
--- stdout
touch xxx

--- stderr

