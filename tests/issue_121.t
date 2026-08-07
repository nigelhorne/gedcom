#!/usr/bin/env perl

# Regression test for CONC leading-space bug
# (https://github.com/nigelhorne/ged2site/issues/121).
#
# Gedcom::Item's parser strips the intentional leading space from CONC lines,
# fusing adjacent words.  The _gedcom_note_text() helper in ../gedcom
# works around this by re-inserting the space at junctions where neither
# side already has whitespace.

use strict;
use warnings;

use Test::Most;
use Gedcom;

# Inline copy of _gedcom_note_text() from ../gedcom — must stay in sync
# with the implementation there.
sub _gedcom_note_text {
	my ($record) = @_;

	my $text = $record->{value} // '';
	$text =~ s/[\r\n]+$//;

	for my $item (@{$record->_items()}) {
		my $v = $item->{value} // '';
		$v =~ s/[\r\n]+$//;
		if($item->{tag} eq 'CONT') {
			$text .= "\n$v";
		} elsif($item->{tag} eq 'CONC') {
			# Re-insert the word-boundary space the parser stripped.
			if(length($text) && $text !~ /\s$/ && length($v)) {
				$text .= ' ';
			}
			$text .= $v;
		}
	}

	return $text;
}

my $ged = Gedcom->new(gedcom_file => 'gedcoms/issue_121.ged', read_only => 1);
ok($ged, 'loaded issue_121.ged');

# The individual's NOTE record points to @X122@ via xref.
my $ind = $ged->get_individual('Benjamin Millard Hannah');
ok($ind, 'found Benjamin Millard Hannah');

my @note_recs = $ind->get_record('note');
ok(scalar(@note_recs), 'individual has a note record');

my $note = $note_recs[0];
my $xref  = $note->full_value();	# returns "@X122@" (the pointer)
my $linked = $ged->resolve_xref($xref);
ok($linked, "resolved xref $xref to a note record");

my $text = _gedcom_note_text($linked);
ok(length($text), 'note text is non-empty');

# Without the fix the CONC leading space is consumed by the parser's \s+
# and adjacent fragments are fused — e.g. "1923.Tragically".
unlike($text, qr/1923\.Tragically/,
	'CONC word boundary: sentences not fused after full stop');
like($text, qr/1923\.\s+Tragically/,
	'CONC word boundary: space preserved between sentences');

# A second CONC boundary: "thirty" is end of one line, " years" starts the next.
unlike($text, qr/thirtyyears/,
	'CONC word boundary: no fused words at second junction');
like($text, qr/thirty\s+years/,
	'CONC word boundary: space preserved at second junction');

diag("Note text:\n$text") if $ENV{'TEST_VERBOSE'};

done_testing();
