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

my @program = get_ints($lines[4]);

my $a = 0;

for (my $i = 1; $i <= scalar @program; $i++) {
    my @target = @program[-$i..-1];
    my $x = 0;

    while (1) {
        my $t = ($a * 8) + $x;
        my $out = try($t, 0, 0, \@program);

        if ((join "", @$out) eq (join "", @target)) {
            $a = $t;
            last;
        }
        $x += 1;
    }
}

say $a;

sub get_combo_operand {
    my ($a, $b, $c, $op) = @_;
    
    die "Not a number" unless $op =~ /^\d+$/;
    die "Unknown operand $op" if $op > 6;
    
    return $op if $op <= 3;
    return $a if $op == 4;
    return $b if $op == 5;
    return $c if $op == 6;
}

sub step {
    my ($a, $b, $c, $i, $prog) = @_;

    my $in = $prog->[$i];
    my $op = $prog->[$i + 1];
    my $out;

    if ($in == 0) {
        my $den = get_combo_operand($a, $b, $c, $op);
        $a = floor($a / 2 ** $den);
    } elsif ($in == 1) {
        $b = $op ^ $b;
    } elsif ($in == 2) {
        my $val = get_combo_operand($a, $b, $c, $op);
        $b = $val % 8;
    } elsif ($in == 3) {
        if ($a != 0) {
            $i = $op;
            return ($a, $b, $c, $i, $out);
        }
    } elsif ($in == 4) {
        $b = $b ^ $c;
    } elsif ($in == 5) {
        my $val = get_combo_operand($a, $b, $c, $op);
        $out = $val % 8;
    } elsif ($in == 6) {
        my $den = get_combo_operand($a, $b, $c, $op);
        $b = floor($a / 2 ** $den);
    } elsif ($in == 7) {
        my $den = get_combo_operand($a, $b, $c, $op);
        $c = floor($a / 2 ** $den);
    }

    $i += 2;
    return ($a, $b, $c, $i, $out);
}

sub try {
    my ($a, $b, $c, $program) = @_;

    my $inst = 0;
    my @output = ();
    while ($inst < @$program) {
        my $out;
        ($a, $b, $c, $inst, $out) = step($a, $b, $c, $inst, $program);
        push @output, $out if defined $out;
    }

    return \@output;
}

