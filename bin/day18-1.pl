#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Grid::Utils qw(d4);
use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day18';
$file = "inputs/day18-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $bytes = {};
my $max = $file =~ /test/ ? 12 : 1024;
my $i = 0;
while (<$fh>) {
    chomp;
    my ($a, $b) = split /,/, $_;
    $bytes->{$a, $b} = 1;
    $i++;
    last if $i == $max;
}

my $startx = 0;
my $starty = 0;
my $endx = $file =~ /test/ ? 6 : 70;
my $endy = $file =~ /test/ ? 6 : 70;

sub get_adjs {
    my ($x, $y) = @_;
    my @adjs;
    for my $d (d4) {
        my ($dx, $dy) = @$d;
        my $nx = $x + $dx;
        my $ny = $y + $dy;
        if ($nx >= 0 && $nx <= $endx && $ny >= 0 && $ny <= $endy && !exists $bytes->{$nx, $ny}) {
            push @adjs, [$nx, $ny];
        }
    }
    return @adjs;
}

my @q;
my $seen = {};
my $st = {};
push @q, [$startx, $starty];
$seen->{$startx, $starty} = 1;

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
            $total++;
            while (1) {
                $total++;
                $prev = $st->{$prev->[0], $prev->[1]};
                last if $prev->[0] == $startx && $prev->[1] == $starty;
            }
            last;
        } else {
            push @q, [$nx, $ny];
        }

        $seen->{$nx, $ny} = 1;
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
