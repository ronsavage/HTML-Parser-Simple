package Data;

# Author:
#	Ron Savage <ron@savage.net.au>
#
# Note:
#	\t = 4 spaces || die.

use strict;
use warnings;

our $VERSION = '1.04';

# -----------------------------------------------

# Preloaded methods go here.

# -----------------------------------------------

# Encapsulated class data.

{
	my(%_attr_data) =
	(
	 _input_dir => '',
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

	return $self;

}	# End of new.

# -----------------------------------------------

sub read_file
{
	my($self, $file_name) = @_;
	$file_name            = "$$self{'_input_dir'}/$file_name";

	open(INX, $file_name) || die "Can't open($file_name): $!";
	my($html);
	read(INX, $html, -s INX);
	close INX;

	return $html;

} # End of read_file.

# -----------------------------------------------

1;
