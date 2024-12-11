#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use Memoize;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day11';
$file = "inputs/day11-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @nums;

while (<$fh>) {
    chomp;
    @nums = split /\s+/;
}

memoize('blink');
sub blink {
    my ($count, $times) = @_;

    if ($times == 0) {
        return 1;
    }

    if ($count == 0) {
        return blink(1, $times - 1);
    }

    if (length($count) % 2 == 0) {
        my @split = split //, $count;
        my $mid = int(@split / 2);
        my $lhs = join '', @split[0 .. $mid - 1];
        my $rhs = join '', @split[$mid .. @split - 1];
        return blink(int($lhs), $times - 1) + blink(int($rhs), $times - 1);
    } else {
        return blink($count * 2024, $times - 1);
    }
}

for my $num (@nums) {
    $total += blink($num, 25);
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
