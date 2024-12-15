#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(none);
use Storable qw(dclone);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day15';
$file = "inputs/day15-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $grid;

while (<$fh>) {
    chomp;
    if (!$_) {
        last;
    }

    my @row = split //;
    my @expanded_row;
    for my $i (0 .. @row - 1) {
        my $char = $row[$i];
        if ($char eq '#') {
            push @expanded_row, '#';
            push @expanded_row, '#';
        } elsif ($char eq 'O') {
            push @expanded_row, '[';
            push @expanded_row, ']';
        } elsif ($char eq '@') {
            push @expanded_row, '@';
            push @expanded_row, '.';
        } else {
            push @expanded_row, '.';
            push @expanded_row, '.';
        }
    }
    push @$grid, \@expanded_row;
}

my $height = scalar @$grid;
my $width = scalar @{$grid->[0]};

my @instructions;
while (<$fh>) {
    chomp;
    my @row = split //;
    push @instructions, @row;
}

my $startx = 0;
my $starty = 0;
for my $i (0 .. $height - 1) {
    for my $j (0 .. $width - 1) {
        if ($grid->[$i][$j] eq '@') {
            $startx = $i;
            $starty = $j;
            last;
        }
    }
}

my $dirs = {
    '>' => [0, 1],
    '<' => [0, -1],
    '^' => [-1, 0],
    'v' => [1, 0],
};

for my $dir (@instructions) {
    my ($dx, $dy) = @{$dirs->{$dir}};
    my $blocked = 0;
    my $i = 0;
    my @q = ([$startx, $starty]);

    while ($i < @q) {
        my ($x, $y) = @{$q[$i]};
        my ($nx, $ny) = ($x + $dx, $y + $dy);

        if ($grid->[$nx]->[$ny] =~ /[\[\]]/) {
            if (none { $_->[0] == $nx && $_->[1] == $ny } @q) {
                push @q, [$nx, $ny];
            }
            if ($grid->[$nx]->[$ny] eq '[') {
                if (none { $_->[0] == $nx && $_->[1] == $ny + 1 } @q) {
                    push @q, [$nx, $ny + 1];
                }
            } elsif ($grid->[$nx]->[$ny] eq ']') {
                if (none { $_->[0] == $nx && $_->[1] == $ny - 1 } @q) {
                    push @q, [$nx, $ny - 1];
                }
            }
        } elsif ($grid->[$nx]->[$ny] eq '#') {
            $blocked = 1;
            last;
        }
        $i++;
    }

    if (!$blocked) {
        my $new_grid = dclone $grid;
        for my $q (@q) {
            my ($x, $y) = @$q;
            $new_grid->[$x]->[$y] = '.';
        }

        for my $q (@q) {
            my ($x, $y) = @$q;
            $new_grid->[$x + $dx]->[$y + $dy] = $grid->[$x]->[$y];
        }
        $grid = $new_grid;

        $startx += $dx;
        $starty += $dy;
    }
}

for my $x (0 .. $height - 1) {
    for my $y (0 .. $width - 1) {
        if ($grid->[$x]->[$y] eq '[') {
            $total += $y + 100 * $x;    
        }
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
