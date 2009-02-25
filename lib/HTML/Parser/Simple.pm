package HTML::Parser::Simple;

# Author:
#	Ron Savage <ron@savage.net.au>
#
# Note:
#	\t = 4 spaces || die.

use strict;
use warnings;

require 5.005_62;

require Exporter;

use Carp;
use File::Spec;

use Tree::Simple;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use HTML::Parser::Simple ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(

) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(

);

our $VERSION = '1.01';

# -----------------------------------------------

# Preloaded methods go here.

# -----------------------------------------------

# Encapsulated class data.

{
	my(%_attr_data) =
	(
	 _input_dir  => '',
	 _output_dir => '',
	 _verbose    => 0,
	);

	sub _default_for
	{
		my($self, $attr_name) = @_;

		$_attr_data{$attr_name};
	}

	sub _standard_keys
	{
		keys %_attr_data;
	}
}

# -----------------------------------------------

sub handle_comment
{
	my($self, $s) = @_;

	$self -> handle_content($s);

} # End of handle_comment.

# -----------------------------------------------

sub handle_content
{
	my($self, $s)                 = @_;
	my($count)                    = $$self{'_current'} -> getChildCount();
	my($metadata)                 = $$self{'_current'} -> getNodeValue();
	$$metadata{'content'}[$count] .= $s;

	$$self{'_current'} -> setNodeValue($metadata);

} # End of handle_content.

# -----------------------------------------------

sub handle_doctype
{
	my($self, $s) = @_;

	$self -> handle_content($s);

} # End of handle_doctype.

# -----------------------------------------------

sub handle_end_tag
{
	my($self, $tag_name) = @_;

	if ( ($tag_name eq 'head') || ($tag_name eq 'body') )
	{
		$self -> node_type('global');
	}

	if (! $$self{'_empty'}{$tag_name})
	{
		$$self{'_current'} = $$self{'_current'} -> getParent();

		$$self{'_depth'}--;
	}

} # End of handle_end_tag.

# -----------------------------------------------

sub handle_start_tag
{
	my($self, $tag_name, $attributes, $unary) = @_;

	$$self{'_depth'}++;

	if ($tag_name eq 'head')
	{
		$self -> node_type('head');
	}
	elsif ($tag_name eq 'body')
	{
		$self -> node_type('body');
	}

	my($node) = $self -> new_node($tag_name, $attributes, $$self{'_current'});

	if (! $$self{'_empty'}{$tag_name})
	{
		$$self{'_current'} = $node;
	}

} # End of handle_start_tag.

# -----------------------------------------------

sub log
{
	my($self, $msg) = @_;

	if ($$self{'_verbose'})
	{
		print STDERR "$msg\n";
	}

} # End of log.

# -----------------------------------------------

sub new
{
	my($class, $arg) = @_;
	my($self)        = bless({}, $class);

	for my $attr_name ($self -> _standard_keys() )
	{
		my($arg_name) = $attr_name =~ /^_(.*)/;

		if (exists($$arg{$arg_name}) )
		{
			$$self{$attr_name} = $$arg{$arg_name};
		}
		else
		{
			$$self{$attr_name} = $self -> _default_for($attr_name);
		}
	}

	$$self{'_block'} =
	{
	 address => 1,
	 applet => 1,
	 blockquote => 1,
	 button => 1,
	 center => 1,
	 dd => 1,
	 del => 1,
	 dir => 1,
	 div => 1,
	 dl => 1,
	 dt => 1,
	 fieldset => 1,
	 form => 1,
	 frameset => 1,
	 hr => 1,
	 iframe => 1,
	 ins => 1,
	 isindex => 1,
	 li => 1,
	 map => 1,
	 menu => 1,
	 noframes => 1,
	 noscript => 1,
	 object => 1,
	 ol => 1,
	 p => 1,
	 pre => 1,
	 script => 1,
	 table => 1,
	 tbody => 1,
	 td => 1,
	 tfoot => 1,
	 th => 1,
	 thead => 1,
	 'tr' => 1,
	 ul => 1,
	};
	$$self{'_close_self'} =
	{
	 colgroup => 1,
	 dd => 1,
	 dt => 1,
	 li => 1,
	 options => 1,
	 p => 1,
	 td => 1,
	 tfoot => 1,
	 th => 1,
	 thead => 1,
	 'tr' => 1,
	};
	$$self{'_depth'}   = 0;
	$$self{'_empty'}   =
	{
	 area => 1,
	 base => 1,
	 basefont => 1,
	 br => 1,
	 col => 1,
	 embed => 1,
	 frame => 1,
	 hr => 1,
	 img => 1,
	 input => 1,
	 isindex => 1,
	 link => 1,
	 meta => 1,
	 param => 1,
	 wbr => 1,
	};
	$$self{'_inline'} =
	{
	 a => 1,
	 abbr => 1,
	 acronym => 1,
	 applet => 1,
	 b => 1,
	 basefont => 1,
	 bdo => 1,
	 big => 1,
	 br => 1,
	 button => 1,
	 cite => 1,
	 code => 1,
	 del => 1,
	 dfn => 1,
	 em => 1,
	 font => 1,
	 i => 1,
	 iframe => 1,
	 img => 1,
	 input => 1,
	 ins => 1,
	 kbd => 1,
	 label => 1,
	 map => 1,
	 object => 1,
	 'q' => 1,
	 's' => 1,
	 samp => 1,
	 script => 1,
	 select => 1,
	 small => 1,
	 span => 1,
	 strike => 1,
	 strong => 1,
	 sub => 1,
	 sup => 1,
	 textarea => 1,
	 tt => 1,
	 u => 1,
	 var => 1,
	};
	$$self{'_known_tag'} = {%{$$self{'_block'} }, %{$$self{'_close_self'} }, %{$$self{'_empty'} }, %{$$self{'_inline'} } };
	$$self{'_result'}    = '';

	$self -> node_type('global');

	$$self{'_current'} = $self -> new_node('root', '');

	$self -> root($$self{'_current'});

	return $self;

}	# End of new.

# -----------------------------------------------
# Generate a new node to store the new tag.
# Each node has metadata:
# o attributes: The tag's attributes, as a string with N spaces as a prefix.
# o content:    The content before the tag was parsed.
# o name:       The HTML tag.
# o node_type:  This holds 'global' before '<head>' and between '</head>'
#               and '<body>', and after '</body>'. It holds 'head' from
#               '<head>' to </head>', and holds 'body' from '<body>' to
#               '</body>'. It's just there in case you need it.

sub new_node
{
	my($self, $name, $attributes, $parent) = @_;
	my($node)     = Tree::Simple -> new();
	my($metadata) =
	{
		attributes => $attributes,
		content    => [],
		name       => $name,
		node_type  => $self -> node_type(),
	};

	return Tree::Simple -> new($metadata, $parent);

} # End of new_node.

# -----------------------------------------------

sub node_type
{
	my($self, $type) = @_;

	if ($type)
	{
		$$self{'_node_type'} = $type;
	}

	return $$self{'_node_type'};

} # End of node_type.

# -----------------------------------------------

sub parse
{
	my($self, $html) = @_;
	my($original)    = $html;
	my(%special)     =
	(
	 script => 1,
	 style  => 1,
	);

	my($in_content);
	my($offset);
	my(@stack, $s);

	for (; $html;)
	{
		$in_content = 1;

		# Make sure we're not in a script or style element.

		if (! $stack[$#stack] || ! $special{$stack[$#stack]})
		{
			# Rearrange order of testing so rarer possiblilites are further down.
			# Is it an end tag?

			$s = substr($html, 0, 2);

			if ($s eq '</')
			{
				if ($html =~ /^(<\/(\w+)[^>]*>)/)
				{
					substr($html, 0, length $1) = '';
					$in_content                 = 0;

					$self -> parse_end_tag($2, \@stack);
				}
			}

			# Is it a start tag?

			if ($in_content)
			{
				if (substr($html, 0, 1) eq '<')
				{
					if ($html =~ /^(<(\w+)((?:\s+[-\w]+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>)/)
					{
						substr($html, 0, length $1) = '';
						$in_content                 = 0;

						$self -> parse_start_tag($2, $3, $4, \@stack);
					}
				}
			}

			# Is it a comment?

			if ($in_content)
			{
				$s = substr($html, 0, 4);

				if ($s eq '<!--')
				{
					$offset = index($html, '-->');

					if ($offset >= 0)
					{
						$self -> handle_comment(substr($html, 0, ($offset + 3) ) );

						substr($html, 0, $offset + 3) = '';
						$in_content                   = 0;
					}
				}
			}

			# Is it a doctype?

			if ($in_content)
			{
				$s = substr($html, 0, 9);

				if ($s eq '<!DOCTYPE')
				{
					$offset = index($html, '>');

					if ($offset >= 0)
					{
						$self -> handle_doctype(substr($html, 0, ($offset + 1) ) );

						substr($html, 0, $offset + 1) = '';
						$in_content                   = 0;
					}
				}
			}

			if ($in_content)
			{
				$offset = index($html, '<');

				if ($offset < 0)
				{
					$self -> handle_content($html);

					$html = '';
				}
				else
				{
					$self -> handle_content(substr($html, 0, $offset) );

					substr($html, 0, $offset) = '';
				}
			}
		}
		else
		{
			my($re) = "(.*)<\/$stack[$#stack]\[^>]*>";

			if ($html =~ /$re/s)
			{
				my($text) = $1;
				$text     =~ s/<!--(.*?)-->/$1/g;
				$text     =~ s/<!\[CDATA]\[(.*?)]]>/$1/g;

				$self -> handle_content($text);
			}

			$self -> parse_end_tag($stack[$#stack], \@stack);
		}

		if ($html eq $original)
		{
			my($msg)    = 'Parse error. ';
			my($parent) = $$self{'_current'} -> getParent();

			my($metadata);

			if ($parent)
			{
				$metadata = $parent -> getNodeValue();
				$msg      .= "Parent tag: <$$metadata{'name'}>. ";
			}

			$metadata = $$self{'_current'} -> getNodeValue();
			$msg      .= "Current tag: <$$metadata{'name'}>. Next 50 chars: " . substr($html, 0, 50);
 
			Carp::croak $msg;
		}

		$original = $html;
	}

	# Clean up any remaining tags.

	$self -> parse_end_tag('', \@stack);

} # End of parse.

# -----------------------------------------------

sub parse_end_tag
{
	my($self, $tag_name, $stack) = @_;

	# Find the closest opened tag of the same name.

	my($pos);

	if ($tag_name)
	{
		for ($pos = $#$stack; $pos >= 0; $pos--)
		{
			if ($$stack[$pos] eq $tag_name)
			{
				last;
			}
		}
	}
	else
	{
		$pos = 0;
	}

	if ($pos >= 0)
	{
		# Close all the open tags, up the stack.

		my($count) = 0;

		for (my($i) = $#$stack; $i >= $pos; $i--)
		{
			$count++;

			$self -> handle_end_tag($$stack[$i]);
		}

		# Remove the open elements from the stack.
		# Does not work: $#$stack = $pos. Could use splice().

		for ($count)
		{
			pop @$stack;
		}
	}

} # End of parse_end_tag.

# -----------------------------------------------

sub parse_file
{
	my($self, $input_file_name, $output_file_name) = @_;

	if ($$self{'_input_dir'})
	{
		$input_file_name = File::Spec -> catfile($$self{'_input_dir'}, $input_file_name);
	}

	open(INX, $input_file_name) || Carp::croak "Can't open($input_file_name): $!";
	my($html);
	read(INX, $html, -s INX);
	close INX;

	if (! defined $html)
	{
		Carp::croak "Can't read($input_file_name): $!"
	}

	$self -> parse($html);
	$self -> traverse($self -> root() );

	if ($$self{'_output_dir'})
	{
		$output_file_name = File::Spec -> catfile($$self{'_output_dir'}, $output_file_name);
	}

	open(OUT, "> $output_file_name") || Carp::croak "Can't open(> $output_file_name): $!";
	print OUT $self -> result();
	close OUT;

} # End of parse_file.

# -----------------------------------------------

sub parse_start_tag
{
	my($self, $tag_name, $attributes, $unary, $stack) = @_;

	if ($$self{'_block'}{$tag_name})
	{
		for (; $#$stack >= 0 && $$self{'_inline'}{$$stack[$#$stack]};)
		{
			$self -> parse_end_tag($$stack[$#$stack], $stack);
		}
	}

	if ($$self{'_close_self'}{$tag_name} && ($$stack[$#$stack] eq $tag_name) )
	{
		$self -> parse_end_tag($tag_name, $stack);
	}

	$unary = $$self{'_empty'}{$tag_name} || $unary;

	if (! $unary)
	{
		push @$stack, $tag_name;
	}

	$self -> handle_start_tag($tag_name, $attributes, $unary);

} # End of parse_start_tag.

# -----------------------------------------------

sub result
{
	my($self) = @_;

	return $$self{'_result'};

} # End of result.

# -----------------------------------------------

sub root
{
	my($self, $node) = @_;

	if ($node)
	{
		$$self{'_root'} = $node;
	}

	return $$self{'_root'};

} # End of root.

# -----------------------------------------------

sub traverse
{
	my($self, $node) = @_;
	my(@child)       = $node -> getAllChildren();
	my($metadata)    = $node -> getNodeValue();
	my($content)     = $$metadata{'content'};
	my($name)        = $$metadata{'name'};

	# Special check to avoid printing '<root>' when we still need to output
	# the content of the root, e.g. the DOCTYPE.

	if ($name ne 'root')
	{
		$$self{'_result'} .= "<$name$$metadata{'attributes'}>";
	}

	my($index);
	my($s);

	for $index (0 .. $#child)
	{
		$$self{'_result'} .= $index <= $#$content && defined($$content[$index]) ? $$content[$index] : '';

		$self -> traverse($child[$index]);
	}

	# Output the content after the last child node has been closed,
	# but before the current node is closed.

	$index            = $#child + 1;
	$$self{'_result'} .= $index <= $#$content && defined($$content[$index]) ? $$content[$index] : '';

	if (! $$self{'_empty'}{$name} && ($name ne 'root') )
	{
		$$self{'_result'} .= "</$name>";
	}

} # End of traverse.

# -----------------------------------------------

1;

=head1 NAME

C<HTML::Parser::Simple> - Parse nice HTML files without needing a compiler

=head1 Synopsis

	#!/usr/bin/perl
	
	use strict;
	use warnings;
	
	use HTML::Parser::Simple;
	
	# -------------------------
	
	# Method 1:
	
	my($p) = HTML::Parser::Simple -> new
	(
	 {
		input_dir  => '/source/dir',
		output_dir => '/dest/dir',
	 }
	);
	
	$p -> parse_file('in.html', 'out.html');
	
	# Method 2:
	
	my($p) = HTML::Parser::Simple -> new();
	
	$p -> parse('<html>...</html>');
	$p -> traverse($p -> root() );
	print $p -> result();

=head1 Description

C<HTML::Parser::Simple> is a pure Perl module.

It parses HTML V 4 files, and generates a tree of nodes per HTML tag.

The data associated with each node is documented in the FAQ.

Warning: Use only the documented methods.

=head1 Distributions

This module is available as a Unix-style distro (*.tgz).

See http://savage.net.au/Perl-modules.html for details.

See http://savage.net.au/Perl-modules/html/installing-a-module.html for
help on unpacking and installing.

=head1 Constructor and initialization

new(...) returns an object of type C<HTML::Parser::Simple>.

This is the class's contructor.

Usage: C<< HTML::Parser::Simple -> new() >>.

This method takes a hashref of options.

Call C<new()> as C<< new({option_1 => value_1, option_2 => value_2, ...}) >>.

Available options:

=over 4

=item input_dir

This takes the path where the input file is to read from.

The default value is '' (the empty string).

=item output_dir

This takes the path where the output file is to be written.

The default value is '' (the empty string).

=item verbose

This takes either a 0 or a 1.

Write more or less progress messages to STDERR.

The default value is 0.

Note: Currently, setting verbose does nothing.

=back

=head1 Method: log($msg)

Print $msg to STDERR if C<new()> was called as C<< new({verbose => 1}) >>.

Otherwise, print nothing.

=head1 Method: parse($html)

Parses the string of HTML in $html, and builds a tree of nodes.

After calling C<< $p -> parse() >>, you must call C<< $p -> traverse($p -> root() ) >> before calling C<< $p -> result() >>.

Alternately, call C<< $p -> parse_file() >>, which calls all these methods for you.

=head1 Method: parse_file($input_file_name, $output_file_name)

Parses the HTML in the input file, and writes the result to the output file.

=head1 Method: result()

Returns a string which is the result of calling C<< $p -> traverse($p -> root() ) >>.

=head1 Method: root()

Returns the root of the tree constructed by calling C<< $p -> parse() >>.

Note: C<parse()> may be called directly or via C<parse_file()>.

=head1 FAQ

=over 4

=item What is the format of the data stored in each node of the tree?

The data of each node is a hash ref:

The keys/values of this hash ref are:

=over 4

=item attributes

This is the string of HTML attributes associated with the HTML tag.

So, <table align = 'center' bgColor = '#80c0ff' summary = 'Body'> will have an attributes string of
" align = 'center' bgColor = '#80c0ff' summary = 'Body'".

Note the leading space.

=item content

This is an array ref of bits and pieces of content.

Consider this fragment of HTML:

<p>I did <i>not</i> say I <i>liked</i> debugging.</p>

When parsing 'I did ', the number of child nodes (of <p>) is 0, since <i> has not yet been detected.

So, 'I did ' is stored in the 0th element of the array ref.

Likewise, 'not' is stored in the 0th element of the array ref belonging to the node 'i'.

Next, ' say I ' is stored in the 1st element of the array ref, because it follows the 1st child node (<i>).

Likewise, ' debugging' is stored in the 2nd element.

This way, the input string can be reproduced by successively outputting the elements of the array ref of content
interspersed with the contents of the child nodes (processed recusively).

Note: If you are processing this tree, never forget that there can be content after the last child node has been closed,
but before the current node is closed.

Note: The DOCTYPE declaration is stored as the 0th element of the content of the root node.

=item The name the HTML tag

So, the tag '<html>' will mean the name is 'html'.

The root of the tree is called 'root', and holds the DOCTYPE, if any, as content.

The root has the node 'html' as the only child, of course.

=item node_type

This holds 'global' before '<head>' and between '</head>' and '<body>', and after '</body>'.

It holds 'head' for all nodes from '<head>' to '</head>', and holds 'body' from '<body>' to '</body>'.

It's just there in case you need it.

=back

=item How are HTML comments handled?

They are treated as content. This includes the prefix '<!--' and the suffix '-->'.

=item How is DOCTYPE handled?

It is treated as content belonging to the root of the tree.

=item Does this module handle all HTML pages?

No, never.

=item Which versions of HTML does this module handle?

Up to V 4.

=item What do I do if this module does not handle my HTML page?

Make yourself a nice cup of tea, and then fix your page.

=item Does this validate the HTML input?

No.

For example, if you feed in a HTML page without the title tag, this module does not care.

=item How do I view the output HTML?

By installing HTML::Revelation, of course!

Sample output:

http://savage.net.au/Perl-modules/html/CreateTable.html

=item How do I test this module (or my file)?

Suggested steps:

Note: There are quite a few files involved. Proceed with caution.

=over 4

=item Select a HTML file to test

Call this input.html.

=item Run input.html thru reveal.pl

Reveal.pl ships with HTML::Revelation.

Call the output file output.1.html.

=item Run input.html thru parse.file.pl

Parse.file.pl ships with HTML::Parser::Simple.

Call the output file parsed.html.

=item Run parsed.html thru reveal.pl

Call the output file output.2.html.

=item Compare output.1.html and output.2.html

If they match, or even if they don't match, you're finished.

=back

=item Will you implement a 'quirks' mode to handle my special HTML file?

No, never.

Help with quirks:

http://www.quirksmode.org/sitemap.html

=item Is there anything I should be aware of?

Yes. If your HTML file is not nice, the interpretation of tag nesting will not match
your preconceptions.

In such cases, do not seek to fix the code. Instead, fix your (faulty) preconceptions, and fix your HTML file.

The 'a' tag, for example, is defined to be an inline tag, but the 'div' tab is a block-level tag.

I don't define 'a' to be inline, others do, e.g. http://www.w3.org/TR/html401/ and hence HTML::Tagset.

Inline means:

	<a href = "#NAME"><div class = 'global_toc_text'>NAME</div></a>

will I<not> be parsed as an 'a' containing a 'div'.

The 'a' tag will be closed before the 'div' is opened. So, the result will look like:

	<a href = "#NAME"></a><div class = 'global_toc_text'>NAME</div>

To achieve what was presumably intended, use 'span':

	<a href = "#NAME"><span class = 'global_toc_text'>NAME</span></a>

Some people (*cough* *cough*) have had to redo their entire websites due to this very problem.

Of course, this is just one of a vast set of possible problems.

You have been warned.

=item Why did you use Tree::Simple but not Tree or Tree::Fast or Tree::DAG_Node?

During testing, Tree::Fast crashed, so I replaced it with Tree and everything worked. Spooky.

Late news: Tree does not cope with an array ref stored in the metadata, so I've switched to Tree::DAG_Node.

Stop press: As an experiment I switched to Tree::Simple. Since it also works I'll just keep using it.

=item Why isn't this module called HTML::Parser::PurePerl?

=over 4

=item The API

That name sounds like a pure Perl version of the same API as used by HTML::Parser.

But the API's are not, and are not meant to be, compatible.

=item The tie-in

Some people might falsely assume HTML::Parser can automatically fall back to HTML::Parser::PurePerl in the absence of a compiler.

=back

=back

=head1 Required Modules

=over 4

=item Carp

=item Tree::Simple

=back

=head1 Credits

This Perl HTML parser has been converted from a JavaScript one written by John Resig.

http://ejohn.org/files/htmlparser.js

Well done John!

Note also the comments published here:

http://groups.google.com/group/envjs/browse_thread/thread/edd9033b9273fa58

=head1 Author

C<HTML::Parser::Simple> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2009.

Home page: http://savage.net.au/index.html

=head1 Copyright

Australian copyright (c) 2009 Ron Savage.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Artistic License, a copy of which is available at:
	http://www.opensource.org/licenses/index.html

=cut
