use Test::More tests => 1;

use HTML::Parser::Simple;

# -----------------------

my($html)   = '<html><head><title><>T</title></head><body><!--Comment-->B</body></html>';
my($parser) = HTML::Parser::Simple -> new();

eval{$parser -> parse($html)};

ok($@ =~ /Parse error/, 'Parse error as expected');

