#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Parser::Simple;

# -----------------------

HTML::Parser::Simple -> new
(
	input_file  => 't/data/90.xml.declaration.xhtml',
	output_file => 'data/90.xml.declaration.xml',
	verbose     => 1,
	xhtml       => 1,
) -> parse_file;
