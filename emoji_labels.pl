#!/usr/bin/perl
use strict;
use warnings;

my $emoji_data = "/usr/share/unicode/emoji/emoji-data.txt";
open(my $fh, "<", $emoji_data) or die "Could not open file '$emoji_data' $!";
my %emoji_labels;
while (my $row = <$fh>) {
	chomp $row;
	my @fields = split /;/, $row;
	my $emoji = $fields[0];
	if (!defined $fields[1]) {
		next;
	}
	my $label = $fields[1];
	$emoji_labels{$label} = $emoji;
}
close $fh;

foreach my $label (keys %emoji_labels) {
	print "Label: $label, Emoji: $emoji_labels{$label}\n";
}

my $label = $ARGV[0];
if (exists $emoji_labels{$label}) {
	print "Emoji for $label: $emoji_labels{$label}\n";
} else {
	print "No emoji found for $label\n";
}