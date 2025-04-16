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
			{ 'name' => 'Margaret', status => 'deceased' }
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

cmp_deeply($foo,
	{
		'children' => [
                           { 'name' => 'Jeremy' },
                           { 'name' => 'Lorna' },
                           { 'name' => 'Anya' }
		 ], 'grandchildren' => [
			'Aimee',
			'Nathan',
			'Tommy',
			'Harry',
			'Emily',
			'Luke'
		], 'children_in_law' => [
			'Linda',
			'Michael',
			'Mark'
		], 'spouse' => [
			{ 'name' => 'Keith' }
		]
	}
);

diag(Data::Dumper->new([$foo])->Dump()) if($ENV{'TEST_VERBOSE'});

$str = <<'STR';
PETERS, Eric Jarvis - 81, Head of St. Margaret's Bay, passed away Monday, April 16, 2007, at home.  Born in Fredericton, N.B., he was a son of the late Rev. Ovid and Pearl (Boyd) Peters.  Eric retired from the Federal Department of Transportation as an Air Traffic Controller in 1982, moving to St. Margaret's Bay in 1985 and enjoyed the waters of the Bay, spending his time fishing, boating and swimming.  He was an avid barbershopper and most recently belonged to the Millstream Chorus in Bedford and also was a founding member of the Rail City Chorus in Moncton.  Surviving are his wife, Ruth; daughter, Anne (Malcolm) Maxwell and their son James, Prince George, BC; son, Boyd R. (Deborah) and their children Brian, Meredith and Patricia, Fredericton, NB, and brother, Ralph N. (Lorna), Saint John, NB. He was predeceased by his sister, Phyllis Huestis.  Funeral service will be held 11 a.m.  Thursday, April 19, in St. Luke's United Church, Tantallon, Rev. KevinLittle officiating.  A family committal service will be held a later date.  In lieu of flowers, donations can be made to St. Luke's United Church, Tantallon or Alzheimer Society of Nova Scotia; PETERS, ERIC J. - At his residence, after a long illness on Monday April 16th, 2007, Eric J. Peters, loving husband of Ruth Anne Shirley Peters, passed away.  A funeral service at St. Luke's United Church, Tantallon NS, on Thursday, April 19th, 2007, at 11am.  Leaving to mourn, two children, Anne and Boyd, grandchildren, and one brother Ralph of Saint John, NB).  He was the youngest of 3 children of Ovid Peters, a minister of the methodist church, and Pearl Boyd.  Eric worked as an air traffic controller.  He was born in Fredericton, York, New Brunswick on Jul 19, 1925 and married Ruth Howland, a registered nurse, (with whom he had 3 surviving children: Boyd R, Anne and James) on Aug 6, 1955 at Baptish Church, Main Street, Saint John, New Brunswick.
STR

$foo = extract_family_info($str);

# TODO
if(0) {
	diag(Data::Dumper->new([$foo])->Dump());
	$foo = parse_obituary($str);
	diag(Data::Dumper->new([$foo])->Dump());
	$foo = parse_obituary2($str);
	diag(Data::Dumper->new([$foo])->Dump());
}

done_testing();
