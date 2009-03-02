use lib 't';

use Data;

use HTML::Parser::Simple;

use Test::More tests => 1;

# -----------------------

my($data)   = Data -> new({input_dir => 't/data'});
my($html)   = $data -> read_file('90.xml.declaration.xhtml');
my($parser) = HTML::Parser::Simple -> new();

$parser -> set_xhtml(1);
$parser -> parse($html);
$parser -> traverse($parser -> get_root() );

ok($parser -> result() =~ m/..xml.+?version.+?encoding/, 'XML declaration is preserved');
