#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(all); 

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day9';
$file = "inputs/day9-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my $total = 0;
my $disk = {};
my $files = {};
my $loc = 0;
my $fill = 1;
my $next_id = 0;

while (<$fh>) {
    chomp;
    my @parts = split //;
    for my $part (@parts) {
        my $len = $part;
        if ($fill == 0) {
            $fill = 1;
        } else {
            $files->{$next_id} = [$loc, $len];
            for my $i (0 .. $len - 1) {
                $disk->{$loc + $i} = $next_id;
            }
            $next_id++;
            $fill = 0;
        }
        $loc += $len;
    }
}

my $id = $next_id - 1;
while ($id >= 0) {
    my $i = 0;
    while ($i < $files->{$id}[0]) {
        if (all { !exists $disk->{$i + $_} } 0 .. $files->{$id}[1] - 1)  {
            for my $j (0 .. $files->{$id}[1] - 1) {
                delete $disk->{$files->{$id}[0] + $j};
                $disk->{$i + $j} = $id;
            }
            last;
        }
        $i++;
    }
    $id--;
}

for my $key (sort keys %$disk) {
    $total += $disk->{$key} * $key;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
