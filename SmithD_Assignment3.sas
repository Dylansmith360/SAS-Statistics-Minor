/* Dylan Smith Assingment 3*/
/*I certify that the SAS code given is my original and exclusive work*/
ods text='Part 1a';
Data SNL5_Timers;
Length name $ 18;
input @1 Name $ & @25 Appearances @41 First :date9. @64 Fifth :mmddyy10.;
format first fifth :mmddyy8.;
datalines;
Buck Henry              10              17-Jan-76              11/19/1977
Steve Martin            15              23-Oct-76              4/22/1978
Elliott Gould            6              10-Jan-76              2/16/1980
Chevy Chase              8              18-Feb-78              12/6/1986
Candice Bergen           5               8-Nov-75              5/19/1990
Tom Hanks                9              14-Dec-85              12/8/1990
Danny DeVito             6              15-May-82              1/9/1993
John Goodman            13               2-Dec-89              5/7/1994
Alec Baldwin            17              21-Apr-90              12/10/1994
Bill Murray              5               7-Mar-81              2/20/1999
Christopher Walken       7              20-Jan-90              5/19/2001
Drew Barrymore           6              20-Nov-82              2/3/2007
Justin Timberlake        5              11-Oct-03              3/9/2013
Ben Affleck              5              19-Feb-00              5/18/2013
Tina Fey                 6              23-Feb-08              12/19/2015
Scarlett Johansson       5              14-Jan-06              3/11/2017
Melissa McCarthy         5               1-Oct-11              5/13/2017
Dwayne Johnson           5              18-Mar-00              5/20/2017
Jonah Hill               5              15-Mar-08              11/3/2018
;
run;
proc print data=SNL5_Timers;
run;
ods text= 'Part 1b';
proc sort data=snl5_timers;
by descending appearances;
run;
proc print data=Snl5_timers;
var name fifth;
format fifth :worddate12.;
run;
ods text= 'Part 1c(1&2)';
data Snl5_timers1;
 set Snl5_timers;
 days = fifth - first;
 years = floor(days/365.25);
 overflow=ceil(mod(days, 365.25));
run;
proc sort data=Snl5_timers1;
by days;
run;
Proc print data=snl5_timers1; var name years overflow;
run;



ods text= 'Part 2';
data bat;
input brand $ hours @@;
datalines;
A  44  A  54  A  54
A  64  A  64  A  44
A  34  A  24  A  24
A  44  A  34  A  54
A  34  A  34  A  54
A  54  A  54  B  66
B  66  B  51  B  36
B  66  B  81  B  36
B  81  B  66  B  36
B  96  B  66  B  51
B  96  B  66  B  51
B  36  C  44  C  37
C  51  C  44  C  51
C  51  C  44  C  51
C  37  C  37  C  30
C  37  C  30  C  65
C  51  C  37  C  58
D  43  D  45  D  55
D  36  D  45  D  33
D  44  D  36  D  45
D  37  D  34  D  43
D  43  D  63  D  47
D  45  D  35    
;
run;
proc print data=bat (firstobs=15 obs=40);
run;
proc sgplot data=bat;
vbar brand/response=hours fillattrs= (color=steel) dataskin=gloss barwidth=.4;
run;
Proc boxplot data=bat;
plot hours*brand/boxstyle=schematic;
title 'Relation between brand of cellphone and its respective battery life';
run;
title;
ods text='I would purchase brand B based on its average better life span when compared to the other brands';




ods text='Part 3';
data Airlines;
length season $ 6;
input season $ Delta Icelandir BritishAirways;
datalines;
Summer   1675     1473     1370
Summer   1435     1206     1252
Summer   1295     1273     1580
Summer   1355     1109     2575
Summer   1586     1078     2275
Fall      969     1050     1287
Fall     1128      970     1460
Fall     1027     1017     1047
Fall     1157      997     1274
Fall     1230      991     1195
;
run;
proc print data=Airlines;
run;

proc sgplot data=airlines; 
vline season/response=delta stat=mean
lineattrs=(color=red)
markers markerattrs=(color=blue symbol=squarefilled);
vline season/response=Icelandir stat=mean
lineattrs=(color=brown pattern=dot)
markers markerattrs=(color=orange symbol=triangle);
vline season/response=BritishAirways stat=mean
lineattrs=(color=khaki pattern=dash)
markers markerattrs=(color=silver symbol=diamondfilled);
run;
ods text='IcelandAir has the best pricing all year round with Delta coming in at second and Britishairways coming in at the most expensive';