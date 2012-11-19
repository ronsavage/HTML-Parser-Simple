#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Parser::Simple;

# -----------------------

my($p) = HTML::Parser::Simple -> new
(
	input_file  => 'data/s.1.html',
	output_file => 'data/s.2.html',
	verbose     => 1,
);

$p -> parse_file;

print $p -> result;
