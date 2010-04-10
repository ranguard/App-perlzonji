use 5.008;
use strict;
use warnings;

package App::perlzonji::Plugin::FoundIn;

# ABSTRACT: perlzonji plugin to find documentation for syntax and concepts
use App::perlzonji;

# Specify like this because it's easier. We compute the reverse later (i.e.,
# it should be easier on the hacker than on the computer).
#
# Note: 'for' is a keyword for perlpod as well ('=for'), but is listed for
# perlsyn here, as that's more likely to be the intended meaning.
our %found_in = (
    perlop => [
        qw(lt gt le ge eq ne cmp not and or xor s m tr y
          q qq qr qx qw)
    ],
    perlsyn => [qw(if else elsif unless while until for foreach)],
    perlobj => [qw(isa ISA can VERSION)],
    perlsub => [qw(AUTOLOAD BEGIN CHECK INIT END DESTROY)],
    perltie => [
        qw(TIESCALAR TIEARRAY TIEHASH TIEHANDLE FETCH STORE UNTIE
          FETCHSIZE STORESIZE POP PUSH SHIFT UNSHIFT SPLICE DELETE EXISTS
          EXTEND CLEAR FIRSTKEY NEXTKEY WRITE PRINT PRINTF READ READLINE GETC
          CLOSE)
    ],
    perlvar => [
        qw(_ a b 0 1 2 3 4 5 6 7 8 9 ARG STDIN STDOUT STDERR ARGV ENV PREMATCH
          MATCH POSTMATCH LAST_PAREN_MATCH LAST_SUBMATCH_RESULT
          LAST_MATCH_END MULTILINE_MATCHING INPUT_LINE_NUMBER NR
          INPUT_RECORD_SEPARATOR RS OUTPUT_AUTOFLUSH OUTPUT_FIELD_SEPARATOR
          OFS OUTPUT_RECORD_SEPARATOR ORS LIST_SEPARATOR SUBSCRIPT_SEPARATOR
          SUBSEP FORMAT_PAGE_NUMBER FORMAT_LINES_PER_PAGE FORMAT_LINES_LEFT
          LAST_MATCH_START FORMAT_NAME FORMAT_TOP_NAME
          FORMAT_LINE_BREAK_CHARACTERS FORMAT_FORMFEED ACCUMULATOR
          CHILD_ERROR CHILD_ERROR_NATIVE ENCODING OS_ERROR ERRNO
          EXTENDED_OS_ERROR EVAL_ERROR PROCESS_ID PID REAL_USER_ID UID
          EFFECTIVE_USER_ID EUID REAL_GROUP_ID GID EFFECTIVE_GROUP_ID EGID
          PROGRAM_NAME COMPILING DEBUGGING RE_DEBUG_FLAGS RE_TRIE_MAXBUF
          SYSTEM_FD_MAX INPLACE_EDIT OSNAME OPEN PERLDB
          LAST_REGEXP_CODE_RESULT EXCEPTIONS_BEING_CAUGHT BASETIME TAINT
          UNICODE UTF8CACHE UTF8LOCALE PERL_VERSION WARNING WARNING_BITS
          WIN32_SLOPPY_STAT EXECUTABLE_NAME ARGVOUT INC SIG __DIE__ __WARN__
          $& $` $' $+ $^N @+ %+ $. $/ $| $\ $" $; $% $= $- @- %- $~ $^ $:
          $? $! %! $@ $$ $< $> $[ $] $^A $^C $^D $^E $^F $^H $^I $^L
          $^M $^O $^P $^R $^S $^T $^V $^W $^X %^H @F @_
          ), '$,', '$(', '$)',
    ],
    perlrun => [
        qw(HOME LOGDIR PATH PERL5LIB PERL5OPT PERLIO PERLIO_DEBUG PERLLIB
          PERL5DB PERL5DB_THREADED PERL5SHELL PERL_ALLOW_NON_IFS_LSP
          PERL_DEBUG_MSTATS PERL_DESTRUCT_LEVEL PERL_DL_NONLAZY PERL_ENCODING
          PERL_HASH_SEED PERL_HASH_SEED_DEBUG PERL_ROOT PERL_SIGNALS
          PERL_UNICODE)
    ],
    perlpod => [
        qw(head1 head2 head3 head4 over item back cut pod begin
          end)
    ],
    perldata => [qw(__FILE__ __LINE__ __PACKAGE__)],

    # We could also list common functions and methods provided by some
    # commonly used modules, like:
    Moose => [
        qw(has before after around super override inner augment confessed
          extends with)
    ],
    Error        => [qw(try catch except otherwise finally record)],
    SelfLoader   => [qw(__DATA__ __END__ DATA)],
    Storable     => [qw(freeze thaw)],
    Carp         => [qw(carp cluck croak confess shortmess longmess)],
    'Test::More' => [
        qw(plan use_ok require_ok ok is isnt like unlike cmp_ok
          is_deeply diag can_ok isa_ok pass fail eq_array eq_hash eq_set skip
          todo_skip builder SKIP: TODO:)
    ],
    'Getopt::Long' => [qw(GetOptions)],
    'File::Find'   => [qw(find finddepth)],
    'File::Path'   => [qw(mkpath rmtree)],
    'File::Spec'   => [
        qw(canonpath catdir catfile curdir devnull rootdir
          tmpdir updir no_upwards case_tolerant file_name_is_absolute path
          splitpath splitdir catpath abs2rel rel2abs)
    ],
    'File::Basename' => [
        qw(fileparse fileparse_set_fstype basename
          dirname)
    ],
    'File::Temp' => [
        qw(tempfile tempdir tmpnam tmpfile mkstemp mkstemps
          mkdtemp mktemp unlink0 safe_level)
    ],
    'File::Copy' => [qw(copy move cp mv rmscopy)],
    'PerlIO' =>
      [qw(:bytes :crlf :mmap :perlio :pop :raw :stdio :unix :utf8 :win32)],
);
App::perlzonji->add_trigger(
    'matches.add' => sub {
        my ($class, $word, $matches) = @_;
        while (my ($file, $words) = each our %found_in) {
            for (@$words) {
                push @$matches, $file if $_ eq $word;
            }
        }
    }
);
1;

=head1 SYNOPSIS

    # perlzonji elsif
    # (runs `perldoc perlsyn`)

=head1 DESCRIPTION

This plugin for L<App::perlzonji> knows where to find documentation for syntax
and built-in Perl concepts. It knows about things like

    elsif
    VERSION
    END
    OUTPUT_RECORD_SEPARATOR
    $^R
    PERL5OPT
    head3
    __DATA__
    :utf8

