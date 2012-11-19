#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Parser::Simple;

# -------------------------

HTML::Parser::Simple -> new(input_file => 's.1.html', output_file => 's.2.html') -> parse_file;
