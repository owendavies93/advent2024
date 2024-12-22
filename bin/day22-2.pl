#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_lines);
use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(max);
use POSIX qw(floor);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day22';
$file = "inputs/day22-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @nums = get_lines($fh);
my $totals = {};

for my $num (@nums) {
    my $cur_price = $num % 10;
    my @deltas;
    my $deltas_for_price = {};

    for my $i (1..2000) {
        $num = (($num * 64) ^ $num) % 16777216;
        $num = (floor($num / 32) ^ $num) % 16777216;
        $num = (($num * 2048) ^ $num) % 16777216;

        my $new_price = $num % 10;
        push @deltas, $new_price - $cur_price;
        $cur_price = $new_price;

        if ($i > 3) {
            my $k = join $;, @deltas;
            $deltas_for_price->{$k} //= $cur_price;
            shift @deltas;
        }
    }

    for my $k (keys %$deltas_for_price) {
        $totals->{$k} += $deltas_for_price->{$k};
    }

}
    
$total = max values %$totals;

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
