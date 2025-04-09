#!/usr/bin/env perl

use lib '../bin';

require "../bin/extract";

use Data::Dumper;
use Test::Most;

my $str = 'Helen Mae (McBeath) Girvan, age 89 years passed away at the Kenneth E. Spencer Memorial Home on Friday December 12th, 2008.  Born in Peters Mills, Kent Co.  on April 9th, 1919 she was the daughter of the late Richmond and Lilly (Peters) McBeath, and the wife of the late Ian Stuart Girvan (1987).  An adherent of Gunningsville Baptist church, Helen was an organist in both the United and Presbyterian churches in Rexton where she also taught school on a local license.  Following her marriage she became a Sunday school teacher and was a Life Time member of the Hillsborough UCW and the Womens Institute.  Later in life she was involved as a volunteer at the Lakeview Salvation Army Nursing Home and was the membership chairman of the Salvation Army Home League.  She is survived by her children Gwen Steeves (Leslie) of Riverview, NB, Ian (Terry) Girvan of Surrey, BC, and Carol Girvan of Dartmouth, NS; grandchildren Stacey and Tara Steeves; as well as several nieces and nephews.  Besides her husband she is predeceased by her sisters Dorothy Knowles, and Audrey Little; and brothers Stanley and Harold McBeath.  By personal request there will be no visitation at the funeral home';

my $foo = extract_family_info($str);
cmp_deeply($foo,
	{
           'sisters' => [
                          {
                            'name' => 'Dorothy Knowles'
                          },
                          {
                            'name' => 'Audrey Little'
                          }
                        ],
           'grandchildren' => [
                                'Stacey',
                                'Tara Steeves'
                              ],
           'nieces_nephews' => [
                                 'several nieces and nephews'
                               ],
           'parents' => [
                          {
                            'name' => 'Richmond'
                          },
                          {
                            'name' => 'Lilly (Peters) McBeath'
                          }
                        ],
           'children' => [
                           {
                             'location' => 'Riverview, NB',
                             'spouse' => 'Leslie',
                             'name' => 'Gwen Steeves'
                           },
                           {
                             'location' => 'Surrey, BC',
                             'spouse' => 'Terry',
                             'name' => 'Ian Girvan'
                           },
                           {
                             'location' => 'Dartmouth, NS',
                             'name' => 'Carol Girvan'
                           }
                         ],
           'spouse' => [
                         {
                           'name' => 'Ian Stuart Girvan',
                           'death_year' => '1987'
                         }
                       ]
	}
);

diag(Data::Dumper->new([$foo])->Dump()) if($ENV{'TEST_VERBOSE'});

$str = 'William HirstADAMS                                                                                                             Formerly of Hale, Cheshire.                                                                                                                                                                                                                                                                                               Devoted husband to the late Margaret. Loving father of Alexandra and father-in-law to Colin.';

$foo = extract_family_info($str);

diag(Data::Dumper->new([$foo])->Dump()) if($ENV{'TEST_VERBOSE'});

cmp_deeply($foo,
	{
           'children' => [
                           {
                             'name' => 'Alexandra'
                           },
                           {
                             'name' => 'father-in-law to Colin'
                           }
                         ],
           'father_in_law' => [
                                {
                                  'name' => 'Colin'
                                }
                              ],
           'spouse' => [
                         {
                           'name' => 'Margaret'
                         }
                       ]
         }
);

done_testing();
