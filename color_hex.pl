#!/usr/bin/perl

use strict;
use warnings;

sub color_hex {
	my ($hex) = @_;
	my $red = $hex & 0b1000 ? 255 : 0;
	my $green = $hex & 0b0100 ? 255 : 0;
	my $blue = $hex & 0b0010 ? 255 : 0;
	my $intensity = $hex & 0b0001 ? 1 : 0;
	return sprintf("\033[38;2;%d;%d;%dm%X\033[0m", $red, $green, $blue, $hex);
}

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

if (@ARGV == 1 and $ARGV[0] eq "-h") {
	print("Usage: echo <hex> | perl color_hex.pl <dimensions>\n");
	print("\tEx.: echo \"08f\" | perl color_hex.pl \"72x72\"\n");
	print("\tEx.: cat ./hex.txt | perl color_hex.pl \"72x72\" | less -R\n");
	exit;
}

my $hex = do { local $/; <STDIN> };
chomp($hex);
$hex =~ s/.*://;
$hex = expand_hex($hex);

my ($width, $height);
if (@ARGV == 1) {
	my $size = $ARGV[0];
	($width, $height) = split /x/, $size;
	if ($width =~ /\d+/) {
		$height = $width;
	}
	elsif ($ARGV[0] !~ /^\d+x\d+$/ or length($hex) < $width){
		print("Invalid dimensions\n");
		exit;
	}
	for (my $y=0; $y<$width-(length($hex)%$width); $y++) {
		for (my $x=0; $x<$width; $x++) {
			my $index = $y * $width + $x;
			my $color = substr($hex, $index, 1);
			print(color_hex(hex($color)));
		}
		print("\n");
	}
}
else {
	for (my $i=0; $i<length($hex); $i++) {
		print(color_hex(hex(substr($hex, $i, 1))));
	}
	print("\n");
}