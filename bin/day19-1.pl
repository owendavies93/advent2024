#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use Memoize;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day19';
$file = "inputs/day19-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my $patterns = {};
while (<$fh>) {
    chomp;
    last if /^$/;
    my @patterns = split /, /;
    $patterns->{$_} = 1 for @patterns;
}

my @designs;
while (<$fh>) {
    chomp;
    push @designs, $_;
}

memoize('can_build');
sub can_build {
    my $design = shift;

    return 1 if $patterns->{$design};

    for my $pattern (keys %$patterns) {
        if ($design =~ /^$pattern/) {
            if (can_build(substr($design, length($pattern)))) {
                return 1;
            }
        }
    }

    return 0;
}

for my $design (@designs) {
    if (can_build($design)) {
        $total++;
    }
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
