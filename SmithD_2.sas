/* Dylan Smith Assingment 2*/
/*I certify that the SAS code given is my original and exclusive work*/ 

/*1*/
data BaseballTimes;
input Game $ League $ Runs    Pitchers    Time;
datalines;
CLE-DET    AL    14    6    168
CHI-BAL    AL    11    5    164
BOS-NYY    AL    10   11    202
TOR-TAM    AL     8   10    172
TEX-KC     AL     3    4    151
OAK-LAA    AL     6    4    133
MIN-SEA    AL     5    5    151
CHI-PIT    NL    23   14    239
LAD-WAS    NL     3    6    156
FLA-ATL    NL    19   12    211
CIN-HOU    NL     3    4    147
MIL-STL    NL    12    9    185
ARI-SD     NL    11   10    164
COL-SF     NL     9    7    180
NYM-PHI    NL    15   16    317
;
run;

proc sgplot data=baseballtimes;
scatter x=Pitchers y=Time;
loess x=Pitchers y=Time/smooth=1;
run;

proc reg data=baseballtimes;
model Time=Pitchers;
run;

proc transreg data=baseballtimes;
model boxcox(Time)=identity(Pitchers);
run;

data baseballtimes2;
	set baseballtimes;
	yt = Time**-1.25;
run;
proc print data=baseballtimes2;
run;

proc reg data=baseballtimes2;
	model yt = Pitchers/cli clm;
	id Pitchers;
run;


/*2(2.14)*/
data TextPrices;
input Pages       Price;
datalines;
600       95.00
91       19.95
200       51.50
400       128.50
521       96.00
315       48.50
800       146.75
800       92.00
600       19.50
488       85.50
150       16.95
140       9.95
194       5.95
425       58.75
51       6.50
930       70.75
57       4.25
900       115.25
746       158.00
104       6.50
696       130.50
294       7.00
526       41.25
1060       169.75
502       71.25
590       82.25
336       12.95
816       127.00
356       41.50
248       31.00
;
run;

proc reg data=TextPrices;
	model Price = Pages/cli clm;

run;
/*2(2.15)a-e*/
proc transreg data=TextPrices;
	model boxcox(Price)=identity(Pages);
run;

data TextPrices2;
	set TextPrices;
	yt = Price**0.5;
run;

proc reg data=TextPrices2;
	model yt = Pages/cli clm;
	id Pages;
run;

Data new;
input Pages;
datalines;
450
;
run;

data TextPrices3;
	set new TextPrices2;
run;

proc reg data=TextPrices3;
	model yt = Pages/cli clm;
	id  Pages;
run;
/*2.15f*/
Data new2;
input Pages;
datalines;
1500
;
run;

data TextPrices4;
	set new2 TextPrices2;
run;

proc reg data=TextPrices4;
	model yt = Pages/cli clm;
	id  Pages;
run;

/*3(2.23)*/

data MathEnrollmentadjusted;
input Ayear     Fall     Spring;
if Ayear ne 2003; 
datalines;
2001     259     246
2002     301     206
2003     343     288
2004     307     215
2005     286     230
2006     273     247
2007     248     308
2008     292     271
2009     250     285
2010     278     286
2011     303     254
;
run;

proc reg data=mathenrollmentadjusted plots(unpack)=boxplot;;
model spring = fall;
run;
/*added ayear to obtain a residual plot against ayear*/
proc reg data=mathenrollmentadjusted plots(unpack)=boxplot;;
model spring = fall ayear;
run;
/*3e*/
proc transreg data=mathenrollmentadjusted;
	model boxcox(spring)=identity(fall);
run;

data mathenrollmentadjusted2;
	set mathenrollmentadjusted;
	spring = fall**0.75;
run;

proc reg data=mathenrollmentadjusted2;
	model spring = fall/cli clm;
	id fall;
run;

/*3(2.24)*/

Data new;
input fall;
datalines;
290
;
run;

data mathenrollmentadjusted3;
	set new mathenrollmentadjusted2;
run;

proc reg data=mathenrollmentadjusted3;
	model spring = fall/cli clm;
	id ayear fall;
run;

/*3b-d (2.24)*/
proc reg data=mathenrollmentadjusted2;
	model spring = fall/cli clm;
	id fall;
run;
