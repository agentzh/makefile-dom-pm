package Makefile::DOM;

use strict;
use warnings;

our $VERSION = '0.001';

use MDOM::Document;
use MDOM::Element;
use MDOM::Node;
use MDOM::Rule;
use MDOM::Token;
use MDOM::Command;
use MDOM::Assignment;
use MDOM::Unknown;
use MDOM::Directive;

1;
__END__

=head1 NAME

Makefile::DOM - Simple DOM parser for Makefiles

=head1 DESCRIPTION

This libary can serve as an advanced lexer for (GNU) makefiles. It parses makefiles as "documents" and the parsing is lossless. The results are data structures similar to DOM trees. The DOM trees hold every single bit of the information in the original input files, including white spaces, blank lines and makefile comments. That means it's possible to reproduce the original makefiles from the DOM trees. In addition, each node of the DOM trees is modifiable and so is the whole tree, just like the L<PPI> module used for Perl source parsing and the L<HTML::TreeBuilder> module used for parsing HTML source.

The interface of C<Makefile::DOM> mimics the API design of L<PPI>. In fact, I've directly stolen the source code and POD documentation of L<PPI::Node>, L<PPI::Element>, and L<PPI::Dumper>, with the full permission from the author of L<PPI>, Adam Kennedy.

C<Makefile::DOM> tries to be independent of specific makefile's syntax. The same set of DOM node types is supposed to get shared by different makefile DOM generators. For example, L<MDOM::Document::Gmake> parses GNU makefiles and returns an instance of L<MDOM::Document>, i.e., the root of the DOM tree while the NMAKE makefile lexer in the future, C<MDOM::Document::Nmake>, also returns instances of the L<MDOM::Document> class. Later, I'll also consider adding support for dmake and bsdmake.

=head1 Structure of the DOM

Makefile DOM (MDOM) is a structured set of a series of data types. They provide a flexible document model conformed to the makefile syntax. Below is a complete list of the 19 MDOM classes in the current implementation where the indentation indicates the class inheritance relationships.

    MDOM::Element
        MDOM::Node
            MDOM::Unknown
            MDOM::Assignment
            MDOM::Command
            MDOM::Directive
            MDOM::Document
                MDOM::Document::Gmake
            MDOM::Rule
                MDOM::Rule::Simple
                MDOM::Rule::StaticPattern
        MDOM::Token
            MDOM::Token::Bare
            MDOM::Token::Comment
            MDOM::Token::Continuation
            MDOM::Token::Interpolation
            MDOM::Token::Modifier
            MDOM::Token::Separator
            MDOM::Token::Whitespace

It's not hard to see that all of the MDOM classes inherit from the L<MDOM::Element> class. L<MDOM::Token> and L<MDOM::Node> are its direct children. The former represents a string token which is atomic from the perspective of the lexer while the latter represents a structured node, which usually has one or more children, and serves as the container for other L<DOM::Element> objects.

Next we'll show a few examples to demonstrate how to map DOM trees to particular makefiles.

=over

=item Case 1

Consider the following simple "hello, world" makefile:

    all : ; echo "hello, world"

We can use the L<MDOM::Dumper> class provided by L<Makefile::DOM> to dump out the internal structure of its corresponding MDOM tree:

    MDOM::Document::Gmake
      MDOM::Rule::Simple
        MDOM::Token::Bare         'all'
        MDOM::Token::Whitespace   ' '
        MDOM::Token::Separator    ':'
        MDOM::Token::Whitespace   ' '
        MDOM::Command
          MDOM::Token::Separator    ';'
          MDOM::Token::Whitespace   ' '
          MDOM::Token::Bare         'echo "hello, world"'
          MDOM::Token::Whitespace   '\n'

In this example, speparators C<:> and C<;> are all instances of the L<MDOM::Token::Separator> class while spaces and new line characters are all represented as L<MDOM::Token::Whitespace>. The other two leaf nodes, C<all> and C<echo "hello, world"> both belong to L<MDOM::Token::Bare>.

It's worth mentioning that, the space characters in the rule command C<echo "hello, world"> were not represented as L<MDOM::Token::Whitespace>. That's because in makefiles, the spaces in commands do not make any sense to C<make> in syntax; those spaces are usually sent to shell programs verbatim. Therefore, the DOM parser does not try to recognize those spaces specifially so as to reduce memory use and the number of nodes. However, leading spaces and trailing new lines will still be recognized as L<MDOM::Token::Whitespace>.

On a higher level, it's a L<MDOM::Rule::Simple> instance holding several C<Token> and one L<MDOM::Command>. On the highest level, it's the root node of the whole DOM tree, i.e., an instance of L<MDOM::Document::Gmake>.

=item Case 2

Below is a relatively complex example:

    a: foo.c  bar.h $(baz) # hello!
        @echo ...

It's corresponding DOM structure is

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

Compared to the previous example, here appears several new node types.


原 makefile 文件第一行中的变量引用 $(baz)，在其 MDOM 树中对应于一个 MDOM::Token::Interpolation 节点。 类似地，注释 # hello 对应于一个 MDOM::Token::Comment 节点。 
第二行中，以制表符起始的规则命令依旧由一个 MDOM::Command 对象表示，它的第一个子节点 （或它的第一个元素）也正是该制表符所对应的 MDOM::Token::Seperator 实例。 而命令修饰符 @ 亦紧随其后，对应于 MDOM::Token::Modifier 类。 

=item Case 3

下面考虑一个有多种全局结构的 makefile 的例子：

这里在顶层上，有三个语言结构：一条规则 a: b，一条变量赋值语句 foo = bar，和一条注释 # hello!. 
其对应的 MDOM 树如下所示： 

我们看到，根节点 MDOM::Document::Gmake 对象之下有 MDOM::Rule::Simple, MDOM::Assignment, 和 MDOM::Comment 这三个元素，以及两个 MDOM::Token::Whitespace 对象。 
由此可见，MDOM 对 makefile 词法元素的表示是非常松弛的。它仅提供非常有限的结构化表示。 
1.1.3. 文档对象模型树的操作 
从一个 GNU makefile 文件生成一棵 MDOM 树，只需要两行 Perl 代码：
 
如果需要解析的 makefile 的源代码已存储在一个 Perl 变量 $var 中， 则可以通过下面这个代码来构建 MDOM：

此时 $dom 即为指向 MDOM 树根的引用，其类型为 MDOM::Document::Gmake，亦为 MDOM::Node 类的实例。 
正如上文介绍的，MDOM::Node 是其他 MDOM::Element 实例的容器，因此可以通过其 child 方法获取某个元素节点的值：
 
亦可通过 elements 方法取得所有节点的值：

对于任何一个 MDOM 节点而言，都可以调用其 content 方法反生成其对应的 makefile 源码。 
1.1.4. 局限与改进计划 
目前的 MDOM::Document::Gmake 解析器的实现采用的是手工编码的状态机方式。虽然引擎的效率较高， 但代码非常复杂和凌乱，给扩展和维护带来了困难。因此，需要在未来的某个时候，采用 Perl 6 正则引擎 Pugs::Compiler::Rule 以语法定义方式对解析器进行彻底改写。 

=back

=head1 AUTHOR

Agent Zhang E<lt>agentzh@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2006-2008 by Agent Zhang.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<MDOM::Document>, L<MDOM::Document::Gmake>.

