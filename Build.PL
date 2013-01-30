use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'HTML::Parser::Simple',
	license        => 'artistic_2',
	dist_abstract  => 'Parse nice HTML files without needing a compiler',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		Test::Simple=> 0,
		Test::Pod  => 1.45,
	},
	configure_requires =>
	{
		Module::Build => 0.36,
	},
	requires =>
	{
		File::Spec   => 0,
		Moos         => 0.13,
		strict       => 0,
		Tree::Simple => 0,
		warnings     => 0,
	},
);

$builder -> create_build_script();
