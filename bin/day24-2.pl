#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day24';
$file = "inputs/day24-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
while (<$fh>) {
    chomp;
    if (!$_) {
        last;
    }
}

my $dependencies = {};
while (<$fh>) {
    chomp;
    my ($a, $op, $b, $c) = $_ =~ /(\w+) (AND|OR|XOR) (\w+) -> (\w+)/;
    $dependencies->{$c} = [$a, $b, $op];
}

my $res = {};
for my $k (keys %$dependencies) {
    my ($a, $b, $op) = @{$dependencies->{$k}};

    if ($op eq 'AND' && $a ne 'x00' && $b ne 'x00') {
        for my $k2 (keys %$dependencies) {
            my ($a2, $b2, $op2) = @{$dependencies->{$k2}};
            if (($k eq $a2 || $k eq $b2) && $op2 ne 'OR') {
                $res->{$k} = 1;
            }
        }
    }

    if ($op eq 'XOR') {
        if ($a !~ /^[xyz]/ && $b !~ /^[xyz]/ && $k !~ /^[xyz]/) {
            $res->{$k} = 1;
        }
        for my $k2 (keys %$dependencies) {
            my ($a2, $b2, $op2) = @{$dependencies->{$k2}};
            if (($k eq $a2 || $k eq $b2) && $op2 eq 'OR') {
                $res->{$k} = 1;
            }
        }
    }
    
    if ($k =~ /^z/ && $op ne 'XOR') {
        $res->{$k} = 1;
    }
}

delete $res->{'z45'};
$total = join ',', sort keys %$res;

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}

# dgr,dtv,mtj,rrd,x00,y00,z29,z37 wrong
# djc,dtv,mtj,wrd,x00,y00,z29,z37 wrong
# djc,fgc,mtj,wrd,x00,y00,z12,z29 wrong

__END__

my $g = {};
for my $k (keys %$dependencies) {
    my ($a, $b, $op) = @{$dependencies->{$k}};
    my $expr = "$a $op $b";
    push @{$g->{$a}}, $expr;
    push @{$g->{$b}}, $expr;
    push @{$g->{$expr}}, $k;
}

my $dot = '';
$dot .= "digraph G {\n";

for my $e (sort keys %$g) {
    for my $dep (@{$g->{$e}}) {
        $dot .= "\"$e\" -> \"$dep\";\n";
    }
}

$dot .= "}\n";

open($fh, '>', 'graph.dot') or die $!;
print $fh $dot;
close($fh);

system('dot -Tpdf graph.dot -o graph.pdf');
