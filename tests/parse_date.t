#!/usr/bin/env perl

# Tests for parse_date() in ../gedcom.
#
# parse_date() lives inside the monolithic script, not a module.  Rather than
# duplicating the code, we extract the sub definition at test time by scanning
# the script source and balancing braces, then eval it into this namespace.
# This means we test the real implementation and will catch regressions there.

use strict;
use warnings;

use Test::Most;
use Params::Get;

# Stubs for functions that parse_date calls only for side-effects or in the
# fatal path.  complain() issues non-fatal warnings; colored() is only reached
# when parse_date is about to die, which none of these test inputs trigger.
sub complain { }
sub colored  { $_[0] }	# return the text, ignore the colour argument

# Extract and compile parse_date() from the script source.
{
	open my $fh, '<', '../gedcom'
		or die "Cannot open ../gedcom: $!\n";

	my ($in_sub, $depth, $src) = (0, 0, '');
	while(my $line = <$fh>) {
		$in_sub = 1 if !$in_sub && $line =~ /^sub parse_date\b/;
		if($in_sub) {
			$src   .= $line;
			$depth += () = $line =~ /\{/g;
			$depth -= () = $line =~ /\}/g;
			last if $depth == 0;
		}
	}
	die "Could not extract parse_date from ../gedcom\n" unless $src;
	eval $src;	## no critic (ProhibitStringyEval)
	die $@ if $@;
}

# ---- new feature: slash-separated month ranges ----------------------------

is(parse_date({ date => 'Apr/May/Jun 1959' }),
	'bet 1 Apr 1959 and 30 Jun 1959',
	'quarter span Apr/May/Jun');

is(parse_date({ date => 'Jan/Feb 1900' }),
	'bet 1 Jan 1900 and 28 Feb 1900',
	'span ending in Feb — 1900 is not a leap year');

is(parse_date({ date => 'Jan/Feb 2000' }),
	'bet 1 Jan 2000 and 29 Feb 2000',
	'span ending in Feb — 2000 IS a leap year');

is(parse_date({ date => 'Jan/Feb 1900' }),
	'bet 1 Jan 1900 and 28 Feb 1900',
	'span ending in Feb — 1900 divisible by 100 but not 400, so not leap');

is(parse_date({ date => 'Oct/Nov/Dec 1843' }),
	'bet 1 Oct 1843 and 31 Dec 1843',
	'quarter span Oct/Nov/Dec');

is(parse_date({ date => 'Nov/Dec 1799' }),
	'bet 1 Nov 1799 and 31 Dec 1799',
	'two-month span ending in 31-day month');

is(parse_date({ date => 'APR/MAY/JUN 1959' }),
	'bet 1 Apr 1959 and 30 Jun 1959',
	'slash span normalises all-caps month names');

# ---- aft / bef / abt prefix handling -------------------------------------

is(parse_date({ date => 'aft 1 Jan 1900' }),
	'aft 1 Jan 1900',
	'aft prefix preserved');

is(parse_date({ date => 'bef Dec 1925' }),
	'bef Dec 1925',
	'bef prefix preserved');

is(parse_date({ date => 'abt 1959' }),
	'abt 1959',
	'abt prefix preserved');

is(parse_date({ date => 'about 1959' }),
	'abt 1959',
	'"about" prefix normalised to "abt"');

is(parse_date({ date => 'about Feb 1877' }),
	'abt Feb 1877',
	'"about Month Year" normalised');

is(parse_date({ date => 'About:1907-00-00' }),
	'abt 1907',
	'About:YYYY-00-00 format');

is(parse_date({ date => 'After 1959' }),
	'aft 1959',
	'"After" normalised to "aft" (complaint suppressed in test)');

is(parse_date({ date => 'Before 1959' }),
	'bef 1959',
	'"Before" normalised to "bef" (complaint suppressed in test)');

# ---- passthrough ---------------------------------------------------------

is(parse_date({ date => '4 Jul 1776' }),
	'4 Jul 1776',
	'day-month-year passes through unchanged');

is(parse_date({ date => 'Apr 1959' }),
	'Apr 1959',
	'month-year passes through unchanged');

is(parse_date({ date => '1959' }),
	'1959',
	'year-only passes through unchanged');

# ---- normalisation -------------------------------------------------------

is(parse_date({ date => '@#DJULIAN@ 4 Jul 1776' }),
	'4 Jul 1776',
	'Julian calendar escape stripped');

is(parse_date({ date => '4 October 1776' }),
	'4 Oct 1776',
	'long month name truncated to 3 letters');

is(parse_date({ date => 'from 1 Jan 1900 to 31 Dec 1900' }),
	'bet 1 Jan 1900 and 31 Dec 1900',
	'"from … to …" converted to GEDCOM bet range');

# ---- undefined / empty ---------------------------------------------------

is(parse_date({ date => 'unknown' }), undef, '"unknown" returns undef');
is(parse_date({ date => '' }),        undef, 'empty string returns undef');

done_testing();
