package Data;

use Moos; # Turns on strict and warnings. Provides 'has'.

our $VERSION = '2.00';

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
