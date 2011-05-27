#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use App::perlzonji;
my %expect = (
    'xor'                    => 'perlop',
    'foreach'                => 'perlsyn',
    'isa'                    => 'perlobj',
    'TIEARRAY'               => 'perltie',
    'AUTOLOAD'               => 'perlsub',
    'INPUT_RECORD_SEPARATOR' => 'perlvar',
    '$^F'                    => 'perlvar',
    'PERL5OPT'               => 'perlrun',
    ':mmap'                  => 'PerlIO',
    '__WARN__'               => 'perlvar',
    '__PACKAGE__'            => 'perldata',
    'head4'                  => 'perlpod',
);
while (my ($query, $result) = each %expect) {
    test_find_matches($query, $result, "$query -> $result");
}
done_testing;

sub test_find_matches {
    my ($args, $expect, $name) = @_;
    my $found = App::perlzonji::find_matches($args);
    is($expect, $found->[0], "find_matches() - $args ok");
    fail("Too many results") if scalar(@$found) != 1;
}
