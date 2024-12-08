#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_lines);
use Advent::Utils::Problem qw(submit);

use Data::Dumper;
use List::AllUtils qw(all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day8';
$file = "inputs/day8-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $map = {};
my $maxx = 0;
my $maxy = 0;
while (<$fh>) {
    chomp;
    my @chars = split //;
    $maxx = $#chars;
    for my $i (0 .. $#chars) {
        if ($chars[$i] ne '.') {
            push @{$map->{$chars[$i]}}, [$i, $maxy];
        }
    }
    $maxy++;
}

my $antinodes = {};

for my $freq (keys %$map) {
    my $as = $map->{$freq};

    for my $u (@$as) {
        for my $v (@$as) {
            next if $u == $v;
            my ($ui, $uj) = @$u;
            my ($vi, $vj) = @$v;
            $antinodes->{"$ui,$uj"} = 1;
            $antinodes->{"$vi,$vj"} = 1;

            my $di = $ui - $vi;
            my $dj = $uj - $vj;

            my $mi = $ui + $di;
            my $mj = $uj + $dj;

            while ($mi >= 0 && $mi <= $maxx && $mj >= 0 && $mj < $maxy) {
                $antinodes->{"$mi,$mj"} = 1;
                $mi += $di;
                $mj += $dj;
            }

            $mi = $vi - $di;
            $mj = $vj - $dj;

            while ($mi >= 0 && $mi <= $maxx && $mj >= 0 && $mj < $maxy) {
                $antinodes->{"$mi,$mj"} = 1;
                $mi += $di;
                $mj += $dj;
            }
        }
    }
}

$total = scalar keys %$antinodes;
if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
