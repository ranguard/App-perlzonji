use 5.008;
use strict;
use warnings;

package App::perlzonji::Plugin::Label;

# ABSTRACT: perlzonji plugin for labels
use App::perlzonji;
App::perlzonji->add_trigger(
    'matches.add' => sub {
        my ($class, $word, $matches) = @_;

     # Is it a label (ends with ':')? Do this after %found_in, because there are
     # special labels such as 'SKIP:' and 'TODO:' that map to Test::More
        if ($word =~ /^\w+:$/) { push @$matches, 'perlsyn' }
    }
);
1;

=head1 SYNOPSIS

    # perlzonji FOO:
    # (runs `perldoc perlsyn`)

=head1 DESCRIPTION

This plugin for L<App::perlzonji> checks whether the search term looks like a
label and if so, adds C<perlsyn> to the match results.
