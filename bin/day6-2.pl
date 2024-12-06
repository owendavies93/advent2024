#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(firstidx);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day6';
$file = "inputs/day6-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $width;
my $height = 0;
my $grid = [];
my $startx = -1;
my $starty = -1;

while (<$fh>) {
    chomp;
    my @line = split //;
    push @$grid, @line;
    if (grep { $_ eq '^' } @line) {
        $startx = firstidx { $_ eq '^' } @line;
        $starty = $height;
    }
    $width = @line if !defined $width;
    $height++;
}

my $next_pos = {
    'N' => [0, -1],
    'E' => [1, 0],
    'S' => [0, 1],
    'W' => [-1, 0],
};
my $next_dirs = {
    'N' => 'E',
    'E' => 'S',
    'S' => 'W',
    'W' => 'N',
};

my $ox = $startx;
my $oy = $starty;
my $total = 0;

for (my $j = 0; $j < $height; $j++) {
    for (my $i = 0; $i < $width; $i++) {
        next if $grid->[$j * $width + $i] eq '#';
        next if $i == $ox && $j == $oy;

        $grid->[$j * $width + $i] = '#';

        my $dir = 'N';
        $startx = $ox;
        $starty = $oy;
        my $seen = {
            "$startx $starty $dir" => 1,
        };

        while (1) {
            my $next = $next_pos->{$dir};
            my ($nx, $ny) = ($startx + $next->[0], $starty + $next->[1]);

            last if $nx < 0 || $ny < 0 || $nx >= $width || $ny >= $height;

            if ($grid->[$ny * $width + $nx] eq '#') {
                $dir = $next_dirs->{$dir};
            } else {
                $startx = $nx;
                $starty = $ny;

                if (exists $seen->{"$startx $starty $dir"}) {
                    $total++;
                    last;
                }

                $seen->{"$startx $starty $dir"} = 1;
            }
        }

        $grid->[$j * $width + $i] = '.';
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
