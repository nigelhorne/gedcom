gedcal
======

Print today's family anniversaries.

Given your family tree as a gedcom, gedcal will tell you whose birthday it is
and who died on this day.

Try adding this to your crontab:

	23 5 * * * gedcal -dl gedcom-file.ged

or

	23 5 * * * gedcal -dh 'Your Full Name' gedcom-file.ged
