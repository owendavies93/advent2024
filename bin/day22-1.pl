#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_lines);
use Advent::Utils::Problem qw(submit);

use POSIX qw(floor);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day22';
$file = "inputs/day22-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @nums = get_lines($fh);

for my $num (@nums) {
    for my $i (1..2000) {
        $num = (($num * 64) ^ $num) % 16777216;
        $num = (floor($num / 32) ^ $num) % 16777216;
        $num = (($num * 2048) ^ $num) % 16777216;
    }

    $total += $num;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
