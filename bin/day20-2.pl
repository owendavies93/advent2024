#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Grid::Utils qw(get_grid d4);
use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day20';
$file = "inputs/day20-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;

my ($grid, $width, $height) = get_grid($fh);

my $startx = 0;
my $starty = 0;
my $endx = 0;
my $endy = 0;
for my $y (0 .. $height - 1) {
    for my $x (0 .. $width - 1) {
        my $val = $grid->[$y * $width + $x];
        if ($val eq 'S') {
            $startx = $x;
            $starty = $y;
        } elsif ($val eq 'E') {
            $endx = $x;
            $endy = $y;
        }
    }
}

sub get_adjs {
    my ($x, $y) = @_;
    my @adjs;
    for my $dir (d4) {
        my ($nx, $ny) = ($x + $dir->[0], $y + $dir->[1]);
        push @adjs, [$nx, $ny] if $grid->[$ny * $width + $nx] ne '#';
    }
    return @adjs;
}

my @q;
my $seen = {};
my $st = {};
push @q, [$startx, $starty];
$seen->{$startx, $starty} = 1;
my @path;
my $in_path = {};

while (@q) {
    my $c = shift @q;
    my ($x, $y) = @$c;
    my @adjs = get_adjs($x, $y);

    for my $adj (@adjs) {
        my ($nx, $ny) = @$adj;
        next if $seen->{$nx, $ny};
        $st->{$nx, $ny} = [$x, $y];

        if ($nx == $endx && $ny == $endy) {
            my $prev = $st->{$nx, $ny};
            $in_path->{$nx, $ny} = 0;
            my $step = 1;
            while (1) {
                push @path, [$prev->[0], $prev->[1]];
                $in_path->{$prev->[0], $prev->[1]} = $step;
                $prev = $st->{$prev->[0], $prev->[1]};
                if ($prev->[0] == $startx && $prev->[1] == $starty) {
                    $step++;
                    push @path, [$startx, $starty];
                    $in_path->{$startx, $starty} = $step;
                    @path = reverse @path;
                    last;
                }
                $step++;
            }
            last;
        } else {
            push @q, [$nx, $ny];
        }
        $seen->{$nx, $ny} = 1;
    }
}

sub get_cheat_ends {
    my ($x, $y) = @_;
    my $cheat_ends = {};

    for my $i (-20 .. 21) {
        my $maxj = 20 - abs($i);
        for my $j (-$maxj .. $maxj) {
            if (defined $in_path->{$x + $i, $y + $j}) {
                $cheat_ends->{$x + $i, $y + $j} = 1;
            }
        }
    }
    return $cheat_ends;
}

my $saving = $file =~ /test/ ? 72 : 100;
for my $p (@path) {
    my ($x, $y) = @$p;
    my $cheat_ends = get_cheat_ends($x, $y);

    for my $cheat_end (keys %$cheat_ends) {
        my ($cx, $cy) = split $;, $cheat_end;

        my $diff = $in_path->{$x, $y} - $in_path->{$cx, $cy} - abs($x - $cx) - abs($y - $cy);
        if ($diff >= $saving) {
            $total++;
        }
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
