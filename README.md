[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://x.com/intent/tweet?text=A+general+purpose+utility+for+gedcom+files+#genealogy&url=https://github.com/nigelhorne/gedcom&via=nigelhorne)

# Gedcom Utility

`Gedcom` is a powerful utility for managing and analyzing Gedcom genealogy files.
It offers a variety of tools for exploring family data,
identifying errors and presenting information in useful formats.

## Key Features

### Family Anniversaries

* Identify today's birthdays and death anniversaries from your family tree.

* Use the -l flag to include living relatives.

* The -d flag provides detailed biographies.

#### Autmate with Cron

Receive a daily e-mail:

    3 5 * * * gedcom -dl gedcom-file.ged

or

    22 5 * * * gedcom -dth 'Your Full Name' gedcom-file.ged

### Gedcom Validation

Identify and correct issues like:

* Missing or inconsistent data

* Duplicate entries

* Incorrect date formats

For example:

    gedcom -dAwWl gedcom-file.ged > /dev/null

To categorised errors:

    gedcom -dAwWl gedcom-file.ged > /dev/null 2> /tmp/errs
    sort -t: -k2 /tmp/errs

### Genealogy Calendar

Create month-to-page calendars for your family:

    for i in {1..12}; do
        gedcom -dwHm $i -y $(date +%Y) gedcom-file.ged > $i.html
    done

To filter calendars by surname:

    for i in 1 2 3 4 5 6 7 8 9 10 11 12
    do
        gedcom -dwHlm $i -y $(date +%Y) -h 'John Smith' -s gedcom-file.ged > $i.html
    done

Create an ICS file to import to Google Calendar:

    gedcom -i /tmp/ics.ics gedcom-file.ged

### Google Maps Integration

Generate CSV files for mapping ancestor locations:

    gedcom -xsh Smith gedcom-file-ged > smith.csv

* Upload the CSV file to Google Drive
* Visit [Google Maps](https://google.com/maps),
on the 3 horizontal lines choose "your places" ("Vos adresses"), then "maps" ("Cartes")
* Click "create map", choose "import" and upload your file,
choose "Location" as the position column and "People" as the title column

You may see that several rows can't be seen in the map,
this is an opportunity to find locations in your map that are incorrect.

### Family History Book

Create a PDF genealogy book for special occasions:

    # Note that this will only print people related to your father, even if you give -a
    # yum install gd-devel ImageMagick-devel
    gedcom -B family-history.pdf -dh "Your Father's Full Name" gedcom-file.ged

For a surname-specific book:

    gedcom -GB smith.pdf -dsh 'John Smith' gedcom-file.ged

## Environment Variables

`Gedcom` honours the following environment variables for improved compatibility:

* BOOTSTRAP - Attempt to install the modules you need
* BMAP_KEY - Bing (virtualearth.net) API Key
* GEONAMES_USER - geonames.org registered username
* GMAP_KEY/GMAP_GEOCODING_KEY - Google Places (maps.googleapis.com) API Key
* LANG - some handling of en_GB and en_US translating between then, fr_FR is a work in progress
* OPENADDR_HOME - directory of data from http -//results.openaddresses.io/
* REDIS_SERVER - ip:port pair of where to cache geo-coding data
* OPENAI_KEY - experimental: use the key from openai.com to enhance the text

## Runtime Options

`Gedcom` comes with various options that let you customize how your family tree website is generated.
Here’s what each option does:

### Command-Line Flags

| Flag | Description |
| ---- | ----------- |
| -a | all days otherwise just today |
| -A | print everyone, in alphabetical order |
| -b | only print birthdays |
| -B | create a genealogy book |
| -c | give citations on detailed listing |
| -C | print birth dates of children |
| -d | show the detailed lifetime information about the person |
| -D | only print anniversaries of deaths |
| -e | external website to use for the -L option |
| -f | treat warnings as fatals, implies -w |
| -F | create a forefathers book |
| -G | print everyone, in generation order |
| -g | prints a GML of the locations |
| -H | Print an HTML calendar of this month |
| -h | set the home person - useful for calculating relationships with -d |
| -i | creates an ICS file |
| -l | include living people |
| -L | include ged2site hyperlinks with -H |
| -m | month for -H calendar |
| -M | produce a map of a place (currently only Kent is supported) as an animated gif of births and migration pattern into $surname.gif or all.gif |
| -O | print a list of occupations, useful for finding typos and inconsistencies |
| -p | print the biography of the given person |
| -P | print a list of places, useful for finding typos of inconsistencies |
| -r | print a list of residences, useful for finding typos and inconsistencies |
| -t | print tomorrow's information, don't use with -a |
| -s | only print entries matching the home person's surname |
| -S | create an SQLite database from a Gedcom |
| -v | verbose - for debugging |
| -w | print warning about inconsistent data - a sort of lint for Gedcom files |
| -W | don't colorize warning output |
| -x | prints a list of towns in a format suitable to import into a google map |
| -X | prints a CSV of information |
| -y | year for -H calendar, or -T to give a list of places for a specific year |

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
gedcom goes out of its way to support all of these,
such as different location and date formats.
If your data shows issues with this aim, let me know.

The story telling format is hard coded, it would be useful if it were configurable.

## Pre-Requisites

Gedcom relies on multiple **CPAN modules**.
If they are missing, the program will attempt to **install them automatically** when you run it for the first time **without any arguments**
and set the evironment variable BOOTSTRAP.


```
BOOTSTRAP=1 gedcom
```

However, this **may fail** with a "permission denied" error if:
- You are **not running as root** (which is the correct and safer way).
- You are **not using** tools like [local::lib](https://metacpan.org/pod/local::lib) or [Perlbrew](https://perlbrew.pl/).

### **Manual Installation (If Automatic Installation Fails)**
If the modules do not install automatically, you have three options:

1. **Use `local::lib`** (Recommended)
   - Set up `local::lib` by following [these instructions](https://metacpan.org/pod/local::lib).
   - Install missing modules manually with CPAN:
     ```
     cpan install Module::Name
     ```

2. **Use Perlbrew**
   - Install [Perlbrew](https://perlbrew.pl/) to manage your Perl environment.
   - Install modules within your Perlbrew-managed environment.

3. **Run Gedcom as Root** (Not Recommended)
   - You **can** run it as root, but this **is not advised** due to security risks.

### **Alternative Installation Method (Experimental)**
You can also try installing dependencies with:

```
cpan -i lazy && perl -Mlazy gedcom
```

**Note:** This method is **untested** and may not work.

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
