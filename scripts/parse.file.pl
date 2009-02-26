#!/usr/bin/perl
#
# Name:
#    parse.file.pl.

use strict;
use warnings;

use HTML::Parser::Simple;

# -------------------------

my($p) = HTML::Parser::Simple -> new
(
 {
	 input_dir  => './scripts',
	 output_dir => './scripts',
	 verbose    => 1,
	 xhtml      => 1,
 }
);

# Works:
#$p -> parse_file('90.xml.declaration.xhtml', 'out.xhtml');

# Fails:
$p -> parse_file('91.mathml.xhtml', 'out.xhtml');
