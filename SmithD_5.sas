/*Dylan Smith Assingment 5*/
/*I certify that the SAS code given is my original and exclusive work*/ 
PROC IMPORT DATAFILE="/home/ds18de0/my_courses/Assignments/3064 Assignments/Election08.xlsx"
OUT=Election08
DBMS=XLSX
REPLACE;
RUN;
PROC PRINT DATA=Election08;
RUN;
/*1*/
/*looking at separate regression models*/
proc logistic data=Election08;
model ObamaWin = Income;
run;
proc logistic data=Election08;
model ObamaWin = HS;
run;
proc logistic data=Election08;
model ObamaWin = BA;
run;
proc logistic data=Election08;
model ObamaWin = "Dem.Rep"n;
run;
/*2a*/
proc logistic data=Election08 descending;
model ObamaWin = Income;
run;
/*2b*/
proc logistic data=Election08 descending;
model ObamaWin (event='1')= Income/clparm=wald;
run;
/*2c*/
data NewElection08;
set Election08;
IncomeTh = (Income/1000);
run;
proc logistic data=NewElection08;
model ObamaWin = IncomeTh;
run;
/*2d*/
proc logistic data=NewElection08 descending;
model ObamaWin = IncomeTh;
run;
proc logistic data=NewElection08 descending;
model ObamaWin (event='1')= IncomeTh/clparm=wald;
run;
/*3a*/
/*Fixed variable ride.alc.driver by changing it to RideAlcDriver in excel to get rid of invalid character issue*/
PROC IMPORT DATAFILE="/home/ds18de0/my_courses/Assignments/3064 Assignments/YouthRisk2007.xlsx"
OUT=YouthRisk
DBMS=XLSX
REPLACE;
RUN;
PROC PRINT DATA=YouthRisk; RUN;
proc logistic data=YouthRisk;
model "ride.alc.driver"n = female;
run;
/*3b*/
proc logistic data=YouthRisk;
model "ride.alc.driver"n = DriverLicense;
run;
/*3c*/
proc logistic data=YouthRisk;
model "ride.alc.driver"n = smoke;
run;
/*4a&b*/
proc logistic data=Election08;
model ObamaWin = HS BA "Dem.Rep"n Income;
run;
/*4c*/
proc logistic data=Election08;
class state;
model ObamaWin = "dem.rep"n/ influence;
run;
proc print data=Election08;
run;
/*4d*/
proc reg data=Election08;
model ObamaWin = HS BA "Dem.Rep"n Income/selection=backward SLS=.1;
run;




















