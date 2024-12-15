#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day15';
$file = "inputs/day15-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my $boxes = {};
my $walls = {};
my $startx = 0;
my $starty = 0;
my $width = 0;
my $height = 0;

while (<$fh>) {
    chomp;
    if (!$_) {
        last;
    }

    my @row = split //;
    $width = @row if @row > $width;

    for my $i (0 .. @row - 1) {
        my $char = $row[$i];
        if ($char eq '#') {
            $walls->{$i, $height} = 1;
        } elsif ($char eq 'O') {
            $boxes->{$i, $height} = 1;
        } elsif ($char eq '@') {
            $startx = $i;
            $starty = $height;
        }
    }
    $height++;
}

my @instructions;
while (<$fh>) {
    chomp;
    my @row = split //;
    push @instructions, @row;
}

my $dirs = {
    '>' => [1, 0],
    '<' => [-1, 0],
    '^' => [0, -1],
    'v' => [0, 1],
};

my $pos = [$startx, $starty];

for my $dir (@instructions) {
    my ($dx, $dy) = @{$dirs->{$dir}};
    my ($nx, $ny) = ($pos->[0] + $dx, $pos->[1] + $dy);

    if (exists $boxes->{$nx, $ny}) {
        my $blocked = 0;
        my $i = 0;
        while (1) {
            my ($x1, $y1) = ($nx + $dx * $i, $ny + $dy * $i);
            if (exists $walls->{$x1, $y1}) {
                $blocked = 1;
                last;
            } elsif (!exists $boxes->{$x1, $y1}) {
                last;
            }
            $i++;
        }

        if (!$blocked) {
            $boxes->{$nx + $dx * $i, $ny + $dy * $i} = 1;
            delete $boxes->{$nx, $ny};
            $pos = [$nx, $ny];
        }
    } elsif (!exists $walls->{$nx, $ny}) {
        $pos = [$nx, $ny];
    }
}

for my $key (keys %$boxes) {
    my ($x, $y) = split $;, $key;
    $total += $x + 100 * $y;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
