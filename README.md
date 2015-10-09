gedcal
======

Print today's family anniversaries.

Given your family tree as a gedcom, gedcal will tell you whose birthday it is
and who died on this day.

Although primarily a tool for genealogy, the -l flag tells gedcal to print
matches for family members that are still alive.

Try adding this to your crontab:

    3 5 * * * gedcal -dl gedcom-file.ged

or

    3 5 * * * gedcal -dh 'Your Full Name' gedcom-file.ged

Gedcal also includes rudimentary santity checking of your Gedcom file.  You can
enable this mode with -w, which will print warnings of anything it finds.  It's
a sort of lint for gedcom files.

For example:

    gedcal -dawl gedcom-file.ged > /dev/null
