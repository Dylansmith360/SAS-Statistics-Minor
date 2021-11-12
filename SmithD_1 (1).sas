/* Dylan Smith Assingment 4*/
/*I certify that the SAS code given is my original and exclusive work*/
/*1a*/
Data USstamps;
input Year Price;
datalines;
Year          Price
1885          2
1917          3
1919          2
1932          3
1958          4
1963          5
1968          6
1971          8
1974          10
1975          13
1978          15
1981          18
1981          20
1985          22
1988          25
1991          29
1995          32
1999          33
2001          34
2002          37
2006          39
2007          41
2008          42
2009          44
2012          45
;
run;

proc gplot data=USstamps;
plot year*price;
run;

/*1b-c*/
Data USstamps2;
input Year Price;
datalines;
Year          Price
1958          4
1963          5
1968          6
1971          8
1974          10
1975          13
1978          15
1981          18
1981          20
1985          22
1988          25
1991          29
1995          32
1999          33
2001          34
2002          37
2006          39
2007          41
2008          42
2009          44
2012          45
;
run;



proc reg data=USstamps2;
model year = price;
run;


/*1d*/
Data USstamps3;
input Year Price;
datalines;
Year          Price
1963          5
1968          6
1971          8
1974          10
1975          13
1978          15
1981          18
1981          20
1985          22
1988          25
1991          29
1995          32
1999          33
2001          34
2002          37
2006          39
2007          41
2008          42
2009          44
2012          45
;
run;
/*problematic observation removed to see if fit is better*/


proc reg data=USstamps3;
model year = price;
run;

/*2a-d*/
Data BaseballTimes;
input Game $  League $ Runs    Pitchers    Time;
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

proc sgscatter data=baseballtimes;
compare y = Time x = Runs;
Title 'Runs vs Time';
Run;
proc sgscatter data=baseballtimes;
compare y = Time x = Pitchers;
Title 'Pitchers vs Time';
Run;

proc reg data=BaseballTimes;
model Runs = Time;
run;

proc reg data=BaseballTimes;
model Pitchers = Time;
run;



/*3a-c*/
Data TextPrices;
input Pages Price;
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
1060      169.75
502       71.25
590       82.25
336       12.95
816       127.00
356       41.50
248       31.00
;
run;

proc sgscatter data=TextPrices;
compare y = Pages x = Price;
Title 'Pages vs Price';
Run;

proc reg data=TextPrices;
model Pages = Price;
run;
proc reg data=TextPrices plots(unpack)=boxplot;;
model Pages = Price;
run;

/*4a*/
Data Retirement;
input Year     SRA;
datalines;
1997     787.08
1998     968.16
1999     1975.08
2000     3990.00
2001     5455.80
2002     6338.60
2003     566.25
2004     7014.90
2005     10500.00
2006     10945.06
2007     12250.80
2008     13035.45
2009     13053.15
2010     14993.60
2011     952.04
2012     17349.69
;
run;

proc reg data=retirement;
model Year = SRA;
run;

proc reg data=retirement plots(unpack)=boxplot;
	model Year = SRA;
run;

proc reg data=retirement;
	model Year = SRA/clm cli; 
run;
/*omitted possible sabbatical years (1997 2013) 4b*/
Data Retirement2;
input Year     SRA;
datalines;
1998     968.16
1999     1975.08
2000     3990.00
2001     5455.80
2002     6338.60
2003     566.25
2004     7014.90
2005     10500.00
2006     10945.06
2007     12250.80
2008     13035.45
2009     13053.15
2010     14993.60
2012     17349.69
;
run;

proc reg data=retirement2 plots(unpack)=boxplot;
model Year = SRA;
run;

