use strict;
use warnings;

use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'HTML::Parser::Simple',
	license        => 'artistic_2',
	dist_abstract  => 'Parse nice HTML files without needing a compiler',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		'Test::More' => 0,
#		'Test::Pod'  => 1.45, # Make it optional. See t/pod.t
	},
	configure_requires =>
	{
		'Module::Build' => 0.36,
	},
	requires =>
	{
		'File::Spec'   => 0,
		'lib'          => 0,
		'Moo'          => 1.003001,
		'strict'       => 0,
		'Tree::Simple' => 1.22,
		'warnings'     => 0,
	},
	meta_merge =>
	{
		resources =>
		{
			repository => 'https://github.com/ronsavage/html--parser--simple',
		},
	},
);

$builder -> create_build_script();
