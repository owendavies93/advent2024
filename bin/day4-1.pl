#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day4';
$file = "inputs/day4-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my @grid;
my $width;
my $height = 0;
while (<$fh>) {
    chomp;
    my @line = split //;
    push @grid, @line;
    $width = @line if !defined $width;
    $height++;
}

my @ds = (
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
);

my $total = 0;
for my $y (0 .. $height - 1) {
    for my $x (0 .. $width - 1) {
        for my $d (@ds) {
            my ($dy, $dx) = @$d;
            my $string = join '', map {
                my $ny = $y + $_ * $dy;
                my $nx = $x + $_ * $dx;
                my $index = $ny * $width + $nx;
                $nx < 0 || $ny < 0 || $nx >= $width || $ny >= $height ? '' : $grid[$index] // '';
            } 0..3;
            $total++ if $string eq 'XMAS';
        }
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
