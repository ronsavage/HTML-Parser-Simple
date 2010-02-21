#!/usr/bin/perl
#
# Name:
#    parse.html.pl.

use strict;
use warnings;

use HTML::Parser::Simple;

# -------------------------

my($p) = HTML::Parser::Simple -> new
(
 {
	 input_dir  => '/var/www',
	 output_dir => '/tmp',
	 verbose    => 1,
 }
);

$p -> parse_file('s.1.html', 's.2.html');
