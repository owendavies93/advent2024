#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day5';
$file = "inputs/day5-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $rules = {};
while (<$fh>) {
    chomp;
    last if !$_;
    my ($a, $b) = split /\|/;
    push @{$rules->{$a}}, $b;
}

my $updates = [];
while (<$fh>) {
    chomp;
    my @parts = split /,/;
    push @$updates, \@parts;
}

for my $update (@$updates) {
    my $good = 1;
    for my $i (0..$#$update) {
        for my $j (0..$i) {
            $good = 0 if any { $update->[$j] eq $_ } @{$rules->{$update->[$i]}};
        }
    }

    if ($good) {
        $total += $update->[int(@$update / 2)];
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
