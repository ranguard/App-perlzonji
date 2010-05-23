#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use App::perlzonji;
use Capture::Tiny qw(capture);

@ARGV = qw(--dry-run xor);
my ($stdout, $stderr) = capture {
    App::perlzonji->run;
};

is $stdout, '', 'STDOUT empty';
is $stderr, "perldoc perlop\n", 'xor -> perlop';
done_testing;
