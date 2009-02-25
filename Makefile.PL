use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
	($] ge '5.005') ?
	(
	 AUTHOR   => 'Ron Savage (ron@savage.net.au)',
	 ABSTRACT => 'Parse nice HTML files without needing a compiler',
    ) : (),
	clean =>
	{
	 FILES => 'blib/* Makefile MANIFEST HTML-Parser-Simple-*'
	},
	dist =>
	{
	 COMPRESS => 'gzip',
	 SUFFIX   => 'gz'
	},
	DISTNAME  => 'HTML-Parser-Simple',
	NAME      => 'HTML::Parser::Simple',
	PL_FILES  => {},
	PREREQ_PM =>
	{
		Carp         => 0,
		Test::More   => 0,
		Test::Pod    => 0,
		Tree::Simple => 0,
	},
	VERSION_FROM => 'lib/HTML/Parser/Simple.pm',
);
