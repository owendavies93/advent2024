#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day10';
$file = "inputs/day10-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @grid = ();
my $height = 0;
my $width = 0;
while (<$fh>) {
    chomp;
    my @line = split //;
    push @grid, @line;
    $width = @line if $width == 0;
    $height++;
}

for my $y (0 .. $height - 1) {
    for my $x (0 .. $width - 1) {
        next unless $grid[$y * $width + $x] == 0;

        my @q;
        my $seen = {};
        push @q, [$x, $y, 0];
        while (@q) {
            my $q = shift @q;
            my ($x, $y, $elev) = @$q;
            if ($elev == 9) {
                $seen->{$x,$y} = 1;
            }

            for my $n ([-1, 0], [1, 0], [0, -1], [0, 1]) {
                my ($nx, $ny) = ($x + $n->[0], $y + $n->[1]);
                next unless $nx >= 0 && $nx < $width && $ny >= 0 && $ny < $height;

                if ($grid[$ny * $width + $nx] == $elev + 1) {
                    push @q, [$nx, $ny, $elev + 1];
                }
            }
        }

        $total += keys %$seen;
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
