use Test::Base;

plan tests => blocks() * 2;

use MDOM::Document::Gmake;
use MDOM::Dumper;

run {
    my $block = shift;
    my $name = $block->name;
    my $src = $block->src;
    my $dom = MDOM::Document::Gmake->new( \$src );
    ok $dom, "$name - DOM defined";
    my $dumper = MDOM::Dumper->new($dom);
    my $got = $dumper->string;
    my $expected = $block->dom;
    $got =~ s/(?x) [ \t]+? (?= \' [^\n]* \' )/\t\t/gs;
    $expected =~ s/(?x) [ \t]+? (?= \' [^\n]* \' )/\t\t/gs;
    is $got, $expected, "$name - DOM structure ok";
    #warn $dumper->string if $name =~ /TEST 0/;
};

__DATA__

=== TEST 1: "hello world" one-linner
--- src

all: ; echo "hello, world"

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'all'
    MDOM::Token::Separator    ':'
    MDOM::Token::Whitespace   ' '
    MDOM::Command
      MDOM::Token::Separator    ';'
      MDOM::Token::Whitespace   ' '
      MDOM::Token::Bare         'echo "hello, world"'
      MDOM::Token::Whitespace   '\n'



=== TEST 2: "hello world" makefile
--- src

all:
	echo "hello, world"

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'all'
    MDOM::Token::Separator    ':'
    MDOM::Token::Whitespace   '\n'
  MDOM::Command
    MDOM::Token::Separator    '\t'
    MDOM::Token::Bare         'echo "hello, world"'
    MDOM::Token::Whitespace   '\n'



=== TEST 3: variable references in prereq list
--- src

a: foo.c  bar.h	$(baz) # hello!
	@echo ...

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'a'
    MDOM::Token::Separator    ':'
    MDOM::Token::Whitespace   ' '
    MDOM::Token::Bare         'foo.c'
    MDOM::Token::Whitespace   '  '
    MDOM::Token::Bare         'bar.h'
    MDOM::Token::Whitespace   '\t'
    MDOM::Token::Interpolation   '$(baz)'
    MDOM::Token::Whitespace      ' '
    MDOM::Token::Comment         '# hello!'
    MDOM::Token::Whitespace      '\n'
  MDOM::Command
    MDOM::Token::Separator    '\t'
    MDOM::Token::Modifier     '@'
    MDOM::Token::Bare         'echo ...'
    MDOM::Token::Whitespace   '\n'



=== TEST 4: line continuations in comments
--- src

a: b # hello! \
	this is comment too! \
 so is this line

	# this is a cmd
	+touch $$

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare           'a'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Bare           'b'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Comment        '# hello! \\n\tthis is comment too! \\n so is this line'
    MDOM::Token::Whitespace     '\n'
  MDOM::Token::Whitespace       '\n'
  MDOM::Command
    MDOM::Token::Separator      '\t'
    MDOM::Token::Bare           '# this is a cmd'
    MDOM::Token::Whitespace     '\n'
  MDOM::Command
    MDOM::Token::Separator      '\t'
    MDOM::Token::Modifier       '+'
    MDOM::Token::Bare           'touch '
    MDOM::Token::Interpolation  '$$'
    MDOM::Token::Whitespace     '\n'



=== TEST 5: line continuations in commands
--- src
a :
	- mv \#\
	+ e \
  \\
	@

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare           'a'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     '\n'
  MDOM::Command
    MDOM::Token::Separator      '\t'
    MDOM::Token::Modifier       '-'
    MDOM::Token::Bare           ' mv \#\\n\t+ e \\n  \\'
    MDOM::Token::Whitespace     '\n'
  MDOM::Command
    MDOM::Token::Separator      '\t'
    MDOM::Token::Modifier       '@'
    MDOM::Token::Whitespace     '\n'



=== TEST 6: empty makefile
--- src
--- dom
MDOM::Document::Gmake



=== TEST 7: line continuations in prereq list and weird target names
--- src

@a:\
	 @b   @c

@b : ;
@c:;;

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare          '@a'
    MDOM::Token::Separator     ':'
    MDOM::Token::Continuation  '\\n'
    MDOM::Token::Whitespace    '\t '
    MDOM::Token::Bare          '@b'
    MDOM::Token::Whitespace    '   '
    MDOM::Token::Bare          '@c'
    MDOM::Token::Whitespace    '\n'
  MDOM::Token::Whitespace      '\n'
  MDOM::Rule::Simple
    MDOM::Token::Bare          '@b'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Separator     ':'
    MDOM::Token::Whitespace    ' '
    MDOM::Command
      MDOM::Token::Separator   ';'
      MDOM::Token::Whitespace  '\n'
  MDOM::Rule::Simple
    MDOM::Token::Bare          '@c'
    MDOM::Token::Separator     ':'
    MDOM::Command
      MDOM::Token::Separator   ';'
      MDOM::Token::Bare        ';'
      MDOM::Token::Whitespace  '\n'



=== TEST 8: line continuations in prereq list
--- src

a: \
	b\
    c \
    d

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare           'a'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Continuation   '\\n'
    MDOM::Token::Whitespace     '\t'
    MDOM::Token::Bare           'b'
    MDOM::Token::Continuation   '\\n'
    MDOM::Token::Whitespace     '    '
    MDOM::Token::Bare           'c'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Continuation   '\\n'
    MDOM::Token::Whitespace     '    '
    MDOM::Token::Bare           'd'
    MDOM::Token::Whitespace     '\n'



=== TEST 9: line continuations in prereqs and "inline" commands
--- src

a: \
	b;\
    c \
    d

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare           'a'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Continuation   '\\n'
    MDOM::Token::Whitespace     '\t'
    MDOM::Token::Bare           'b'
    MDOM::Command
      MDOM::Token::Separator    ';'
      MDOM::Token::Bare         '\\n    c \\n    d'
      MDOM::Token::Whitespace   '\n'



=== TEST 10: $@, $a, etc.
--- src
all: $a $(a) ${c}
	echo $@ $a ${a} ${abc} ${}
--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare               'all'
    MDOM::Token::Separator          ':'
    MDOM::Token::Whitespace         ' '
    MDOM::Token::Interpolation      '$a'
    MDOM::Token::Whitespace         ' '
    MDOM::Token::Interpolation      '$(a)'
    MDOM::Token::Whitespace         ' '
    MDOM::Token::Interpolation      '${c}'
    MDOM::Token::Whitespace         '\n'
  MDOM::Command
    MDOM::Token::Separator          '\t'
    MDOM::Token::Bare               'echo '
    MDOM::Token::Interpolation      '$@'
    MDOM::Token::Bare               ' '
    MDOM::Token::Interpolation      '$a'
    MDOM::Token::Bare               ' '
    MDOM::Token::Interpolation      '${a}'
    MDOM::Token::Bare               ' '
    MDOM::Token::Interpolation      '${abc}'
    MDOM::Token::Bare               ' '
    MDOM::Token::Interpolation      '${}'
    MDOM::Token::Whitespace         '\n'



=== TEST 11: basic variable setting
--- src
all: ; echo \$a
--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare               'all'
    MDOM::Token::Separator          ':'
    MDOM::Token::Whitespace         ' '
    MDOM::Command
      MDOM::Token::Separator        ';'
      MDOM::Token::Whitespace       ' '
      MDOM::Token::Bare             'echo \'
      MDOM::Token::Interpolation    '$a'
      MDOM::Token::Whitespace       '\n'



=== TEST 12: unescaped '#'
--- src
all: foo\\# hello
--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare           'all'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Bare           'foo\\'
    MDOM::Token::Comment        '# hello'
    MDOM::Token::Whitespace     '\n'



=== TEST 13: when no space between words and '#'
--- src
\#a: foo#hello
--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare           '\#a'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Bare           'foo'
    MDOM::Token::Comment        '#hello'
    MDOM::Token::Whitespace     '\n'



=== TEST 14: standalone single-line comment
--- src
# hello
#world!
--- dom
MDOM::Document::Gmake
  MDOM::Token::Comment    '# hello'
  MDOM::Token::Whitespace '\n'
  MDOM::Token::Comment    '#world!'
  MDOM::Token::Whitespace '\n'



=== TEST 15: standalone multi-line comment
--- src
# hello \
	world\
    !
--- dom
MDOM::Document::Gmake
  MDOM::Token::Comment    '# hello \\n\tworld\\n    !'
  MDOM::Token::Whitespace '\n'



=== TEST 16: comments indented by a tab
--- src
	# blah
--- dom
MDOM::Document::Gmake
  MDOM::Token::Whitespace    '\t'
  MDOM::Token::Comment       '# blah'
  MDOM::Token::Whitespace    '\n'



=== TEST 17: multi-line comment indented with tabs
--- src
	# blah \
hello!\
	# hehe
--- dom
MDOM::Document::Gmake
  MDOM::Token::Whitespace    '\t'
  MDOM::Token::Comment       '# blah \\nhello!\\n\t# hehe'
  MDOM::Token::Whitespace    '\n'



=== TEST 18: static pattern rules with ";" command
--- src

foo.o bar.o: %.o: %.c ; echo blah

%.c: ; echo $@

--- dom
MDOM::Document::Gmake
  MDOM::Rule::StaticPattern
    MDOM::Token::Bare           'foo.o'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Bare           'bar.o'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Bare           '%.o'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Token::Bare           '%.c'
    MDOM::Token::Whitespace     ' '
    MDOM::Command
      MDOM::Token::Separator    ';'
      MDOM::Token::Whitespace   ' '
      MDOM::Token::Bare         'echo blah'
      MDOM::Token::Whitespace   '\n'
  MDOM::Token::Whitespace       '\n'
  MDOM::Rule::Simple
    MDOM::Token::Bare           '%.c'
    MDOM::Token::Separator      ':'
    MDOM::Token::Whitespace     ' '
    MDOM::Command
      MDOM::Token::Separator    ';'
      MDOM::Token::Whitespace   ' '
      MDOM::Token::Bare         'echo '
      MDOM::Token::Interpolation    '$@'
      MDOM::Token::Whitespace       '\n'



=== TEST 19: static pattern rules without ";" commands
--- src

foo.o bar.o: %.o: %.c
	@echo blah

--- dom
MDOM::Document::Gmake
  MDOM::Rule::StaticPattern
    MDOM::Token::Bare          'foo.o'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Bare          'bar.o'
    MDOM::Token::Separator     ':'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Bare          '%.o'
    MDOM::Token::Separator     ':'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Bare          '%.c'
    MDOM::Token::Whitespace    '\n'
  MDOM::Command
    MDOM::Token::Separator     '\t'
    MDOM::Token::Modifier      '@'
    MDOM::Token::Bare          'echo blah'
    MDOM::Token::Whitespace    '\n'



=== TEST 20: unknown entities
--- src

a $(foo)
	echo $@

--- dom
MDOM::Document::Gmake
  MDOM::Unknown
    MDOM::Token::Bare               'a '
    MDOM::Token::Interpolation      '$(foo)'
    MDOM::Token::Whitespace         '\n'
  MDOM::Command
    MDOM::Token::Separator          '\t'
    MDOM::Token::Bare               'echo '
    MDOM::Token::Interpolation      '$@'
    MDOM::Token::Whitespace         '\n'



=== TEST 21: suffix (-like) rules
--- src

.SUFFIXES:

.c.o:
	echo "hello $<!"

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         '.SUFFIXES'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'
  MDOM::Token::Whitespace             '\n'
  MDOM::Rule::Simple
    MDOM::Token::Bare                 '.c.o'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'
  MDOM::Command
    MDOM::Token::Separator            '\t'
    MDOM::Token::Bare         'echo "hello '
    MDOM::Token::Interpolation                '$<'
    MDOM::Token::Bare         '!"'
    MDOM::Token::Whitespace           '\n'



=== TEST 22: special targets:
--- src

.SECONDEXPAN:

/tmp/foo.o:

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         '.SECONDEXPAN'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'
  MDOM::Token::Whitespace             '\n'
  MDOM::Rule::Simple
    MDOM::Token::Bare         '/tmp/foo.o'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'



=== TEST 23: recursively expanded variable setting
--- src

foo = bar

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            '='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'bar'
    MDOM::Token::Whitespace           '\n'



=== TEST 24: recursively expanded variable setting (more complex)
--- src

$(foo) = baz $(hey)

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Interpolation        '$(foo)'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            '='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'baz'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Interpolation        '$(hey)'
    MDOM::Token::Whitespace           '\n'



=== TEST 25: var assignment changed the "rule context" to VOID
--- src
a: b
foo = bar
	# hello!
--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'a'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'b'
    MDOM::Token::Whitespace           '\n'
  MDOM::Assignment
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            '='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'bar'
    MDOM::Token::Whitespace           '\n'
  MDOM::Token::Whitespace            '\t'
  MDOM::Token::Comment               '# hello!'
  MDOM::Token::Whitespace            '\n'



=== TEST 26: simply-expanded var assignment
--- src

a := $($($(x)))

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'a'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            ':='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Interpolation                '$($($(x)))'
    MDOM::Token::Whitespace           '\n'



=== TEST 27: multi-line var assignment
--- src

define remote-file
  $(if $(filter unix, $($1.type)), \
    /net/$($1.host)/$($1.path), \
    //$($1.host)/$($1.path))
endef

--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Bare         'define'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'remote-file'
    MDOM::Token::Whitespace           '\n'
  MDOM::Unknown
    MDOM::Token::Bare             '  '
    MDOM::Token::Interpolation '$(if $(filter unix, $($1.type)), \\n    /net/$($1.host)/$($1.path), \\n    //$($1.host)/$($1.path))'
    MDOM::Token::Whitespace           '\n'
  MDOM::Directive
    MDOM::Token::Bare         'endef'
    MDOM::Token::Whitespace           '\n'



=== TEST 28: whitespace before command modifiers (@)
--- src

all:
	  @ echo $@

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'all'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'
  MDOM::Command
    MDOM::Token::Separator            '\t'
    MDOM::Token::Whitespace           '  '
    MDOM::Token::Modifier             '@'
    MDOM::Token::Bare         ' echo '
    MDOM::Token::Interpolation                '$@'
    MDOM::Token::Whitespace           '\n'



=== TEST 29: whitespace before command modifiers (+/-)
--- src

all:
	  + echo $@
		-blah!

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'all'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'
  MDOM::Command
    MDOM::Token::Separator            '\t'
    MDOM::Token::Whitespace           '  '
    MDOM::Token::Modifier             '+'
    MDOM::Token::Bare         ' echo '
    MDOM::Token::Interpolation                '$@'
    MDOM::Token::Whitespace           '\n'
  MDOM::Command
    MDOM::Token::Separator            '\t'
    MDOM::Token::Whitespace           '\t'
    MDOM::Token::Modifier             '-'
    MDOM::Token::Bare                 'blah!'
    MDOM::Token::Whitespace           '\n'



=== TEST 30: multi-line var assignment (recursively-expanded)
--- src

SOURCES = count_words.c \
          lexer.c	\
		counter.c
--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'SOURCES'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            '='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'count_words.c'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Continuation         '\\n'
    MDOM::Token::Whitespace           '          '
    MDOM::Token::Bare         'lexer.c'
    MDOM::Token::Whitespace           '\t'
    MDOM::Token::Continuation         '\\n'
    MDOM::Token::Whitespace           '\t\t'
    MDOM::Token::Bare         'counter.c'
    MDOM::Token::Whitespace           '\n'



=== TEST 31: multi-line var assignment (simply-expanded)
--- src

SOURCES := count_words.c \
          lexer.c	\
		counter.c
--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'SOURCES'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            ':='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'count_words.c'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Continuation         '\\n'
    MDOM::Token::Whitespace           '          '
    MDOM::Token::Bare         'lexer.c'
    MDOM::Token::Whitespace           '\t'
    MDOM::Token::Continuation         '\\n'
    MDOM::Token::Whitespace           '\t\t'
    MDOM::Token::Bare         'counter.c'
    MDOM::Token::Whitespace           '\n'



=== TEST 32: multi-line commands
--- src

compile_all:
	for d in $(source_dirs); \
	do                       \
		$(JAVAC) $$d/*.java; \
	done

--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'compile_all'
    MDOM::Token::Separator            ':'
    MDOM::Token::Whitespace           '\n'
  MDOM::Command
    MDOM::Token::Separator            '\t'
    MDOM::Token::Bare         'for d in '
    MDOM::Token::Interpolation        '$(source_dirs)'
    MDOM::Token::Bare	'; \\n\tdo                       \\n\t\t$(JAVAC) $$d/*.java; \\n\tdone'
    MDOM::Token::Whitespace		'\n'



=== TEST 33: other assignment variations (simply-expanded)
--- src

override foo := 32

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'override'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            ':='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '32'
    MDOM::Token::Whitespace           '\n'



=== TEST 34: override + assignment (=)
--- src

override foo = 32

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'override'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            '='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '32'
    MDOM::Token::Whitespace           '\n'



=== TEST 35: override + assignment (:=)
--- src

override foo := 32

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'override'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            ':='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '32'
    MDOM::Token::Whitespace           '\n'



=== TEST 36: override + assignment (+=)
--- src

override CFLAGS += $(patsubst %,-I%,$(subst :, ,$(VPATH)))

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare                'override'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'CFLAGS'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Separator           '+='
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Interpolation       '$(patsubst %,-I%,$(subst :, ,$(VPATH)))'
    MDOM::Token::Whitespace          '\n'



=== TEST 37: override + assignment (?=)
--- src

override files ?=  main.o kbd.o command.o display.o \
            insert.o search.o files.o utils.o

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare                'override'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'files'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Separator           '?='
    MDOM::Token::Whitespace          '  '
    MDOM::Token::Bare                'main.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'kbd.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'command.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'display.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Continuation                '\\n'
    MDOM::Token::Whitespace          '            '
    MDOM::Token::Bare                'insert.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'search.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'files.o'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'utils.o'
    MDOM::Token::Whitespace          '\n'



=== TEST 38: export + assignment (:=)
--- src

export foo := 32

--- dom
MDOM::Document::Gmake
  MDOM::Assignment
    MDOM::Token::Bare         'export'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Separator            ':='
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '32'
    MDOM::Token::Whitespace           '\n'



=== TEST 39: the vpath directive
--- src

vpath %.1 %.c src
  vpath %h include

--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Bare         'vpath'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '%.1'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare           '%.c'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'src'
    MDOM::Token::Whitespace           '\n'
  MDOM::Directive
    MDOM::Token::Whitespace          '  '
    MDOM::Token::Bare                'vpath'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                '%h'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'include'
    MDOM::Token::Whitespace          '\n'



=== TEST 40: multi-line vpath directive
--- src

vpath %.1 %.c src \
    %h include

--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Bare         'vpath'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '%.1'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare           '%.c'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'src'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Continuation                '\\n'
    MDOM::Token::Whitespace          '    '
    MDOM::Token::Bare                '%h'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'include'
    MDOM::Token::Whitespace          '\n'



=== TEST 41: the include directive
--- src
include foo *.mk $(bar)
--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Bare         'include'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '*.mk'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Interpolation                '$(bar)'
    MDOM::Token::Whitespace           '\n'



=== TEST 42: multi-line include directive
--- src
include foo *.mk $(bar) \
    blah blah
--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Bare         'include'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         'foo'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Bare         '*.mk'
    MDOM::Token::Whitespace           ' '
    MDOM::Token::Interpolation                '$(bar)'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Continuation                '\\n'
    MDOM::Token::Whitespace          '    '
    MDOM::Token::Bare                'blah'
    MDOM::Token::Whitespace          ' '
    MDOM::Token::Bare                'blah'
    MDOM::Token::Whitespace           '\n'



=== TEST 43: the -include directive
--- src

-include filenames...

--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Modifier             '-'
    MDOM::Token::Bare          'include'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Bare          'filenames...'
    MDOM::Token::Whitespace           '\n'



=== TEST 44: multi-line -include directive
--- src

-include foo bar \
    $@ $^

--- dom
MDOM::Document::Gmake
  MDOM::Directive
    MDOM::Token::Modifier             '-'
    MDOM::Token::Bare          'include'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Bare          'foo'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Bare          'bar'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Continuation                '\\n'
    MDOM::Token::Whitespace    '    '
    MDOM::Token::Interpolation         '$@'
    MDOM::Token::Whitespace    ' '
    MDOM::Token::Interpolation         '$^'
    MDOM::Token::Whitespace           '\n'
