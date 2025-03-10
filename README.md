[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://x.com/intent/tweet?text=A+general+purpose+utility+for+gedcom+files+#genealogy&url=https://github.com/nigelhorne/gedcom&via=nigelhorne)

# gedcom

A general purpose utility for gedcom files.
This program does a lot of different things with a gedcom file.

## Print today's family anniversaries

Given your family tree as a gedcom, gedcom will tell you whose birthday it is
and who died on this day.
Although primarily a tool for genealogy,
the -l flag tells gedcom to include matches for family members that are still
alive.

The -d flag will give you a short biography of each person.

Try adding this to your crontab,
it will give you a daily e-mail of your relative's birthdays and the
anniversaries of their death along with information about their life.

    3 5 * * * gedcom -dl gedcom-file.ged

or

    22 5 * * * gedcom -dth 'Your Full Name' gedcom-file.ged

## Gedcom validation

Gedcom also includes sanity checking and validation of your Gedcom file, including missing,
impossible and inconsistent information allowing for greater error correction.
Date formats are standardized and duplicate people are detected.
You can enable this mode with -w, which will print warnings of anything it finds.
It's a sort of lint for Gedcom files.

For example:

    gedcom -dAwWl gedcom-file.ged > /dev/null

Adding the -c option will add the checking of missing citations.

To sort by error type:

    gedcom -dAwWl gedcom-file.ged > /dev/null 2> /tmp/errs
    sort -t: -k2 /tmp/errs

## Genealogy Calendar

You can create a month-to-a-page genealogical calendar of your ancestors:

    for i in 1 2 3 4 5 6 7 8 9 10 11 12
    do
        gedcom -dwHm $i -y $(date +%Y) gedcom-file.ged > $i.html
    done

To print a month-to-a-page calendar of all the Smiths in your tree as a present,
choose any Smith in your tree as a home person so that the -s option works:

    for i in 1 2 3 4 5 6 7 8 9 10 11 12
    do
        gedcom -dwHlm $i -y $(date +%Y) -h 'John Smith' -s gedcom-file.ged > $i.html
    done

Alternatively you can create an ICS file to import to Google Calendar:

    gedcom -i /tmp/ics.ics gedcom-file.ged

## Produce a Google Map

You can produce a map of locations of all Smiths in your tree with

    gedcom -xsh Smith gedcom-file-ged > smith.csv

* Upload the csv file to Google Drive
* Visit google.com/maps, on the 3 horizontal lines choose "your places" ("Vos adresses"), then "maps" ("Cartes")
* Click "create map", choose "import" and upload your file,
choose "Location" as the position column and "People" as the title column
* You may see that a number of rows can't be seen in the map,
this is an opportunity to find locations in your map that are incorrect

## Family History Book

You can create a genealogy book as a PDF of your family history and research to give to
your dad on father's day:

    # Note that this will only print people related to your father, even if you give -a
    # yum install gd-devel ImageMagick-devel
    gedcom -B family-history.pdf -dh "Your Father's Full Name" gedcom-file.ged

You can create a book of your family name based on the descendants of John Smith:

    gedcom -GB smith.pdf -dsh 'John Smith' gedcom-file.ged

If you enable the -w flag with the -B option, warnings will appear in red in the book.

## Environment Variables

For compatibility with other code, these environment variables are honoured:

    BMAP_KEY: Bing (virtualearth.net) API Key
    GEONAMES_USE: geonames.org registered username
    GMAP_KEY: Google Places (maps.googleapis.com) API Key
    LANG: some handling of en_GB and en_US translating between then, fr_FR is a work in progress
    OPENADDR_HOME: directory of data from http://results.openaddresses.io/
    REDIS_SERVER: ip:port pair of where to cache geo-coding data
    OPENAI_KEY: experimental: uses key from openai.com to enhance text

## Reference

The options are:

    -a: all days otherwise just today
    -A: print everyone, in alphabetical order
    -b: only print birthdays
    -B: create a genealogy book
    -c: give citations on detailed listing
    -C: print birth dates of children
    -d: show the detailed lifetime information about the person
    -D: only print anniversaries of deaths
    -e: external website to use for the -L option
    -f: treat warnings as fatals, implies -w
    -F: create a forefathers book
    -G: print everyone, in generation order
    -g: prints a GML of the locations
    -H: Print an HTML calendar of this month
    -h: set the home person - useful for calculating relationships with -d
    -i: creates an ICS file
    -l: include living people
    -L: include ged2site hyperlinks with -H
    -m: month for -H calendar
    -M: produce a map of a place (currently only Kent is supported) as
	an animated gif of births and migration pattern into $surname.gif or all.gif
    -O: print a list of occupations, useful for finding typos and inconsistencies
    -p: print the biography of the given person
    -P: print a list of places, useful for finding typos of inconsistencies
    -r: print a list of residences, useful for finding typos and inconsistencies
    -t: print tomorrow's information, don't use with -a
    -s: only print entries matching the home person's surname
    -S: create an SQLite database from a Gedcom
    -v: verbose - for debugging
    -w: print warning about inconsistent data - a sort of lint for Gedcom files
    -W: don't colorize warning output
    -x: prints a list of towns in a format suitable to import into a google map
    -X: prints a CSV of information
    -y: year for -H calendar, or -T to give a list of places for a specific year

## Running on Windows

* Firstly, if you're running Windows 10, install
[Ubuntu](https://ubuntu.com/tutorials/ubuntu-on-windows#1-overview)
or install Perl directly, either ActiveState or Strawberry should work fine.
I have also had success using Cygwin's Perl.

* Next follow the instructions at [local::lib](https://metacpan.org/pod/local::lib#The-bootstrapping-technique).

* Load in all the CPAN modules that gedcom uses.
If you're not sure, run gedcom with no arguments and the program will install its core modules to get started.

## Bugs

There will be numerous strange handling of Gedcoms since it's not that tightly
observed by websites.
If you see lumpy English text in the output, or just plain mistakes,
please e-mail me or add a bug report to github.com/nigelhorne/gedcom.

I've tested against a number of Gedcoms including the Torture Tests at
https://www.tamurajones.net/DownloadTortureTests.xhtml and gedcoms
from gedcomlibrary.com.

With the -T option, countries and counties can be optimized out.
That will be fixed.

Different people use different ways to format and enter information,
ged2site goes out of its way to support all of these,
such as different location and date formats.
If your data shows issues with this aim, let me know.

The story telling format is hard coded, it would be useful if it were configurable.

## Pre-Requisites

Gedcom uses many CPAN modules which it will try to install if they are not
on your system.
If it doesn't have the necessary privilege to install the modules it will
fail on starting up with "permission denied" errors.
This is most likely because you're not running as root
(which is of course how it should be)
and you're not using [local::lib](https://metacpan.org/pod/local::lib),
or [Perlbrew](https://perlbrew.pl/).

Running the program for the first time with no
arguments should install them,
of course that will fail if you don't have the privilege,
in which case you'll need to add them by hand.
To install by hand you'll either have to use local::lib or perlbrew.
Of course you could also run gedcom as root,
but I strongly advise you don't do that.

You can also try
```cpan -i lazy && perl -Mlazy gedcom```
though I've not tested that.

To use the -B option on FreeBSD you'll need to
"sudo pkg install pkgconf gdlib ImageMagick7;
cd /usr/local/lib;
sudo ln -s libMagick++-7.so libMagickCore-7.Q16HDRI.so"

To use the -M option on FreeBSD you'll need to
"sudo pkg install apngasm"

## Acknowledgements

So many Perl CPAN modules that if I list them all I'll miss one, but special
mention goes to the [Gedcom](http://search.cpan.org/~pjcj/Gedcom/) module.

## See Also

* [ged2site](https://github.com/nigelhorne/ged2site) - create a website from a Gedcom file
* [gedcmp](https://github.com/nigelhorne/gedcmp) - compare two Gedcoms
* [lib](https://github.com/nigelhorne/lib) - library of routines used by this package
* [The Perl-GEDCOM Mailing List](https://www.miskatonic.org/pg/) - dead mailing list, you can check the archives

## LICENSE AND COPYRIGHT

Copyright 2015-2025 Nigel Horne.

This program is released under the following licence: GPL for personal use on a single computer.
All other users (including Commercial, Charity, Educational, Government)
must apply in writing for a licence for use from Nigel Horne at
`<njh at nigelhorne.com>`.

## Support

Please report any bugs or feature requests to the author.
This module is provided as-is without any warranty.
