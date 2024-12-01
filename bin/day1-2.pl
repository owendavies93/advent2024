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
my $twos = {};
while (<$fh>) {
    chomp;
    my ($a, $b) = split /\s+/;
    push @ones, $a;
    $twos->{$b}++;
}

for my $i (0..$#ones) {
    if (defined $twos->{$ones[$i]}) {
        $total += $ones[$i] * $twos->{$ones[$i]};
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
