use Module::Build;

my($builder) = Module::Build -> new
(
 module_name    => 'HTML::Parser::Simple',
 license        => 'artistic',
 dist_abstract  => 'Parse nice HTML files without needing a compiler',
 dist_author    => 'Ron Savage <ron@savage.net.au>',
 build_requires =>
 {
	 Test::More => 0,
	 Test::Pod  => 0,
 },
 configure_requires =>
 {
	 Module::Build => 0.36,
 },
 requires =>
 {
	 Carp         => 0,
	 perl         => 5.006,
	 Tree::Simple => 0,
 },
);

$builder -> create_build_script();
