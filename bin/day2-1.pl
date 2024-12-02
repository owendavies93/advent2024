#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day2';
$file = "inputs/day2-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
while (<$fh>) {
    chomp;
    my @nums = split /\s+/;
    my $valid = 1;
    my $decreasing = $nums[0] > $nums[1] ? 1 : 0;

    for (my $i = 0; $i < @nums - 1; $i++) {
        if (($decreasing && $nums[$i] <= $nums[$i + 1]) || 
            (!$decreasing && $nums[$i] >= $nums[$i + 1]) ||
            abs($nums[$i] - $nums[$i + 1]) > 3) {
            $valid = 0;
            last;
        }
    }

    $total++ if $valid;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
