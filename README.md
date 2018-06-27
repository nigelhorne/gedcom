# gedcom

A general purpose utility for gedcom files.

## Print today's family anniversaries

Given your family tree as a gedcom, gedcom will tell you whose birthday it is
and who died on this day.
Although primarily a tool for genealogy,
the -l flag tells gedcom to print matches for family members that are still
alive.

The -d flag will give you a short biography of each person.

Try adding this to your crontab,
it will give you a daily e-mail of your relative's birthdays and the
anniversaries of their death along with information about their life.

    3 5 * * * gedcom -dl gedcom-file.ged

or

    20 5 * * * gedcom -dth 'Your Full Name' gedcom-file.ged

## Gedcom validation

Gedcom also includes rudimentary santity checking of your Gedcom file.
You can enable this mode with -w, which will print warnings of anything it finds.
It's a sort of lint for Gedcom files.

For example:

    gedcom -dawWl gedcom-file.ged > /dev/null

Adding the -c option will add the checking of missing citations.

To sort by error type

    gedcom -dawWl gedcom-file.ged > /dev/null | sort -t: -k2

## Genealogy Calendar

You can create a month-to-a-page genealogical calendar of your ancestors:

    for i in 1 2 3 4 5 6 7 8 9 10 11 12
    do
        gedcom -dwlHm $i -y 2018 gedcom-file.ged > $i.html
    done

## Family History Book

You can create a genealogy book as a PDF of your family history to give to
your dad on father's day:

    # Note that this will only print people related to your father, even if you give -a
    gedcom -B family-history.pdf -dh "Your Father's Full Name" gedcom-file.ged

You can create a book of your family name based on the descendents of John Smith:

    gedcom -GB smith.pdf -dsh 'John Smith' gedcom-file.ged

## Environment Variables

For compatibility with other code, these environment variables are honoured:

    BMAP_KEY: Bing (virtualearth.net) API Key
    GMAP_KEY: Google Places (maps.googleapis.com) API Key
    GEONAMES_USE: geonames.org registered username
    OPENADDR_HOME: directory of data from http://results.openaddresses.io/

## Reference

The options are:

    -a: all days otherwise just today
    -A: print everyone, in alphabetical order
    -b: only print birthdays
    -B: create a genealogy book
    -c: Give citations on detailed listing
    -C: Print birth dates of children
    -d: show the detailed lifetime information about the person
    -D: only print anniversaries of deaths
    -f: treat warnings as fatals, implies -w
    -G: print everyone, in generation order
    -H: Print an HTML calendar of this month
    -h: set the home person - useful for calculating relationships with -d
    -m: month for -H calendar
    -l: include living people
    -L: include ged2site hyperlinks with -H
    -p: print the biography of the given person
    -t: print tomorrow's information, don't use with -a
    -T: print a list of towns, useful for finding typos and inconsistencies
    -s: only print entries matching the home person's surname
    -v: verbose - for debugging
    -w: print warning about inconsistent data - a sort of lint for Gedcom files
    -W: don't colorize warning output
    -y: year for -H calendar

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

## Pre-Requisites

This program uses many CPAN modules. To install them all and run the program
via Carton:

    cpan -i Carton
    carton install
    carton exec ./gedcom [args]

## Acknowledgements

So many Perl CPAN modules that if I list them all I'll miss one, but special
mention goes to the [Gedcom](http://search.cpan.org/~pjcj/Gedcom/) module.

## See Also

* [ged2site](https://github.com/nigelhorne/ged2site) - create a website from a Gedcom file
* [gedcmp](https://github.com/nigelhorne/gedcmp) - compare two Gedcoms

## LICENSE AND COPYRIGHT

Copyright 2015-2018 Nigel Horne.

This program is released under the following licence: GPL for personal use on a single computer.
All other users (including Commercial, Charity, Educational, Government)
must apply in writing for a licence for use from Nigel Horne at
`<njh at nigelhorne.com>`.
