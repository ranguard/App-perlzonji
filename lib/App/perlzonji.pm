use 5.008;
use strict;
use warnings;

package App::perlzonji;

# ABSTRACT: A more knowledgeable perldoc
use Getopt::Long;
use Pod::Usage;
use Class::Trigger;
use Module::Pluggable require => 1;
__PACKAGE__->plugins;    # 'require' them

sub run {
    our %opt = ('perldoc-command' => 'perldoc');
    GetOptions(\%opt, qw(help|h|? man|m perldoc-command|c:s debug dry-run|n))
      or pod2usage(2);
    if ($opt{help}) {
        pod2usage(
            -exitstatus => 0,
            -input      => __FILE__,
        );
    }
    if ($opt{man}) {
        pod2usage(
            -exitstatus => 0,
            -input      => __FILE__,
            -verbose    => 2
        );
    }
    my $word = shift @ARGV;
	my $matches = find_matches($word);
    if (@$matches) {
        if (@$matches > 1) {
            warn sprintf "%s matches for [%s], using first (%s):\n",
              scalar(@$matches), $word, $matches->[0];
            warn "    $_\n" for @$matches;
        }
        execute($opt{'perldoc-command'}, $matches->[0]);
    }

    # fallback
    warn "assuming that [$word] is a built-in function\n" if $opt{debug};
    execute($opt{'perldoc-command'}, qw(-f), $word);
}

sub find_matches {
	my $word = shift;
    my @matches;
    __PACKAGE__->call_trigger('matches.add', $word, \@matches);
	return \@matches;
}

sub execute {
    our %opt;
    if ($opt{'dry-run'}) {

        # under --dry-run, don't pretend to execute more than once
        our $executed;
        return if $executed++;
        warn "@_\n";
    } else {
        warn "@_\n" if $opt{debug};
        exec @_;
    }
}
1;

=begin :prelude

=for stopwords Dieckow gozonji desu ka

=end :prelude

=head1 SYNOPSIS

    # perlzonji UNIVERSAL::isa
    # (runs `perldoc perlobj`)

=head1 DESCRIPTION

C<perlzonji> is like C<perldoc> except it knows about more things. Try these:

    perlzonji xor
    perlzonji foreach
    perlzonji isa
    perlzonji AUTOLOAD
    perlzonji TIEARRAY
    perlzonji INPUT_RECORD_SEPARATOR
    perlzonji '$^F'
    perlzonji PERL5OPT
    perlzonji :mmap
    perlzonji __WARN__
    perlzonji __PACKAGE__
    perlzonji head4

For efficiency, C<alias pod=perlzonji>.

The word C<zonji> means "knowledge of" in Japanese. Another example is the
question "gozonji desu ka", meaning "Do you know?" - "go" is a prefix added
for politeness.

=head1 OPTIONS

Options can be shortened according to L<Getopt::Long/"Case and abbreviations">.

=over

=item C<--perldoc-command>, C<-c>

Specifies the POD formatter/pager to delegate to. Default is C<perldoc>.
C<annopod> from L<AnnoCPAN::Perldoc> is a better alternative.

=item C<--debug>

Prints the whole command before executing it.

=item C<--dry-run>, C<-n>

Just print the command that would be executed; don't actually execute it.

=item C<--help>, C<-h>, C<-?>

Prints a brief help message and exits.

=item C<--man>, C<-m>

Prints the manual page and exits.

=back

=function run

The main function, which is called by the C<perlzonji> program.

=function try_module

Takes as argument the name of a module, tries to load that module and executes
the formatter, giving that module as an argument. If loading the module fails,
this subroutine does nothing.

=function execute

Executes the given command using C<exec()>. In debug mode, it also prints the
command before executing it.

