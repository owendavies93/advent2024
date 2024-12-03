#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day3';
$file = "inputs/day3-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
while (<$fh>) {
    chomp;

    my @split = split /do\(\)/, $_;
    for my $str (@split) {
        my @subsplit = split "don't()", $str;
        my $do = $subsplit[0];
        my @muls = $do =~ m/mul\((\d+),(\d+)\)/g;
        for my $pair (pairs @muls) {
            $total += $pair->[0] * $pair->[1];
        }
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
