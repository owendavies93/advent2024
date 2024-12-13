#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_nonempty_groups);
use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day13';
$file = "inputs/day13-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @groups = get_nonempty_groups($fh);

for my $group (@groups) {
    my ($a, $b, $prize) = @$group;
    my ($ax, $ay) = $a =~ /X\+(\d+), Y\+(\d+)/;
    my ($bx, $by) = $b =~ /X\+(\d+), Y\+(\d+)/;
    my ($px, $py) = $prize =~ /X=(\d+), Y=(\d+)/;
    $px += 10000000000000;
    $py += 10000000000000;

    my $eq = "Solve[a * $ax + b * $bx == $px && a * $ay + b * $by == $py, {a, b}, Integers]";
    my $sol = `wolframscript -code "$eq"`;
    chomp $sol;

    next if $sol eq "{}";
    
    my ($an, $bn) = $sol =~ /a\s*->\s*(\d+)\s*,\s*b\s*->\s*(\d+)/;
    $total += (3 * $an) + $bn;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
