package Data;

use strict;
use warnings;

use Moos;

our $VERSION = '1.06';

# -----------------------------------------------

sub read_file
{
	my($self, $file_name) = @_;

	open(INX, $file_name) || die "Can't open($file_name): $!";
	my($html);
	read(INX, $html, -s INX);
	close INX;

	return $html;

} # End of read_file.

# -----------------------------------------------

1;
