#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use Algorithm::Combinatorics qw(variations_with_repetition);
use List::AllUtils qw(zip);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day7';
$file = "inputs/day7-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $sum = 0;
my @ops = ('+', '*');

while (<$fh>) {
    chomp;
    my ($total, $nums) = split /:\s+/;
    my @nums = split /\s+/, $nums;

    my $iter = variations_with_repetition(\@ops, scalar @nums - 1);
    while (my $v = $iter->next) {
        my @eq = zip(@nums, @$v);
        pop @eq;

        my $running = shift @eq;
        while (@eq) {
            my ($op, $a) = splice @eq, 0, 2;
            $running = $op eq '+' ? $running + $a : $running * $a;
        }

        if ($running == $total) {
            $sum += $total;
            last;
        }
    }
}

if ($file !~ /test/) {
    submit($sum);
} else {
    say $sum;
}
