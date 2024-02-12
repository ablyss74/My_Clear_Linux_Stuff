Oringally the C code was written by someone else for "fortune", a command line program that randomly reads fortunes from a file.
<br><br>
I modified it to be more user friendly:<br>
&nbsp;&nbsp;Changing the fortune.dat data file to poems.txt which makes it easier to edit with a GUI app,<br>
&nbsp;&nbsp;Also changed the data separator to use a percent sign.<br>
&nbsp;&nbsp;Also changed path location to a current working path.<br>

<br><br>
To compile just enter the directory and type `gcc ./poems.c -o poems`
