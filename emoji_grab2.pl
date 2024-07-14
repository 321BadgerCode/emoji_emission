#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;

my $url="https://unicode-org.github.io/emoji/emoji/charts-13.1/emoji-list.html";
my $content = get $url;
die "Couldn't get $url" unless defined $content;
my @lines = split /\n/, $content;
my $img_regex = qr/\<img alt='([^"]+)' title='([^"]+)' class='imga' src='data:([^"]+)'>/;
foreach my $line (@lines) {
	if ($line =~ m/$img_regex/) {
		my $name = $1;
		my $src = $3;
		$src =~ s/image\/png;base64,//;
		`echo "$src" | base64 -d > ./emoji/$name.png`;
		print("Downloaded $name\n");
	}
}