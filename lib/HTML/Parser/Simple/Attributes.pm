package HTML::Parser::Simple::Attributes;

use Carp;
use strict;
use warnings;

our $VERSION = '1.05';

=head1 NAME

C<HTML::Parser::Simple::Attributes> - a simple HTML attribute parser

=head1 Synopsis

 my $a_parser = HTML::Parser::Simple::Attributes->new(' height="20" width="20"');

 # All the attributes as a hashref
 my $attr_href = $a_parser->get_attr();

 # A specific value.
 my $val       = $self->get_attr('value');

=head1 Methods

=cut

sub new {
    my $class = shift;
    my $a_string = shift;
    my $self  = {};
    $self->{a_string}   = $a_string;
    bless ($self, $class);
    return $self;

}


=head2 get_attr()

 my $attrs_ref = $self->get_attr;
 my $val       = $self->get_attr('value');

If you have a start tag, this will return a hash ref with the attribute names as keys and the values as the values.

If you pass in an attribute name, it will return the value for just that attribute.

=cut

# Should also return false if the token is not a start tag, but how?
# Or perhaps only start tags become nodes?
sub get_attr {
    my $self = shift;
    my $key = shift;

    # Only parse each attribute string once.
    unless (exists $self->{attrs}) {
        $self->{attrs} = $self->parse_attributes($self->{a_string});
    }

    if ($key) {
        # XXX Check to see if the key exists first?
        return $self->{attrs}{$key};
    }
    else {
        return $self->{attrs};
    }

}

=head2 parse_attributes

 $attr_href = $self->parse_attributes($attr_string);
 $attr_href = HTML::Parser::Simple::Attributes->parse_attributes($attr_string);

Parses a string of HTML attributes and returns the result as a hash ref, or
dies if the string is a valid attribute string. Attribute values may be quoted
with double quotes, single quotes, no quotes if there are no spaces in the value.

May also be called as a class method.

=cut

our $quote_re  = qr{^([a-zA-Z0-9_-]+)\s*=\s*["]([^"]+)["]\s*(.*)$}so; # regular quotes
our $squote_re = qr{^([a-zA-Z0-9_-]+)\s*=\s*[']([^']+)[']\s*(.*)$}so; # single quotes
our $uquote_re = qr{^([a-zA-Z0-9_-]+)\s*=\s*([^\s'"]+)\s*(.*)$}so; # unquoted

sub parse_attributes {
    my $self = shift;
    my $astring = shift;

    # No attribute string? We're done.
    unless (defined $astring and length $astring) {
        return {};
    }

    my %attrs;

    # trim leading and trailing whitespace.
    # XXX faster as two REs?
    $astring =~ s/^\s+|\s+$//g;

    my $org = $astring;
    while (length $astring) {
        for my  $m ($quote_re, $squote_re, $uquote_re) {
            if ($astring =~ $m) {
                my ($var,$val,$suffix) = ($1,$2,$3);
                $attrs{$var} = $val;
                $astring = $suffix;
            }
        }
        if ($astring eq $org) {
            croak "parse_attributes: can't parse $astring - not a properly formed attribute string"
        }

    }

    return \%attrs;
}



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



1;
