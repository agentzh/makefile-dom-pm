use t::GmakeDOM;

plan tests => 2 * blocks();

run_tests;

__DATA__

=== TEST 1:
--- src
foo:|bar;
--- dom
MDOM::Document::Gmake
  MDOM::Rule::Simple
    MDOM::Token::Bare         'foo'
    MDOM::Token::Separator            ':'
    MDOM::Token::Bare            '|'
    MDOM::Token::Bare         'bar'
    MDOM::Command
      MDOM::Token::Separator          ';'
      MDOM::Token::Whitespace         '\n'

