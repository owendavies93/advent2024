#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use List::AllUtils qw(:all);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day23';
$file = "inputs/day23-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $connections = {};
while (<$fh>) {
    chomp;
    my ($a, $b) = split /-/;
    push @{$connections->{$a}}, $b;
    push @{$connections->{$b}}, $a;
}

my @groups = ();
push @groups, { $_ => 1 } for keys %$connections;

for my $group (@groups) {
    for my $c (keys %$connections) {
        if (none {
                my $c2 = $_;
                !grep { $_ eq $c } @{$connections->{$c2}}
            } keys %$group) {
            $group->{$c} = 1;
        }
    }
}

my $best = 0;
for my $group (@groups) {
    my $size = keys %$group;
    if ($size > $best) {
        $best = $size;
        $total = join ",", sort keys %$group;
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
