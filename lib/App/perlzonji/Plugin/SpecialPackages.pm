use 5.008;
use strict;
use warnings;

package App::perlzonji::Plugin::SpecialPackages;

# ABSTRACT: Plugin to find documentation for special Perl packages
use App::perlzonji;
App::perlzonji->add_trigger(
    'matches.add' => sub {
        my ($class, $word, $matches) = @_;
        $word =~ /^UNIVERSAL::/ && push @$matches, 'perlobj';
        $word =~ /^CORE::/      && push @$matches, 'perlsub';
    }
);
1;

=head1 SYNOPSIS

    # perlzonji UNIVERSAL::isa
    # (runs `perldoc perlobj`)

=head1 DESCRIPTION

This plugin for L<App::perlzonji> knows where special Perl packages like
C<UNIVERSAL::> and C<CORE::> are documented.
