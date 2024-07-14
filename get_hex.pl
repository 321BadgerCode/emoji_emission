#!/usr/bin/perl

# for file in ./emoji/*; do perl ./get_hex.pl $file >> ./hex.txt && echo "$file"; done

use strict;
use warnings;
use Image::Magick;

sub inverse_rgbi {
	my ($rgbi) = shift;
	my $bits = length(sprintf("%b", $rgbi));
	my $mask = (1<<$bits)-1;
	return ~$rgbi & $mask;
}

sub convert_pixel_to_rgbi {
	my ($red, $green, $blue) = @_;
	my $intensity = ($red + $green + $blue) / 3 > 0x80 ? 1 : 0;
	my $rgbi = ($red > 0x50) << 3 | ($green > 0x50) << 2 | ($blue > 0x50) << 1 | $intensity;
	$rgbi = $rgbi == 0b0100 ? 0b0000 : $rgbi;
	return chr($rgbi + ord(' '));
}

sub convert_image_to_hex_string {
	my ($image_path) = @_;
	my $image = Image::Magick->new;
	$image->Read($image_path);
	my $hex_string = "";
	for (my $y = 0; $y < $image->Get('height'); $y++) {
		for (my $x = 0; $x < $image->Get('width'); $x++) {
			my ($red, $green, $blue) = $image->GetPixel(x => $x, y => $y);
			$hex_string .= convert_pixel_to_rgbi($red * 255, $green * 255, $blue * 255);
		}
	}
	return $hex_string;
}

sub get_unicode_hex {
	my ($file) = @_;
	my $path = $file =~ s/(.*\/).*/$1/r;
	my $char = $file =~ s/.*\/(.*).png/$1/r;
	utf8::decode($char);
	my $hex_value = unpack('U*', $char);
	$hex_value = sprintf("%.5X", $hex_value);
	return uc($hex_value);
}

sub find_consecutive_duplicates {
	my ($hex) = @_;
	my $count = 1;
	my $previous = substr($hex, 0, 1);
	my $result = "";
	for (my $i = 1; $i < length($hex); $i++) {
		my $current = substr($hex, $i, 1);
		if ($current eq $previous) {
			$count++;
		}
		else {
			$result .= $count.$previous;
			$count = 1;
		}
		$previous = $current;
	}
	$result .= $count.$previous;
	return $result;
}

print("Usage: perl get_hex.pl <image_path>\n") and exit if @ARGV != 1;
my $image_path = $ARGV[0];
my $hex_string = convert_image_to_hex_string($image_path);
$hex_string = find_consecutive_duplicates($hex_string);
print get_unicode_hex($image_path).":".$hex_string."\n";
# TODO: compress hex code by using range. it'll be like 0{0-100,125}1{101-124}
	# algorithm would say 0-100 are '1' and then it would see comma and look for which value has the 101, which would be '1' in this instance