#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day1';
$file = "inputs/day1-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @ones;
my @twos;
while (<$fh>) {
    chomp;
    my ($a, $b) = split /\s+/;
    push @ones, $a;
    push @twos, $b;
}

my @sorted_ones = sort { $a <=> $b } @ones;
my @sorted_twos = sort { $a <=> $b } @twos; 

for my $i (0..$#sorted_ones) {
    my $max = $sorted_ones[$i] > $sorted_twos[$i] ? $sorted_ones[$i] : $sorted_twos[$i];
    my $min = $sorted_ones[$i] < $sorted_twos[$i] ? $sorted_ones[$i] : $sorted_twos[$i];
    $total += $max - $min;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
