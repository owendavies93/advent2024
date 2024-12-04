#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day4';
$file = "inputs/day4-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my @grid;
my $width;
my $height = 0;
while (<$fh>) {
    chomp;
    my @line = split //;
    push @grid, @line;
    $width = @line if !defined $width;
    $height++;
}

my $total = 0;
for my $y (1 .. $height - 2) {
    for my $x (1 .. $width - 2) {
        if ($grid[$y * $width + $x] eq 'A') {
            my $tl = get($x - 1, $y - 1);
            my $tr = get($x + 1, $y - 1); 
            my $bl = get($x - 1, $y + 1);
            my $br = get($x + 1, $y + 1);

            $total++ if $tl eq 'M' && $tr eq 'M' && $bl eq 'S' && $br eq 'S';
            $total++ if $tl eq 'S' && $tr eq 'S' && $bl eq 'M' && $br eq 'M';
            $total++ if $tl eq 'S' && $tr eq 'M' && $bl eq 'S' && $br eq 'M';
            $total++ if $tl eq 'M' && $tr eq 'S' && $bl eq 'M' && $br eq 'S';
        }
    }
}

sub get {
    my ($x, $y) = @_;
    my $index = $y * $width + $x;
    return $grid[$index] // '';
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
