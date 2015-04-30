package Encode::Detective;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/detect/;

use strict;
use warnings;

use XSLoader;
our $VERSION = 0.06;
XSLoader::load 'Encode::Detective', $VERSION;

1;

__END__

=encoding UTF-8

=head1 NAME

Encode::Detective - guess the encoding of text

=head1 SYNOPSIS

  use Encode::Detective 'detect';
  my $encoding = detect ($data);
  # Now $encoding contains a guess of the encoding of $data.

=head1 DESCRIPTION

This module guesses the character set of input data. It is similar to
L<Encode::Guess>, but does not require a list of expected encodings.

=head1 FUNCTIONS

=head2 detect

    my $encoding = detect ($text);

Given some bytes of text, C<$text>, this guesses what encoding they
are in. If the encoding cannot be guessed, or if it seems to be ASCII,
the undefined value is returned. C<$encoding> can then be passed to
the C<decode> method of L<Encode>:

    use Encode 'decode';
    my $encoding = detect ($text);
    if ($encoding) {
        $text = decode ($encoding, $text);
    }

=head1 DETECTED AND UNDETECTED ENCODINGS

=head2 Detected encodings

The following encodings are detected:

=over

=item UTF-8

Unicode.

=item EUC-JP

Japanese Extended Unix Code.

=item Big5

Chinese encoding.

=item Shift_JIS

Japanese Microsoft encoding.

=item EUC-KR

Korean Extended Unix Code.

=item EUC-TW

Taiwanese encoding.

=item windows-1251

Cyrillic encoding.

=item windows-1255

Hebrew encoding.

=item windows-1252

French/European encoding.

=back

=head2 Undetected encodings

The following character sets are not detected:

=over

=item mac roman

A MacIntosh encoding incorporating some European letters.

=item CP932

An extension of Shift-JIS, more common in practice than actual
Shift-JIS. This has code points for things like ① (circled one) which
don't exist in Shift-JIS.

=item TIS-620

A Thai encoding.

=back

=head1 BUGS

=over

=item Lacks regression tests

The module needs many, many more regression tests before any work can
be done on altering the underlying algorithms. The existing library
already has checks for some of the encodings which are not
detected. These are currently switched off for some reason, maybe
because it was not possible to unambiguously detect them. Without very
solid regression tests, no patches can be applied to the detection
code, since it will not be clear whether or not the existing encoding
detection for every possible encoding is damaged by the
patches. 

Please send example files containing encodings. Either fork the
repository and add files in the directory F<t/samples>, or send them
to the module maintainer at <bkb@cpan.org>.

=item TIS-620

TIS-620 does not seem to be detected.

=item Documentation of detection

The documentation of detected encodings above is not complete.

=back

=head1 HISTORY

Encode::Detective is based on the C++ library for character set
detection in the Firefox web browser. This library used to be
available as a standalone library. Unfortunately, as of 2012, the
Firefox code has been integrated into the browser code, and it cannot
be used as a standalone library, so this has become a fork of the
original Mozilla code.

Encode::Detective is a fork of L<Encode::Detect>. It removes almost
all of the interface of Encode::Detect except the single function
L</detect>. This fork is intended to improve the compilation of the
module on various systems. It was released to CPAN to access CPAN
testers.

=head1 SEE ALSO

=head2 edetect

The L<edetect> standalone script installed with Encode::Detective can
guess the encodings of files.

=head2 Online demonstration

L<LeMoDa.net offers an online detection
service|http://www.lemoda.net/tools/encode-detective/>, which also
checks the HTTP response header and the meta tag (the tag containing
C<charset=>) of the page.

=head2 Encode::Guess

L<Encode::Guess> is a Perl module which does something similar to
Encode::Detective. It is slightly different in that it requires a list
of candidate encodings.

=head2 Encode::Detect

L<Encode::Detect> is the original version of this module. Whereas this
module offers the single interface, L</detect>, Encode::Detect has
facilities to create an object, make multiple reads, and detect end of
file.

=head2 IO::HTML

L<IO::HTML> uses byte order mark inspection and inspection of HTML to
detect encodings of web pages (see
L<http://en.wikipedia.org/wiki/Byte_order_mark>).

=head2 C++ and Perl XS

There is a short description of the method used in this module to
combine C++ and Perl XS at
L<http://www.lemoda.net/perl/xs-and-cplusplus/>.

=head1 AUTHORS

Encode::Detective is based on L<Encode::Detect> by John Gardiner Myers
<jgmyers@proofpoint.com>. It was forked by Ben Bullock <bkb@cpan.org>.

=head1 LICENCE

This Perl module may be used, copied, modified and redistributed under
the terms of the Mozilla Public License version 1.1, the GNU General
Public License, or the LGPL.

