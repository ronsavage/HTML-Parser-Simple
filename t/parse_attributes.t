use Test::More tests => 6;
use strict;
use warnings;

use HTML::Parser::Simple::Attributes;

my $p = HTML::Parser::Simple::Attributes->new(
q{ type=text name="my_name"
        value='my value'
        id="O'Hare"
        with_space = "true"
    });

my $a = $p->get_attr;

is($a->{type},'text', 'unquoted attribute is parsed');
is($a->{name},'my_name', 'double quoted attribute is parsed');
is($a->{value},'my value', 'single quoted attribute with space is parsed');
is($a->{id},"O'Hare", 'double quoted attribute with embedded single quote is parsed');
is($a->{with_space},"true", 'attribute with spaces around "=" is parsed');

{
    my $test = "test parse_attributes as class method";
    my $a = HTML::Parser::Simple::Attributes->parse_attributes(
        q{ type=text name="my_name"
        value='my value'
        id="O'Hare"
        with_space = "true"
        });
    is($a->{type},'text', 'unquoted attribute is parsed');
}
