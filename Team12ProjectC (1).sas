/*Import data into SAS from Excel*/
filename EF16 '/home/jjw17e0/Data STA 3024/EconFreeClean.csv';
proc import datafile=EF16
out=EconFree16
dbms=csv
replace;
run;

filename IP '/home/jjw17e0/Data STA 3024/InternetPen1.csv';
proc import datafile=IP 
out=InternetPen
dbms=csv
replace;
run;

/*Sorting the data to be able to merge it*/
proc sort data=EconFree16;
by country;
run;

proc sort data=InternetPen;
by country;
run;

/*Merging the datasets into a new dataset*/
data EconFreeIP1;
merge EconFree16 InternetPen;
by country;
run;

/*Used If Missing() then delete to remove rows with missing values*/
data EconFreeIP2;
set econfreeip1;
If Missing(CountryID) then delete;
If Missing(Penetration) then delete;
run;

/*Converting GDP, Internet Penetration and Freedom Rank from categorical to numerical variables and removed Missing Values
to further clean up data*/
data econfreeip3;
set econfreeip2;
gdp=input(GDPBillions,dollar11.);
rename gdp=GDPBillion;
drop GDPBillions;
run;

data econfreeip4;
set econfreeip3;
IP=input(Penetration,percent6.);
drop penetration;
rename IP= Penetration;
if freedomrank = 'N/A' then delete;
run;

data econfreeip5;
set econfreeip4;
FR=input(freedomrank, best12.);
drop freedomrank;
rename fr = freedomrank;
run;

/*To make the data easier to manage we have decided to compare the variables by region instead of by individual country
and have taken steps to define the variables by region*/
PROC MEANS DATA = econfreeip5;
CLASS region ;
VAR penetration gdpbillion population freedomrank;
run;

data EconfreeipRegion;
length Region $ 35;
input Region $ Penetration Wealth Population Freedomrank;
infile datalines delimiter=',';
datalines;
Asia-Pacific,0.4517429,42020.7,3875,5
Europe,0.7528293,25061.9,810,2
Middle-East/North-Africa,0.6158462,6069.6,309,3
North-America,0.7403333,21151.1	,474,1
South-and-Central-America/Carribean,0.4912308,483,7146.1,4
Sub-Saharan-Africa,0.1669767,3303.0,885,6
;
run;

/*Scatterplots of variables per region*/

proc sgplot data=econfreeipregion;
	vbar region /response=population 
	fillattrs=(color=red)
	          transparency=.5
	          barwidth=.6;
run;


proc sgplot data=econfreeipregion;
	vbar freedomRank /response= wealth
	fillattrs=(color=green)
	          transparency=.5
	          barwidth=.6;
run;

proc sgplot data=econfreeipregion;
	vbar Region /response= wealth
	fillattrs=(color=green)
	          transparency=.5
	          barwidth=.6;
run;

proc sgplot data=econfreeipregion;
	vbar region /response=Penetration
	fillattrs=(color=purple)
	          transparency=.5
	          barwidth=.6;
run;

proc sgplot data= econfreeipregion;
	vbar region / response= FreedomRank;
run;

proc sort data=econfreeipregion;
by freedomrank;
run;


proc sgplot data=econfreeipregion;
scatter x=FreedomRank  y=Penetration /markerattrs=(symbol=square);
reg x=FreedomRank  y=Penetration;
run;


proc sgplot data=econfreeipregion;
scatter x=wealth  y=Penetration /markerattrs=(symbol=square);
reg x=wealth y=Penetration;
run;


proc sgplot data=econfreeipregion;
scatter x=freedomrank  y=wealth /markerattrs=(symbol=square);
reg x=freedomrank y=wealth;
run;

/*Scatterplots per Country*/
/*Use all but the last scatterplot*/
proc sgplot data=econfreeip5;
scatter x=FreedomRank  y=Penetration /markerattrs=(symbol=square);
reg x=FreedomRank  y=Penetration;
loess x=FreedomRank y=Penetration;
run;


proc sgplot data=econfreeip5;
scatter x=gdpbillion  y=Penetration /markerattrs=(symbol=square);
reg x=gdpbillion y=Penetration;
loess x=gdpbillion y=Penetration;
run;


proc sgplot data=econfreeip5;
scatter x=freedomrank  y=gdpbillion /markerattrs=(symbol=square);
reg x=freedomrank y=gdpbillion;
loess x=freedomrank y=gdpbillion;
run;

/*Numerical Summeries of Data per country for more representative results*/

proc corr data=econfreeip5;
var penetration;
with freedomrank;
run;

proc corr data=econfreeip5;
var penetration;
with gdpbillion;
run;

proc corr data=econfreeip5;
var gdpbillion;
with freedomrank;
run;


proc corr data= econfreeip5;
var gdpbillion penetration;
with freedomrank;
run;

proc corr data= econfreeip5;/*Use this procedure*/
var gdpbillion freedomrank;
with penetration;
run;

/*Regression*/
proc reg data=econfreeip5;
model penetration= freedomrank GDPBillion;
run;
