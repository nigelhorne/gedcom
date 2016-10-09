gedcal
======

Print today's family anniversaries.

Given your family tree as a gedcom, gedcal will tell you whose birthday it is
and who died on this day.
Although primarily a tool for genealogy,
the -l flag tells gedcal to print matches for family members that are still
alive.

The -d flag will give you a short biography of each person.

Try adding this to your crontab,
it will give you a daily e-mail of your relative's birthdays and the
anniversaries of their death along with information about their life.

    3 5 * * * gedcal -dl gedcom-file.ged

or

    20 5 * * * gedcal -dth 'Your Full Name' gedcom-file.ged

Gedcal also includes rudimentary santity checking of your Gedcom file.  You can
enable this mode with -w, which will print warnings of anything it finds.  It's
a sort of lint for Gedcom files.

For example:

    gedcal -dawl gedcom-file.ged > /dev/null

You can create a month-to-a-page genealogical calendar of your ancestors:

    for i in 1 2 3 4 5 6 7 8 9 10 11 12
    do
        gedcal -dwlHm $i -y 2016 gedcom-file.ged > $i.html
    done

The options are:

    -a: all days otherwise just today
    -b: only print birthdays
    -c: Give citations on detailed listing
    -d: show the detailed lifetime information about the person
    -D: only print anniversaries of deaths
    -f: treat warnings as fatals, implies -w
    -H: Print an HTML calendar of this month
    -h: set the home person - useful for calculating relationships with -d
    -m: month for -H calendar
    -l: include living people
    -L: include ged2site hyperlinks with -H
    -p: print the biography of the given person
    -t: print tomorrow's information, don't use with -a
    -v: verbose - for debugging
    -w: print warning about inconsistent data - a sort of lint for Gedcom files
    -y: year for -H calendar
