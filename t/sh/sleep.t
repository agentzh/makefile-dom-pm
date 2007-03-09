#: sleep.t
#: Test the `sleep' command support in script/sh
#: Copyright (c) 2006 Agent Zhang
#: 2006-02-12 2006-02-12

use t::Shell;

plan tests => 5 * blocks();

run_tests;

__DATA__

=== TEST 1: sleep 1 sec
--- pre
use Time::HiRes 'time';
$::start = time;
--- cmd
sleep 1
--- post
$::elapsed = time - $::start;
ok $::elapsed >= 1, 'TEST 1 - elapsed >= 1 sec';
ok $::elapsed <= 2, 'TEST 1 - elapsed <= 2 sec';
--- stdout
--- stderr
--- success:      true



=== TEST 2: sleep 3 sec
--- pre
use Time::HiRes 'time';
$::start = time;
--- cmd
sleep 3; echo hello
--- post
$::elapsed = time - $::start;
ok $::elapsed >= 3, 'TEST 2 - elapsed >= 3 sec';
ok $::elapsed <= 4, 'TEST 2 - elapsed <= 4 sec';
--- stdout
hello
--- stderr
--- success:      true
