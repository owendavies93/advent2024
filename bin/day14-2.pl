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

while (1) {
    for my $bot (keys %$bots) {
        $bots->{$bot}->{x} += $bots->{$bot}->{vx};
        $bots->{$bot}->{x} %= $width;
        $bots->{$bot}->{y} += $bots->{$bot}->{vy};
        $bots->{$bot}->{y} %= $height;
    }

    $total++;

    my $pos_map = {};
    for my $bot (keys %$bots) {
        if (exists $pos_map->{$bots->{$bot}->{x}, $bots->{$bot}->{y}}) {
            last;
        }
        $pos_map->{$bots->{$bot}->{x}, $bots->{$bot}->{y}} = 1;
    }

    if (scalar keys %$pos_map == $num_bots) {
        submit($total);
        exit;
    }
}
