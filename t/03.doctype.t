use Test::More tests => 1;

use HTML::Parser::Simple;

# -----------------------

my($html)   = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><title>T</title></head><body><!--Comment-->B</body></html>';
my($parser) = HTML::Parser::Simple -> new();

$parser -> parse($html);
$parser -> traverse($parser -> root() );

my($result) = $parser -> result();

ok($result =~ m/DOCTYPE/, 'DOCTYPE is preserved');
