#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use Array::Utils qw(:all);
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

my $groups = {};
for my $key (keys %$connections) {
    my @conns = @{$connections->{$key}};
    for my $c1 (@conns) {
        my @c2 = intersect(@conns, @{$connections->{$c1}});
        for my $c2 (@c2) {
            my $k = join $;, sort $key, $c1, $c2;
            $groups->{$k} = 1;
        }
    }
}

for my $key (keys %$groups) {
    my @keys = split $;, $key;
    $total++ if any { $_ =~ /^t/ } @keys;
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
