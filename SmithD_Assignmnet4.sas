/* Dylan Smith Assingment 4*/
/*I certify that the SAS code given is my original and exclusive work*/
ods text= '1a';
data DriveThru;
input resturant time @@;
datalines;
1    260    1    246    1    263    1    249    1    230
1    240    1    238    1    254    1    242    1    230
1    257    1    254    1    215    1    229    1    243
1    248    1    244    1    233    1    246    1    254
2    205    2    234    2    226    2    242    2    225
2    236    2    230    2    211    2    231    2    222
2    233    2    223    2    239    2    215    2    242
2    220    2    241    2    190    2    221    2    214
3    275    3    255    3    263    3    267    3    240
3    251    3    253    3    264    3    261    3    231
3    253    3    256    3    265    3    249    3    262
3    272    3    229    3    241    3    264    3    243
4    248    4    252    4    251    4    236    4    262
4    244    4    233    4    268    4    250    4    243
4    259    4    235    4    270    4    237    4    270
4    257    4    269    4    259    4    269    4    245
;
run;
proc print data=drivethru (firstobs=20 obs=45);
run;
ods text='1b';
proc format;
value value 1='mcdonalds' 2='wendys' 3= 'taco bell' 4= 'kfc';
run;
proc print data=drivethru (firstobs=40 obs=61);
format resturant value.;
run;
ods text='1c';
proc means mean range P5 P95;
by resturant;
var time;
run;
ods text='wendys has on average the lowest times but mcdonalds has the least variation in their times.';
ods text='1d';
data drivethrew; 
set drivethru;
if time < 225 then efficiency = 'fast   ';
if 225 <= time <= 250 then efficiency = 'typical';
if time > 250 then efficiency = 'slow   ';
run;
proc freq data=drivethrew; 
run;                                                                                             
ods text='1e';
proc freq data=drivethrew; table resturant*efficiency;
run;
ods text='both resturant 3 and 4 (taco bell and kfc do not have any fast service)';
ods text='1f';
data trivedru; set drivethru;
if resturant = 1 then catagory='burgers';
if resturant = 2 then catagory='burgers';if resturant = 3 then catagory='others'; if resturant = 4 then catagory='others';
run;
proc means data=trivedru; by catagory; run;
ods text='burgers have a lower mean time but other has a lower standard deviation';

ods text='2a';
data BIGWheel;
do n=1 to 10000; x = ceil(20*rand('uniform'))*5;
if X<85 then Y=ceil(20*rand('uniform'))*5;
Else Y=0;
Total=X+Y;
output; end; run;
proc print data=BIGWheel (obs=20);
run;
ods text='2b';
proc sgplot data=BIGWheel;
histogram total;
run;
ods text='2c';
data Wheel;
set BIGWheel;
if total > 100 then Z ='Over';
else Z='Under';
run;
proc freq data=Wheel;
table Z;
run;
ods text='33.93%'

ods text='2d';
ods text='I think that it is a good strategy. I think this because 2/3s of the time the outcome was under 100 so a contestant would win over half of the time.'
ods text='3a';
Data Pois;
Do k = 1 to 20000;
	X1 = rand('Poisson',2.1);
	X2 = rand('Poisson',2.1); 
	X3 = rand('Poisson',2.1); 
	X4 = rand('Poisson',2.1); 
	X5 = rand('Poisson',2.1); 
	X6 = rand('Poisson',2.1); 
	output;
end;
Run;
proc sgplot data=Pois;
	histogram x1 / transparency=.3;
	
run;
ods text='The poisson ends at 0 and does not continously go on.';

ods text='3b';
Data Poiss;
Do p = 1 to 40000;
	y1 = rand('Poisson',2.1);
	y2 = rand('Poisson',2.1); 
	y3 = rand('Poisson',2.1); 
	y4 = rand('Poisson',2.1); 
	y5 = rand('Poisson',2.1); 
	y6 = rand('Poisson',2.1);
	y7 = rand('Poisson',2.1); 
	y8 = rand('Poisson',2.1); 
	y9 = rand('Poisson',2.1); 
	y0 = rand('Poisson',2.1);
	Avg1 = mean(of y1-y2);
	Avg2 = mean(of y1-y5);
	Avg3 = mean(of y1-y0);
		output;
		end;
	Run;
proc print data=Poiss (obs=5);
run;

ods text='3c';
proc sgplot data=poiss;
	histogram Avg1 / transparency=.75  fillattrs=(color=blue);
	histogram Avg2 / transparency=.6  fillattrs=(color=green);
	histogram Avg3 / transparency=.45  fillattrs=(color=lightred);
run;
ods text='3d';
ods text='The center is around 2 for all graphs. The shape is a bell curve. The spread is tight and is right skewed. The concept being explored is the central limit theorem. The plots demonstrates the concept though showing the tightening of the histograms around the center as the iterations rise.';