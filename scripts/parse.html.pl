#!/usr/bin/env perl
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
	 input_dir  => '/home/ron',
	 output_dir => '/home/ron',
	 verbose    => 1,
 }
);

$p -> parse_file('s.1.html', 's.2.html');
