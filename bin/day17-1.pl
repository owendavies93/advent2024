#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Input qw(get_ints get_lines);
use Advent::Utils::Problem qw(submit);

use POSIX qw(floor);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day17';
$file = "inputs/day17-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @lines = get_lines($fh);

my ($a, $b, $c) = map { $_ =~ /(\d+)/ } @lines[0..2];

my @program = get_ints($lines[4]);
my $inst = 0;
my @output;

sub get_combo_operand {
    my $op = shift;
    
    die "Not a number" unless $op =~ /^\d+$/;
    die "Unknown operand $op" if $op > 6;
    
    return $op if $op <= 3;
    return $a if $op == 4;
    return $b if $op == 5;
    return $c if $op == 6;
}

my $instrs = {
    0 => sub {
        my $op = shift;
        my $den = get_combo_operand($op);
        $a = floor($a / 2 ** $den);
    },
    1 => sub {
        my $op = shift;
        $b = $op ^ $b;
    },
    2 => sub {
        my $op = shift;
        my $val = get_combo_operand($op);
        $b = $val % 8;
    },
    3 => sub {
        my $op = shift;
        $inst = $op if $a != 0;
    },
    4 => sub {
        $b = $b ^ $c;
    },
    5 => sub {
        my $op = shift;
        my $val = get_combo_operand($op);
        push @output, $val % 8;
    },
    6 => sub {
        my $op = shift;
        my $den = get_combo_operand($op);
        $b = floor($a / 2 ** $den);
    },
    7 => sub {
        my $op = shift;
        my $den = get_combo_operand($op);
        $c = floor($a / 2 ** $den);
    },
};

while ($inst < @program) {
    my $i = $program[$inst];
    my $op = $program[$inst + 1];

    $inst += 2;
    $instrs->{$i}($op);
}

say join ',', @output;
