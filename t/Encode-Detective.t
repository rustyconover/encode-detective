use strict;
use warnings;
use Test::More tests => 11;
use FindBin;

use Encode::Detective 'detect';

is (detect("\x82\xb7\x82\xb2\x82\xa2\x82\xcc\x82\xdd\x82\xc2"), "Shift_JIS",
   "Detect shift JIS");
is (detect("j\xc2\x92aimerais"), "UTF-8", 'detect UTF-8');

# Regression tests to make sure it still works after changes, only
# needed for people altering the module's source codes

SKIP: {
    my $is_author = -d "$FindBin::Bin/../.git";
    my $reason = 'regression test';
    skip $reason, 9 unless $is_author;
    note ("Regression tests");
    read_file ('kanjidic', 'EUC-JP');
    read_file ('big5-sample', 'Big5');
    read_file ('fortune.6', 'EUC-KR');
    read_file ('tocru.htm', 'windows-1251');
    read_file ('hebrew-8088', 'windows-1255');
    read_file ('greek.html', 'ISO-8859-7');
    read_file ('balisem.htm', 'windows-1252');
    read_file ('surfanonyme1.htm', 'windows-1252');
    TODO: {
        local $TODO = 'does not detect this one';
        read_file ('std620.htm', 'TIS-620');
    }
}
exit;

sub read_file
{
    my ($file_name, $should_be_enc) = @_;
    my $fqf = "$FindBin::Bin/samples/$file_name";
    open my $input, "<:raw", $fqf
        or die "Error opening $fqf: $!";
    my $text = '';
    while (<$input>) {
        $text .= $_;
    }
    close $input or die $!;
    my $enc = detect ($text);
    is ($enc, $should_be_enc, "Detect $should_be_enc in $file_name");
}
