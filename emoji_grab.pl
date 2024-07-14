#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;

my $url = "https://em-content.zobj.net/thumbs/60/google/387/";

my $emoji_labels_file = "./emoji_labels.txt";
open(my $fh, '<:encoding(UTF-8)', $emoji_labels_file) or die "Could not open file '$emoji_labels_file' $!";
my @emoji_labels = <$fh>;
close $fh;

foreach my $emoji_label (@emoji_labels) {
	$emoji_label =~ s/,.*//;
	chomp $emoji_label;
	my $emoji_url = $url . $emoji_label . ".webp";
	print "Downloading $emoji_url\n";
	mkdir "./emoji" unless -d "./emoji";
	my $emoji_content = `curl -o ./emoji/$emoji_label.webp $emoji_url`;
	die "Couldn't get $emoji_url" unless defined $emoji_content;
	open(my $fh, '>', "./emoji/$emoji_label.webp") or die "Could not open file '$emoji_label.webp' $!";
	binmode $fh;
	print $fh $emoji_content;
	close $fh;
}
