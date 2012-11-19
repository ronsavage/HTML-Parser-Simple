#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Parser::Simple::Reporter;

# ---------------------------------

print "$_\n" for @{HTML::Parser::Simple::Reporter -> new -> traverse_file('s.1.html')};
