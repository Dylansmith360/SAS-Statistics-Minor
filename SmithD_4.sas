/*Dylan Smith Assingment 4*/
/*I certify that the SAS code given is my original and exclusive work*/ 

/*1*/
/*noraml curve*/
Data Log;
%let B0 = 5;
%Let B1 = 2;
Do X = -10 to 10 by 0.1;
P1 = exp(&B0 + &B1*X);
P2 = 1+ P1;
p = p1/p2;
output;
End;
Run;
proc sgplot data=log;
series x=X y=p;
run;

/*1a*/
Data Log1;
%let B0 = 5;
%Let B1 = 1;
Do X = -10 to 10 by 0.1;
P1 = exp(&B0 + &B1*X);
P2 = 1+ P1;
p = p1/p2;
output;
End;
Run;
proc sgplot data=log1;
series x=X y=p;
run;

/*1b*/
Data Log2;
%let B0 = 8;
%Let B1 = 2;
Do X = -10 to 10 by 0.1;
P1 = exp(&B0 + &B1*X);
P2 = 1+ P1;
p = p1/p2;
output;
End;
Run;
proc sgplot data=log2;
series x=X y=p;
run;

/*1c*/
Data Log3;
%let B0 = 5;
%Let B1 = -2;
Do X = -10 to 10 by 0.1;
P1 = exp(&B0 + &B1*X);
P2 = 1+ P1;
p = p1/p2;
output;
End;
Run;
proc sgplot data=log3;
series x=X y=p;
run;

/*3*/
Data Cancer;
%let B0 = -2.086;
%Let B1 = .5117;
Do X = -10 to 10 by 0.1;
P1 = exp(&B0 + &B1*X);
P2 = 1+ P1;
p = p1/p2;
output;
End;
Run;
proc sgplot data=Cancer;
series x=X y=p;
run;

/*4*/
/*Imported an XLSX file*/
PROC IMPORT DATAFILE="/home/ds18de0/my_courses/Assignments/3064 Assignments/Titanic.xlsx"
OUT=Titanic
DBMS=XLSX
REPLACE;
RUN;
PROC PRINT DATA=Titanic; RUN;

/*4a*/
proc sgplot data=Titanic;
loess y=Survived x=Age / smooth=0.5;
run;

/*4b*/
proc logistic data=Titanic;
	model Survived (event='1') = Age/iplots clparm=wald;
run;



