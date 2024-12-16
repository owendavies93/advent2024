#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Grid::Utils qw(get_grid);
use Advent::Utils::Problem qw(submit);

use Array::Heap::PriorityQueue::Numeric;
use List::AllUtils qw(sum);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day16';
$file = "inputs/day16-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my ($grid, $width, $height) = get_grid($fh);

my @dirs = ('N', 'S', 'E', 'W');

my $dir_map = {
    'N' => [0, -1],
    'S' => [0, 1],
    'E' => [1, 0],
    'W' => [-1, 0],
};

my $next_dir = {
    'N' => ['W', 'E'],
    'S' => ['E', 'W'],
    'E' => ['N', 'S'],
    'W' => ['S', 'N'],
};

my $startx = 0;
my $starty = 0;
my $endx = 0;
my $endy = 0;

for my $y (0 .. $height - 1) {
    for my $x (0 .. $width - 1) {
        if ($grid->[$y * $width + $x] eq 'S') {
            $startx = $x;
            $starty = $y;
        } elsif ($grid->[$y * $width + $x] eq 'E') {
            $endx = $x;
            $endy = $y;
        }
    }
}

my $edges = get_edge_list();

my ($best_path, $best_path_length, $best_path_nodes) = find_next_best_path($edges);

my $have_removed = {};

for my $i (1 .. $#$best_path - 1) {
    my $node = $best_path->[$i];
    my ($x, $y, $dir) = split $;, $node->{node};
    next if $have_removed->{$x, $y};
    $have_removed->{$x, $y} = 1;

    my $tmp = $edges->{$x, $y, $dir};
    delete $edges->{$x, $y, $dir};

    my ($new_path, $new_path_length, $new_path_nodes) = find_next_best_path($edges);

    if (@$new_path) {
        if ($new_path_length == $best_path_length) {
            $best_path_nodes->{$_} = 1 for keys %$new_path_nodes;
        }
    }
    $edges->{$x, $y, $dir} = $tmp;
}

$best_path_nodes->{$endx, $endy} = 1;
$total = scalar keys %$best_path_nodes;

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}

sub get_edge_list {
    my $e = {};

    for my $y (0 .. $height - 1) {
        for my $x (0 .. $width - 1) {
            next if $grid->[$y * $width + $x] eq '#';

            for my $dir (@dirs) {
                for my $next (@{$next_dir->{$dir}}) {
                    $e->{$x, $y, $dir}->{$x, $y, $next} = 1000;
                }

                my $nx = $x + $dir_map->{$dir}[0];
                my $ny = $y + $dir_map->{$dir}[1];

                if ($grid->[$ny * $width + $nx] ne '#') {
                    $e->{$x, $y, $dir}->{$nx, $ny, $dir} = 1;
                }
            }
        }
    }

    return $e;
}

sub find_next_best_path {
    my $edge_list = shift;
    my $dist = {};
    my $prev = {};
    my $q = Array::Heap::PriorityQueue::Numeric->new;
    my @path;

    $dist->{$startx, $starty, 'E'} = 0;
    $q->add([$startx, $starty, 'E'], 0);

    while(1) {
        my $c = $q->get();

        if (!defined $c) {
            return [];
        }

        my ($x, $y, $dir) = @$c;
        if ($x == $endx && $y == $endy) {
            my $nodes = {};
            my $length = 0;
            while (1) {
                my $p = $prev->{$x, $y, $dir};
                my $w = $edge_list->{$p}->{$x, $y, $dir};
                push @path, {
                    node => $p,
                    weight => $w,
                };
                $nodes->{$x, $y} = 1;
                $length += $w;
                ($x, $y, $dir) = split $;, $p;

                last if $x == $startx && $y == $starty && $dir eq 'E';
            }
            return (\@path, $length, $nodes);
        }

        for my $n (keys %{$edge_list->{$x, $y, $dir}}) {
            my ($nx, $ny, $ndir) = split $;, $n;
            my $nd = $dist->{$x, $y, $dir} + $edge_list->{$x, $y, $dir}->{$nx, $ny, $ndir};
            if (!defined $dist->{$nx, $ny, $ndir} || $nd < $dist->{$nx, $ny, $ndir}) {
                $dist->{$nx, $ny, $ndir} = $nd;
                $prev->{$nx, $ny, $ndir} = join $;, ($x, $y, $dir);
                $q->add([$nx, $ny, $ndir], $nd);
            }
        }
    }
}
