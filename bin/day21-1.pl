#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(min);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day21';
$file = "inputs/day21-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @rows;
while (<$fh>) {
    chomp;
    push @rows, [split //, $_];
}

my $pad = to_keypad('789456123.0A');

my $dotx = $pad->{'.'}->{x};
my $doty = $pad->{'.'}->{y};

my @dirs = (
    [-1, 0, '<'],
    [1, 0, '>'],
    [0, -1, '^'],
    [0, 1, 'v'],
);

for my $row (@rows) {
    my $shortest = 0;
    my $x = $pad->{'A'}->{x};
    my $y = $pad->{'A'}->{y};

    for my $c (@$row) {
        my $nx = $pad->{$c}->{x};
        my $ny = $pad->{$c}->{y};

        $shortest += best_pad($x, $y, $nx, $ny, 4, $dotx, $doty);

        $x = $nx;
        $y = $ny;
    }

    no warnings 'numeric';
    $total += $shortest * int(join '', @$row);
}

sub best_path {
    my ($path, $num_robots) = @_;

    return length($path) if $num_robots == 1;

    my $best = 0;
    my $pad = to_keypad(".^A<v>");

    my $x = $pad->{'A'}->{x};
    my $y = $pad->{'A'}->{y};

    my @split = split //, $path;
    for my $s (@split) {
        my $nx = $pad->{$s}->{x};
        my $ny = $pad->{$s}->{y};
        my $dotx = $pad->{'.'}->{x};
        my $doty = $pad->{'.'}->{y};

        $best += best_pad($x, $y, $nx, $ny, $num_robots, $dotx, $doty);

        $x = $nx;
        $y = $ny;
    }

    return $best;
}

sub best_pad {
    my ($x, $y, $nx, $ny, $num_robots, $dotx, $doty) = @_;

    my $result = ~0;

    my @q;
    push @q, [$x, $y, ""];
    while (@q) {
        my $c = shift @q;
        my ($cx, $cy, $path) = @$c;

        if ($cx == $nx && $cy == $ny) {
            $result = min($result, best_path($path . 'A', $num_robots - 1));
        } elsif (!($cx == $dotx && $cy == $doty)) {
            for my $dir (@dirs) {
                my ($ox, $oy, $val) = @$dir;
                if (is_valid_change($cx, $nx, $ox) || is_valid_change($cy, $ny, $oy)) {
                    push @q, [$cx+$ox, $cy+$oy, $path . $val];
                }
            }
        }
    }

    return $result;
}

sub to_keypad {
    my $value = shift;
    
    my $vals = {};
    my @split = split //, $value;
    for my $i (0 .. $#split) {
        $vals->{$split[$i]} = { x => $i % 3, y => int($i / 3) };
    }
    return $vals;
}

sub is_valid_change {
    my ($start, $dest, $change) = @_;
    return ($change < 0 && $dest < $start) || ($change > 0 && $dest > $start);
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
