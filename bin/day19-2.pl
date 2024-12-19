#!/usr/bin/env perl
use Mojo::Base -strict;

use lib "../cheatsheet/lib";

use Advent::Utils::Problem qw(submit);

use Memoize;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day19';
$file = "inputs/day19-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;
my $total = 0;
my @patterns;
while (<$fh>) {
    chomp;
    last if /^$/;
    @patterns = split /, /;
}

my @designs;
while (<$fh>) {
    chomp;
    push @designs, $_;
}

memoize('can_build');
sub can_build {
    my $design = shift;

    return 1 if $design eq "";

    my $ways = 0;
    for my $pattern (@patterns) {
        if ($design =~ /^$pattern/) {
            $ways += can_build(substr($design, length($pattern)));
        }
    }
    return $ways;
}

for my $design (@designs) {
    $total += can_build($design);
}

if ($file !~ /test/) {
    submit($total);
} else {
    say $total;
}
