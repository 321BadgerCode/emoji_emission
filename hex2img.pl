#!/usr/bin/perl

use strict;
use warnings;
use Image::Magick;
use POSIX;

sub expand_hex {
	my ($compressed) = @_;
	my $uncompressed = '';

	while ($compressed =~ /(\d+)([^0-9])/g) {
		my $count = $1;
		my $cur = $2;
		my $char = sprintf("%x",ord($cur)-ord(' '));
		$uncompressed .= $char x $count;
	}

	return $uncompressed;
}

my $input = do { local $/; <STDIN> };

my @lines = split /\n/, $input;

foreach my $line (@lines) {
	my ($filename, $hexdata) = split /:/, $line;

	my $image = Image::Magick->new;

	$image->Set(size => '72x72');
	$image->ReadImage('xc:black');

	my @pixels = split //, expand_hex($hexdata);

	for (my $y=0; $y<$image->Get('height'); $y++) {
		for (my $x=0; $x<$image->Get('width'); $x++) {
			my $index = $y * $image->Get('width') + $x;
			my $hex_val = hex($pixels[$index]);
			my $r = $hex_val & 0b1000;
			my $g = $hex_val & 0b0100;
			my $b = $hex_val & 0b0010;
			my $i = ($hex_val & 0b0001) ? 1 : .5;
			my @pixel = ($r*0xff, $g*0xff, $b*0xff);
			for (my $j = 0; $j < 3; $j++) {
				$pixel[$j] = $pixel[$j] * $i;
			}
			$image->Set('pixel['.$x.','.$y.']'=>sprintf("rgb(%d,%d,%d)", $pixel[0], $pixel[1], $pixel[2]));
		}
	}

	$image->Write($filename.'.png');
}
