package HTML::Parser::Simple::Reporter;

use parent 'HTML::Parser::Simple';

use HTML::Parser::Simple::Attributes;

use Moos; # Turns on strict and warnings. Provides 'has'.

our $VERSION = '1.08';

# -----------------------------------------------

sub traverse
{
	my($self, $node, $output, $depth) = @_;
	$depth        ||= 0;
	my(@child)    = $node -> getAllChildren;
	my($metadata) = $node -> getNodeValue;
	my($content)  = $$metadata{content};
	my($name)     = $$metadata{name};

	# We ignore the root, which means we ignore the DOCTYPE.

	if ($name ne 'root')
	{
		my($s) = ('  ' x ($depth - 1) ) . "$name. Attributes: ";
		my($p) = HTML::Parser::Simple::Attributes -> new;
		my($a) = $p -> parse_attributes($$metadata{attributes});
		$s     .= $p -> hashref2string($a);
		my($c) = '';

		for my $index (0 .. $#child + 1)
		{
			$c .= $index <= $#$content && defined($$content[$index]) ? $$content[$index] : '';
		}

		$c =~ s/^\s+//;
		$c =~ s/\s+$//;
		$s .= ". Content: $c.";

		push @$output, $s;
	}

	for my $index (0 .. $#child)
	{
		$self -> traverse($child[$index], $output, $depth + 1);
	}

} # End of traverse.

# -----------------------------------------------

sub traverse_file
{
	my($self, $input_file_name) = @_;
	$input_file_name  ||= $self -> input_file;

	open(INX, $input_file_name) || Carp::croak "Can't open($input_file_name): $!";
	my($html);
	read(INX, $html, -s INX);
	close INX;

	Carp::croak "Can't read($input_file_name): $!" if (! defined $html);

	$self -> parse($html);

	my($output) = [];

	$self -> traverse($self -> root, $output, 0);

	return $output;

} # End of traverse_file.

# -----------------------------------------------

1;

=head1 NAME

HTML::Parser::Simple::Reporter - A sub-class of HTML::Parser::Simple

=head1 Synopsis

	#!/usr/bin/env perl

	use strict;
	use warnings;

	use HTML::Parser::Simple;

	# -------------------------

	# Method 1:

	my($p) = HTML::Parser::Simple -> new
	(
	 {
		input_dir  => '/source/dir',
		output_dir => '/dest/dir',
	 }
	);

	$p -> parse_file('in.html', 'out.html');

	# Method 2:

	my($p) = HTML::Parser::Simple -> new();

	$p -> parse('<html>...</html>');
	$p -> traverse($p -> get_root() );
	print $p -> result();

=head1 Description

C<HTML::Parser::Simple> is a pure Perl module.

It parses HTML V 4 files, and generates a tree of nodes per HTML tag.

The data associated with each node is documented in the FAQ.

=head1 Distributions

This module is available as a Unix-style distro (*.tgz).

See http://savage.net.au/Perl-modules.html for details.

See http://savage.net.au/Perl-modules/html/installing-a-module.html for
help on unpacking and installing.

=head1 Constructor and initialization

new(...) returns an object of type C<HTML::Parser::Simple>.

This is the class's contructor.

Usage: C<< HTML::Parser::Simple -> new() >>.

This method takes a hashref of options.

Call C<new()> as C<< new({option_1 => value_1, option_2 => value_2, ...}) >>.

Available options:

=over 4

=item o input_dir

This takes the path where the input file is to read from.

The default value is '' (the empty string).

=item o output_dir

This takes the path where the output file is to be written.

The default value is '' (the empty string).

=item o verbose

This takes either a 0 or a 1.

Write more or less progress messages to STDERR.

The default value is 0.

Note: Currently, setting verbose does nothing.

=item o xhtml

This takes either a 0 or a 1.

0 means do not accept an XML declaration, such as <?xml version="1.0" encoding="UTF-8"?>
at the start of the input file, and some other XHTML features.

1 means accept it.

The default value is 0.

Warning: The only XHTML changes to this code, so far, are:

=over 4

=item o Accept the XML declaration

E.g.: <?xml version="1.0" standalone='yes'?>.

=item o Accept attribute names containing the ':' char

E.g.: <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">.

=back

=back

=head1 Methods

This module is a sub-class of L<HTML::Parser::Simple>, and inherits all its methods.

Further, it overrides the L<HTML::Parser::Simple/traverse($node)> method.

=head2 traverse($node)


=head1 FAQ

=head1 Author

C<HTML::Parser::Simple> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2009.

Home page: L<http://savage.net.au/index.html>.

=head1 Copyright

Australian copyright (c) 2009 Ron Savage.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
