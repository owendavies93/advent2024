#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Grid::Utils qw(get_grid d4);
use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day12';
$file = "inputs/day12-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my ($grid, $width, $height) = get_grid($fh);

my $regions = {};
my $region_num = 0;
for my $y (0 .. $height - 1) {
    for my $x (0 .. $width - 1) {
        if (!exists $regions->{$x,$y}) {
            get_region($x, $y, $grid->[$y * $width + $x], $region_num);
            $region_num++;
        }
    }
}

my $region_nums = {};
for my $r (keys %$regions) {
    $region_nums->{$regions->{$r}}->{$r} = 1;
}

for my $r (keys %$region_nums) {
    my $area = keys %{$region_nums->{$r}};
    my $perimeter = 0;
    my $perimeter_points = {};
    for my $p (keys %{$region_nums->{$r}}) {
        my ($x, $y) = split $;, $p;
        for my $d (d4) {
            my $nx = $x + $d->[0];
            my $ny = $y + $d->[1];
            if (!exists $region_nums->{$r}->{$nx,$ny}) {
                $perimeter++;
            }
        }
    }

    $total += $area * $perimeter;
}

no warnings 'recursion';
sub get_region {
    my ($x, $y, $char, $num) = @_;
    if (!exists $regions->{$x,$y}) {
        if ($x >= 0 && $x < $width && $y >= 0 && $y < $height) {
            if ($grid->[$y * $width +$x] eq $char) {
                $regions->{$x,$y} = $num;
                for my $d (d4) {
                    get_region($x + $d->[0], $y + $d->[1], $char, $num);
                }
            }
        }
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
