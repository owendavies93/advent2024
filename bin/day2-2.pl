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
    
    if (is_valid_sequence(@nums)) {
        $total++;
        next;
    }
    
    my $valid = 0;
    for (my $i = 0; $i < @nums - 1; $i++) {
        my @new_nums = @nums;
        splice @new_nums, $i, 1;
        if (is_valid_sequence(@new_nums)) {
            $total++;
            $valid = 1;
            last;
        }
    }
    next if $valid;
    
    my @last_nums = @nums;
    pop @last_nums;
    if (is_valid_sequence(@last_nums)) {
        $total++;
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}

sub is_valid_sequence {
    my (@nums) = @_;
    return 0 if @nums < 2;
    
    my $decreasing = $nums[0] > $nums[1] ? 1 : 0;
    
    for (my $i = 0; $i < @nums - 1; $i++) {
        if ($decreasing && $nums[$i] <= $nums[$i + 1]) {
            return 0;
        } elsif (!$decreasing && $nums[$i] >= $nums[$i + 1]) {
            return 0;
        } elsif (abs($nums[$i] - $nums[$i + 1]) > 3) {
            return 0;
        }
    }
    return 1;
}
