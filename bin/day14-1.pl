#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints);
use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day14';
$file = "inputs/day14-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $bots = {};
my $num_bots = 0;
while (<$fh>) {
    chomp;
    my ($x, $y, $vx, $vy) = get_ints($_, 1);
    $bots->{$num_bots} = { x => $x, y => $y, vx => $vx, vy => $vy };
    $num_bots++;
}

my $height = 103;
my $width = 101;
if ($file =~ /test/) {
    $height = 7;
    $width = 11;
}

for my $i (0 .. 99) {
    for my $bot (keys %$bots) {
        $bots->{$bot}->{x} += $bots->{$bot}->{vx};
        $bots->{$bot}->{x} %= $width;
        $bots->{$bot}->{y} += $bots->{$bot}->{vy};
        $bots->{$bot}->{y} %= $height;
    }
}

my $pos_map = {};
for my $bot (keys %$bots) {
    $pos_map->{$bots->{$bot}->{x}, $bots->{$bot}->{y}}++;
}

my $mid_y = int($height / 2);
my $mid_x = int($width / 2);

my $tl = 0;
my $tr = 0;
my $bl = 0;
my $br = 0;

for my $p (keys %$pos_map) {
    my ($x, $y) = split $;, $p;
    if ($x < $mid_x && $y < $mid_y) {
        $tl += $pos_map->{$x, $y};
    }
    if ($x > $mid_x && $y < $mid_y) {
        $tr += $pos_map->{$x, $y};
    }
    if ($x < $mid_x && $y > $mid_y) {
        $bl += $pos_map->{$x, $y};
    }
    if ($x > $mid_x && $y > $mid_y) {
        $br += $pos_map->{$x, $y};
    }
}

$total = $tl * $tr * $bl * $br;

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
