/*I certify that the SAS code given is our original and exclusive work*/

/*Part C Data Exploration*/

/** FOR CSV Files uploaded from Unix/MacOS **/

FILENAME CSV "/home/u42911087/Tyler Rose Work 2/Data/Teams (project A).csv" TERMSTR=LF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE="/home/u42911087/Tyler Rose Work 2/Data/Teams (project A).csv"
		    OUT=ProjectA
		    DBMS=CSV
		    REPLACE;
RUN;

FILENAME CSV;

/*BB2 = Baseball 2*/

Data BB2;
set projecta;
WL= w/l;
AVG= H/AB;
keep WL R AVG ERA FP Name YearID;
run;

proc print data = BB2(obs=20);
run;

/*Setting years to 2018 and 2019 in BB3*/

Data BB3;
set BB2;
year= yearid; 
if yearid > 2017; 
drop yearid;
run;

/*checking to see if it worked*/ 

proc print data = BB3;
run;

/*SGSCATTER Plot*/

proc sgscatter data=BB3;
title "Win/Loss Ratio data";
matrix WL R AVG ERA FP ;
run;

/*Interpret R^2*/
/*Residual Analysis and Transformations*/
/*Variable selection method*/
/*Outliers/Leverage*/

proc reg data=BB3;
model WL = R AVG ERA FP/cli clm;
run;

/*suggested a trans of .25*/

proc transreg data=BB3;
model boxcox(WL) = identity(R AVG ERA FP);
run;

data BBTrans;
set BB3;
WL4 = WL**(1/4);
R4 = R**(1/4);
AVG4 = AVG**(1/4);
ERA4 = ERA**(1/4);
FP4 = FP**(1/4);
run;

proc reg data=BBTrans;
model WL4 = R4 AVG4 ERA4 FP4/cli clm;
run;

/*Multicolinearity*/

proc reg data=BB3;
model WL = R AVG ERA FP/vif;
run;

/*New observation (Hidden Y Trick to test new values)*/
/*Plug in for the corresponding values to test hypothticals*/

data new;
input R ERA FP WL AVG;
datalines;
700 1.5 .70 . 0.300 
;
run;

data BBCombo;
set new BB3;
run;

proc reg data=BBCombo;
model WL = R AVG ERA FP/cli clm;
id R AVG ERA FP;
run;

/*-----------ANOVA-------------*/
/*Year is our categorical*/

proc glm data=BB3 plots=diagnostics;
class Year name;
model WL = Year name/ss3;
run;

/*Tukey*/

proc glm data=BB3 plots=diagnostics;
class Year name;
model WL = Year name/ss3;
means Year name/tukey lines cldiff;
run;


/*--------------ANOVA Transformation----------------*/

proc transreg data=BB3;
model boxcox(WL) = Class(year);
run;

data BBTrans2;
set BB3;
YearNew = Year**(1/4);
WLNew = WL**(1/4);
RNew = R**(1/4);
AVGNew = AVG**(1/4);
ERANew = ERA**(1/4);
FPNew = FP**(1/4);
run;

proc reg data=BBTrans2;
model WLNew = YearNew RNew AVGNew ERANew FPNew/cli clm;
run;

/*-------------ANCOVA----------------*/

proc glm data=BB3 plots=diagnostics;
	class Year (ref='2019');
	model WL = Year AVG R ERA FP /ss3 solution;
run;








