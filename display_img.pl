#!/usr/bin/perl

use strict;
use warnings;
use Image::Magick;

# Check if the image file path is provided as a command-line argument
unless (@ARGV) {
	die "Usage: perl display_img.pl <image_file_path>\n";
}

my $image_file = shift @ARGV;

# Create a new Image::Magick object
my $image = Image::Magick->new;

# Read the image file
my $status = $image->Read($image_file);
die "Unable to read image file: $status" if $status;

# Set the terminal to UTF-8 encoding
binmode STDOUT, ":utf8";

# Resize to fit image in terminal
sub resize {
	my $image = shift;
	my ($width, $height) = $image->Get('width', 'height');
	my $cols = `tput cols`;
	my $rows = `tput lines`;
	chomp($cols, $rows);
	# my $ratio = $width / $height;
	# my $new_width = $cols;
	# my $new_height = $new_width / $ratio;
	# if ($new_height > $rows) {
	# 	$new_height = $rows;
	# 	$new_width = $new_height * $ratio;
	# }
	# $image->Resize(width => $new_width, height => $new_height);
	$image->Resize(width => $cols, height => $rows);
}

# Resize the image to fit in the terminal
resize($image);

# Loop through each pixel of the image and display it as a wide character with color
for my $y (0 .. $image->Get('height') - 1) {
	for my $x (0 .. $image->Get('width') - 1) {
		my ($r, $g, $b) = $image->GetPixel(x => $x, y => $y);
		my $color_code = sprintf("\033[38;2;%d;%d;%dm", $r * 255, $g * 255, $b * 255);
		print $color_code . "\N{U+2588}";
		print "\033[0m";  # Reset color at the end of each pixel
	}
	print "\n";
}

exit 0;