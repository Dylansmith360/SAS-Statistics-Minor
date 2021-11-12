/* Dylan Smith Case Study*/
/*I certify that the SAS code given is my original and exclusive work*/ 

/*1*/
proc import datafile  =  '/home/ds18de0/my_courses/Assignments/3064 Assignments/AirFoil.xlsx'
out  =  AirFoil
dbms  =  xlsx
replace;
run;
proc print data=AirFoil (obs=20);
run;

/*two different iterations were run for proc sgscatter to look for individual patterns and group patterns*/
Proc SgScatter data=AirFoil;
matrix Freq Angle Length Velocity Displace/ group=sound;
run;
Proc SgScatter data=AirFoil;
matrix _numeric_ / diagonal=(kernel histogram);
run;

Proc CORR data=AirFoil;
run;

/*2*/
proc reg data=AirFoil;
model Sound = Displace;
run;
/*2d*/
Data AirFoil2;
set AirFoil;
LogCal = log(Sound);
SqrtCal = sqrt(Sound);
InvCal = 1/Sound;
ISRCal = Sound**-.5;
run;

proc reg data=AirFoil2;
LogY: model LogCal = Displace;
SqrtY: model SqrtCal = Displace;
InvY: model InvCal = Displace;
ISRY: model ISRCal = Displace;
run;

proc transreg data=AirFoil2;
model boxcox(Sound)=identity(Displace);
run;
/*lambda =3 suggested*/
data AirFoil3;
set AirFoil;
yt = Sound**3;
run;
proc reg data=AirFoil3;
model yt = Displace/clm;
id Displace;

/*2e*/
proc transreg data=AirFoil;
model boxcox(Sound)=identity(Displace);
run;

Data AirFoilTrueSlope;
input Displace;
datalines;
0
;
run;

data AirFoil5;
set AirFoilTrueSlope AirFoil;
run;

proc reg data=AirFoil5;
model Sound = Displace/cli clm;
id Displace;
run;

/*2f*/
proc reg data=AirFoil;
model Sound = Displace/clb;
run;

proc surveyselect data=Airfoil out=boot
seed=1234 samprate=1
method=urs outhits rep=5000;
run;

proc reg data=boot outest=betas noprint;
model Sound = Displace;
by replicate;
run;                                           

proc sgplot data=betas;
histogram Displace;
density Displace/type=kernel;
run;

proc univariate data=betas noprint;
var Displace;
output out=BootCI pctlpts= 2.5 97.5 pctlpre= Conf_Limit_;
run;

proc print data=BootCI;
run;

/*2g*/
proc reg data=AirFoil;
model Sound = Displace;
run;

/*2h*/
Data AirFoilHiddenY;
input Sound Displace;
datalines;
. .028
;
run;

Data AirFoil4;
Set AirFoilHiddenY AirFoil;
run;

proc reg data=AirFoil4;
model Sound = Displace/cli clm;
run;

/*3a*/
proc reg data=AirFoil;
model Sound = Freq Length Velocity Displace Angle/VIF;
run;

/*3b*/
proc reg data=AirFoil;
model Sound = Freq Length Velocity Displace Angle/selection=forward;
model Sound = Freq Length Velocity Displace Angle/selection=backward;
model Sound = Freq Length Velocity Displace Angle/selection=stepwise;
run;

/*3c*/
proc reg data=AirFoil;
model Sound = Freq Length Velocity Displace Angle;
run;

proc reg data=AirFoil;
model Sound = Freq Length Velocity Displace Angle;
test Velocity=0,Displace=0,Angle=0;
run;

/*3d*/
proc reg data=AirFoil plots(unpack)=boxplot;
model Sound = Freq Length Velocity Displace Angle;
run;

proc reg data=AirFoil plots(unpack)=boxplot;
model Sound = Freq Length Velocity Displace Angle/clm cli;
run;

/*3e*/
proc print data= AirFoil;
Run;

Data omit;
Set AirFoil;
if freq=20000 then delete;
Run;

proc reg data=omit plots(unpack)=boxplot;
model Sound = Freq Length Velocity Displace Angle;
run;

proc reg data=omit;
model Sound = Freq Length Velocity Displace Angle/selection=forward;
model Sound = Freq Length Velocity Displace Angle/selection=backward;
model Sound = Freq Length Velocity Displace Angle/selection=stepwise;
run;

