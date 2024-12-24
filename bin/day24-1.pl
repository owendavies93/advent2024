#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day24';
$file = "inputs/day24-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $values = {};
while (<$fh>) {
    chomp;
    if (!$_) {
        last;
    }
    my ($name, $value) = split /: /;
    $values->{$name} = $value;
}

my $connections = {};
my $dependencies = {};
my @todo;
while (<$fh>) {
    chomp;
    my ($a, $op, $b, $c) = $_ =~ /(\w+) (AND|OR|XOR) (\w+) -> (\w+)/;
    $connections->{$a,$b} = [$op, $c];
    $dependencies->{$c} = [$a, $b, $op];
    push @todo, [$a, $b, $op, $c];
}

while (@todo) {
    my $k = pop @todo;
    my ($a, $b, $op, $c) = @$k;
    if (defined $values->{$a} && defined $values->{$b}) {
        $values->{$c} = int($values->{$a}) & int($values->{$b}) if $op eq 'AND';
        $values->{$c} = int($values->{$a}) | int($values->{$b}) if $op eq 'OR';
        $values->{$c} = int($values->{$a}) ^ int($values->{$b}) if $op eq 'XOR';
    } else {
        push @todo, [$a, $b, $op, $c];

        if (!defined $values->{$a}) {
            my $deps = $dependencies->{$a};
            push @todo, [$deps->[0], $deps->[1], $deps->[2], $a];
        }

        if (!defined $values->{$b}) {
            my $deps = $dependencies->{$b};
            push @todo, [$deps->[0], $deps->[1], $deps->[2], $b];
        }
    }
}

my @zs = grep { $_ =~ /^z/ } sort keys %$values;
my $binary_total = '';
for my $z (@zs) {
    $binary_total .= $values->{$z};
}
$binary_total = reverse $binary_total;
no warnings 'portable';
$total = oct("0b$binary_total");

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
