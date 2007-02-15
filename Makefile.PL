use strict;
use inc::Module::Install;

name            ('Makefile-DOM');
all_from        ('lib/Makefile/DOM.pm');
license         ('perl');

#install_script  ('script/pgmake');

requires        ('List::MoreUtils');
requires        ('Params::Util');
requires        ('Scalar::Util');
requires        ('Carp');

build_requires  ('Test::Base');
build_requires  ('IPC::Run3');
build_requires  ('File::Temp');
build_requires  ('File::Spec');
build_requires  ('Cwd');
build_requires  ('Text::Balanced');
build_requiers  ('FindBin');

&WriteAll;
