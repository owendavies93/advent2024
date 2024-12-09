#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(max);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day9';
$file = "inputs/day9-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my $disk = {};
my $loc = 0;
my $fill = 1;
my $next_id = 0;

while (<$fh>) {
    chomp;
    my @parts = split //;
    for my $part (@parts) {
        my $len = $part;
        if ($fill == 0) {
            $fill = 1;
        } else {
            for my $i (0 .. $len - 1) {
                $disk->{$loc + $i} = $next_id;
            }
            $next_id++;
            $fill = 0;
        }
        $loc += $len;
    }
}

$loc = 0;
my $end = max(keys %$disk);

while ($loc < $end) {
    if (exists $disk->{$end}) {
        my $id = $disk->{$end};
        delete $disk->{$end};
        while (exists $disk->{$loc}) {
            $loc++;
        }
        $disk->{$loc} = $id;
    }
    $end--;
}

for my $key (sort keys %$disk) {
    $total += $disk->{$key} * $key;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
