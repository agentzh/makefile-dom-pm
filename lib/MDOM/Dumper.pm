package MDOM::Dumper;

=pod

=head1 NAME

MDOM::Dumper - Dumping of MDOM trees

=head1 SYNOPSIS

  # Load a document
  my $Module = MDOM::Document->new( 'MyMakefile' );
  
  # Create the dumper
  my $Dumper = MDOM::Dumper->new( $Module );
  
  # Dump the document
  $Dumper->print;

=head1 DESCRIPTION

The MDOM trees in MDOM are quite complex, and getting a dump of their
structure for development and debugging purposes is important.

This module provides that functionality.

The process is relatively simple. Create a dumper object with a
particular set of options, and then call one of the dump methods to
generate the dump content itself.

=head1 METHODS

=cut

use strict;
use Params::Util '_INSTANCE';

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.006';
}





#####################################################################
# Constructor

=pod

=head2 new $Element, param => value, ...

The C<new> constructor creates a dumper, and takes as argument a single
L<MDOM::Element> object of any type to serve as the root of the tree to
be dumped, and a number of key-E<gt>value parameters to control the output
format of the Dumper. Details of the parameters are listed below.

Returns a new C<MDOM::Dumper> object, or C<undef> if the constructor
is not passed a correct L<MDOM::Element> root object.

=over

=item memaddr

Should the dumper print the memory addresses of each MDOM element.
True/false value, off by default.

=item indent

Should the structures being dumped be indented. This value is numeric,
with the number representing the number of spaces to use when indenting
the dumper output. Set to '2' by default.

=item class

Should the dumper print the full class for each element.
True/false value, on by default.

=item content

Should the dumper show the content of each element. True/false value,
on by default.

=item whitespace

Should the dumper show whitespace tokens. By not showing the copious
numbers of whitespace tokens the structure of the code can often be
made much clearer. True/false value, on by default.

=item comments

Should the dumper show comment tokens. In situations where you have
a lot of comments, the code can often be made clearer by ignoring
comment tokens. True/value value, on by default.

=item locations

Should the dumper show the location of each token. The values shown are
[ line, rowchar, column ]. See L<MDOM::Element/"location"> for a description of
what these values really are. True/false value, off by default.

=back

=cut

sub new {
	my $class   = shift;
	my $Element = _INSTANCE(shift, 'MDOM::Element') or return undef;

	# Create the object
	my $self = bless {
		root    => $Element,
		display => {
			memaddr    => '', # Show the refaddr of the item
			indent     => 2,  # Indent the structures
			class      => 1,  # Show the object class
			content    => 1,  # Show the object contents
			whitespace => 1,  # Show whitespace tokens
			comments   => 1,  # Show comment tokens
			locations  => 0,  # Show token locations
			},
		}, $class;

	# Handle the options
	my %options = map { lc $_ } @_;
	foreach ( keys %{$self->{display}} ) {
		if ( exists $options{$_} ) {
			if ( $_ eq 'indent' ) {
				$self->{display}->{indent} = $options{$_};
			} else {
				$self->{display}->{$_} = !! $options{$_};
			}
		}
	}

	$self->{indent_string} = join '', (' ' x $self->{display}->{indent});

	# Try to auto-call index_locations. If it failes, turn of locations display
	if ( $self->{display}->{locations} ) {
		my $Document = $Element->isa('MDOM::Document') ? $Element : $Element->top;
		if ( $Document->isa('MDOM::Document') ) {
			$Document->index_locations();
		} else {
			$self->{display}->{locations} = 0;
		}
	}
        
	$self;
}





#####################################################################
# Main Interface Methods

=pod

=head2 print

The C<print> method generates the dump and prints it to STDOUT.

Returns as for the internal print function.

=cut

sub print {
	CORE::print(shift->string);
}

=pod

=head2 string

The C<string> method generates the dump and provides it as a
single string.

Returns a string or undef if there is an error while generating the dump. 

=cut

sub string {
	my $array_ref = shift->_dump or return undef;
	join '', map { "$_\n" } @$array_ref;
}

=pod

=head2 list

The C<list> method generates the dump and provides it as a raw
list, without trailing newlines.

Returns a list or the null list if there is an error while generation
the dump.

=cut

sub list {
	my $array_ref = shift->_dump or return ();
	@$array_ref;
}





#####################################################################
# Generation Support Methods

sub _dump {
	my $self    = ref $_[0] ? shift : shift->new(shift);
	my $Element = _INSTANCE($_[0], 'MDOM::Element') ? shift : $self->{root};
	my $indent  = shift || '';
	my $output  = shift || [];

	# Print the element if needed
	my $show = 1;
	if ( $Element->isa('MDOM::Token::Whitespace') ) {
		$show = 0 unless $self->{display}->{whitespace};
	} elsif ( $Element->isa('MDOM::Token::Comment') ) {
		$show = 0 unless $self->{display}->{comments};
	}
	push @$output, $self->_element_string( $Element, $indent ) if $show;

	# Recurse into our children
	if ( $Element->isa('MDOM::Node') ) {
		my $child_indent = $indent . $self->{indent_string};
		foreach my $child ( @{$Element->{children}} ) {
			$self->_dump( $child, $child_indent, $output );
		}
	}

	$output;
}

sub _element_string {
	my $self    = ref $_[0] ? shift : shift->new(shift);
	my $Element = _INSTANCE($_[0], 'MDOM::Element') ? shift : $self->{root};
	my $indent  = shift || '';
	my $string  = '';

	# Add the memory location
	if ( $self->{display}->{memaddr} ) {
		$string .= $Element->refaddr . '  ';
	}
        
        # Add the location if such exists
	if ( $self->{display}->{locations} ) {
		my $loc_string;
		if ( $Element->isa('MDOM::Token') ) {
			my $location = $Element->location;
			if ($location) {
				$loc_string = sprintf("[ % 4d, % 3d, % 3d ] ", @$location);
			}
		}
		# Output location or pad with 20 spaces
		$string .= $loc_string || " " x 20;
	}
        
	# Add the indent
	if ( $self->{display}->{indent} ) {
		$string .= $indent;
	}

	# Add the class name
	if ( $self->{display}->{class} ) {
		$string .= ref $Element;
	}

	if ( $Element->isa('MDOM::Token') ) {
		# Add the content
		if ( $self->{display}->{content} ) {
			my $content = $Element->content;
			$content =~ s/\n/\\n/g;
			$content =~ s/\t/\\t/g;
                        $content =~ s/'/\\'/g;
                        $content =~ s/\r/\\r/g;
			$string .= "  \t'$content'";
		}
	} elsif ( $Element->isa('MDOM::Structure') ) {
		# Add the content
		if ( $self->{display}->{content} ) {
			my $start = $Element->start
				? $Element->start->content
				: '???';
			my $finish = $Element->finish
				? $Element->finish->content
				: '???';
			$string .= "  \t$start ... $finish";
		}
	}
	
	$string;
}

1;

=pod

=head1 SUPPORT

See the L<support section|MDOM/SUPPORT> in the main module.

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

Zhang "agentzh" Yichun C<< <agentzh@gmail.com> >>

=head1 COPYRIGHT

Copyright 2001 - 2006 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
