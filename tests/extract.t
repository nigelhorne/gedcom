#!/usr/bin/env perl

use lib '../bin';

require "../bin/extract";

use Data::Dumper;
use Test::Most;

my $str = <<'STR';
Helen Mae (McBeath) Girvan, age 89 years passed away at the Kenneth E. Spencer Memorial Home on Friday December 12th, 2008.
Born in Peters Mills, Kent Co.  on April 9th, 1919 she was the daughter of the late Richmond and Lilly (Peters) McBeath, and the wife of the late Ian Stuart Girvan (1987).
An adherent of Gunningsville Baptist church, Helen was an organist in both the United and Presbyterian churches in Rexton where she also taught school on a local license.
Following her marriage she became a Sunday school teacher and was a Life Time member of the Hillsborough UCW and the Womens Institute.
Later in life she was involved as a volunteer at the Lakeview Salvation Army Nursing Home and was the membership chairman of the Salvation Army Home League.
She is survived by her children Gwen Steeves (Leslie) of Riverview, NB, Ian (Terry) Girvan of Surrey, BC, and Carol Girvan of Dartmouth, NS; grandchildren Stacey and Tara Steeves; as well as several nieces and nephews.
Besides her husband she is predeceased by her sisters Dorothy Knowles, and Audrey Little; and brothers Stanley and Harold McBeath.
By personal request there will be no visitation at the funeral home
STR

my $foo = extract_family_info($str);
cmp_deeply($foo,
	{
		'sisters' => [
			{ 'name' => 'Dorothy Knowles' },
			{ 'name' => 'Audrey Little' }
		], 'grandchildren' => [
			'Stacey',
			'Tara Steeves'
		], 'nieces_nephews' => [
			'several nieces and nephews'
		], 'parents' => [
			{ 'name' => 'Richmond' },
			{ 'name' => 'Lilly (Peters) McBeath' }
		], 'children' => [
			{
				'location' => 'Riverview, NB',
				'spouse' => 'Leslie',
				'name' => 'Gwen Steeves'
			}, {
				'location' => 'Surrey, BC',
				'spouse' => 'Terry',
				'name' => 'Ian Girvan'
			}, {
				'location' => 'Dartmouth, NS',
				'name' => 'Carol Girvan'
			}
		], 'spouse' => [
			{
				'name' => 'Ian Stuart Girvan',
				'death_year' => '1987'
			}
		]
	}
);

diag(Data::Dumper->new([$foo])->Dump()) if($ENV{'TEST_VERBOSE'});

$str = <<'STR';
William Hirst ADAMS
Formerly of Hale, Cheshire.
Devoted husband to the late Margaret. Loving father of Alexandra and father-in-law to Colin.
STR

$foo = extract_family_info($str);

diag(Data::Dumper->new([$foo])->Dump()) if($ENV{'TEST_VERBOSE'});

cmp_deeply($foo,
	{
		'children' => [
			{ 'name' => 'Alexandra' },
		], 'children_in_law' => [
			{ 'name' => 'Colin' }
		], 'spouse' => [
			{ 'name' => 'Margaret' }
		]
	}
);

$str = <<'STR';
Hilary AnnGALLAND
Hilary Ann Galland passed away peacefully at the Royal Derby, Ward 408 on Sunday 9th March 2025, age 79, after a short illness.

Beloved wife of Keith, loving mum to Jeremy, Lorna and Anya and devoted Grandma to Aimee, Nathan, Tommy, Harry, Emily and Luke and loved Mother-in-law to Linda, Michael and Mark. Hilary will be dearly missed by all who knew and loved her.

A funeral service will take place on Friday 28th March 2025 at 1.30pm at Bretby Crematorium and family and friends are warmly invited to join us in celebrating Hilary's life.

The family kindly requests family flowers only, donations made in Hilary's memory can be sent to the British Heart Foundation. Fellows Funeral Directors Limited
156 Station Road, Mickleover
Derby, Derbyshire, DE3 9FL
01332 511119
STR

$foo = extract_family_info($str);

# diag(Data::Dumper->new([$foo])->Dump()) if($ENV{'TEST_VERBOSE'});
diag(Data::Dumper->new([$foo])->Dump());

done_testing();
