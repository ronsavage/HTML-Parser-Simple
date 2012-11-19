package HTML::Parser::Simple::Attributes;

use Moos; # Turns on strict and warnings. Provides 'has'.

has attribute_hashref => (default => sub{return {} });
has attribute_string  => (default => sub{return ''});
has parsed            => (default => sub{return 0});

our $VERSION = '1.08';

# -----------------------------------------------

sub attributes
{
	my($self, $key) = @_;

	$self -> parse_attributes if ($self -> parsed == 0);

	my($attrs) = $self -> attribute_hashref;

	return $key ? $$attrs{$key} : $$attrs;

} # End of attributes.

# -----------------------------------------------

sub hashref2string
{
	my($self, $h) = @_;
	$h ||= {};

	return '{' . join(', ', map{"$_ => $$h{$_}"} sort keys %$h) . '}';

} # End of hashref2string.

# -----------------------------------------------

our(@quote) =
(
 qr{^([a-zA-Z0-9_-]+)\s*=\s*["]([^"]+)["]\s*(.*)$}so, # Double quotes.
 qr{^([a-zA-Z0-9_-]+)\s*=\s*[']([^']+)[']\s*(.*)$}so, # Single quotes.
 qr{^([a-zA-Z0-9_-]+)\s*=\s*([^\s'"]+)\s*(.*)$}so,    # Unquoted.
);

sub parse_attributes
{
	my($self, $string) = @_;
	$string    ||= $self -> attribute_string;
	$string    =~ s/^\s+|\s+$//g;
	my($attrs) = {};

	$self -> attribute_string($string);

	while (length $string)
	{
		my($i)        = - 1;
		my($original) = $string;

		while ($i < $#quote)
		{
			$i++;

			if ($string =~ $quote[$i])
			{
				$$attrs{$1} = $2;
				$string     = $3;
				$i          = - 1;
			}
		}

		if ($string eq $original)
		{
			die "parse_attributes(): can't parse $string - not a properly formed attribute string\n";
		}
	}

	$self -> attribute_hashref($attrs);
	$self -> parsed(1);

	return $attrs;

} # End of parse_attributes.

# -----------------------------------------------

1;

=head1 NAME

C<HTML::Parser::Simple::Attributes> - a simple HTML attribute parser

=head1 Synopsis

Note: This example assumes the attributes belong to a start tag.

	my($parser) = HTML::Parser::Simple::Attributes -> new(' height="20" width="20"');

	# Get all the attributes as a hashref.

	my($attr_href) = $parser -> get_attr;

	# Get the value of a specific attribute.

	my($height) = $parser -> get_attr('height');

=head1 Methods

=head2 get_attr([$name])

The [] indicate an optional parameter.

	my($attrs_ref) = $parser -> get_attr;
	my($val)       = $parser -> get_attr('attr_name');

If you don't pass in an attribute name, returns a hash ref with the attribute names as keys and the attribute values
as the values.

If you pass in an attribute name, it will return the value for just that attribute.

Return undef if you supply the name of a non-existant attribute.

=head2 parse_attributes($attr_string)

	$attr_href = $parser -> parse_attributes($attr_string);
	$attr_href = HTML::Parser::Simple::Attributes -> parse_attributes($attr_string);

Parses a string of HTML attributes and returns the result as a hash ref, or
dies if the string is not a valid attribute string. Attribute values may be quoted
with double quotes or single quotes.

Quotes may be omitted if there are no spaces in the value.

Returns an empty hashref if $attr_string is not supplied.

This method may also be called as a class method.

=head1 Author

C<HTML::Parser::Simple::Attributes> was written by Mark Stosberg I<E<lt>mark@summersault.comE<gt>> in 2009.

Home page: http://mark.stosberg.com/

=head1 Copyright

Copyright (c) 2009 Mark Stosberg.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
