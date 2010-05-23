#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use App::perlzonji;
use Capture::Tiny qw(capture);
test_zonji(
    [qw(-c foobar --dry-run xor)],
    "foobar perlop\n",
    'foobar: xor -> perlop'
);
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
    test_zonji([ '-n', $query ], "perldoc $result\n", "$query -> $result");
}
done_testing;

sub test_zonji {
    my ($args, $expect, $name) = @_;
    $App::perlzonji::executed = 0;
    @ARGV                     = @$args;
    my ($stdout, $stderr) = capture {
        App::perlzonji->run;
    };
    subtest join(' ' => @$args) => sub {
        is $stdout, '', 'STDOUT empty';
        is $stderr, $expect, $name;
        done_testing;
    };
}
