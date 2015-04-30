use warnings;
use strict;
use ExtUtils::MakeMaker 6.48;
use File::Copy;

my $pm = 'lib/Encode/Detective.pm';
my @cxx_files = (<src/*.cpp>, "run-detector.cpp");
my @o_files = map {s/\.cpp/.o/; $_} @cxx_files;
my $repo = 'https://github.com/benkasminbullock/Encode-Detective';

# %args is the arguments for WriteMakefile. This is manipulated by
# various conditionals to work around whatever compilation problems
# occur, so the hash is not used directly as an argument to
# WriteMakefile.

my %args = (
    NAME => 'Encode::Detective',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    LICENSE => 'mozilla',
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    OBJECT => "Detective.o @o_files",
    INC => "-I include -I src",
    LIBS => ['-lstdc++'],
    MIN_PERL_VERSION => '5.008',
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
    EXE_FILES => [
        'script/edetect',
    ],
    clean => {
        FILES => "@o_files"
    },
);

# Compiler issues.

# This is a fix for
# http://www.cpantesters.org/cpan/report/a6e38de8-c240-11e1-8755-e63c2a028b78
# This is taken from a module called "ExtUtils::CppGuess".

if ($^O eq 'netbsd') {
    $args{dynamic_lib} = {
        OTHERLDFLAGS => ' -lgcc_s',
    },
}

WriteMakefile (%args);

exit;

# The following overrides the stupid default method of
# ExtUtils::MakeMaker, and allows compiling the files "src/*.cpp" and
# having the output files (the -o part below) stay in "src/", so
# "src/x.cpp" is compiled to "src/x.o".

package MY;

sub c_o
{
    # Override the rule of the superclass.
    my $inherited = shift->SUPER::c_o (@_);
    # This changes "x.cpp" into "-o x.o x.cpp".
    $inherited =~ s/(\$\*\.cpp)/-o \$*.o $1/;
    return $inherited;
}

