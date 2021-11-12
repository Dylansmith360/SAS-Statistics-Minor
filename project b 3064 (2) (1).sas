FILENAME REFFILE '/home/u42230827/assignments/dataset-of-10s.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=songs10;
	GETNAMES=YES;
RUN;

/*limit observations to first 251. Original dataset contained over 6000*/
data songs11;
set songs10 NOBS=COUNT;
if count - _n_ > 250 then delete;
drop cod_centro;
run;

proc contents data=songs10; 

/** Print the results. **/
PROC PRINT DATA=songs11; RUN;

/*Data exploration, splitting the scatter plots into 3 to make it visually appealing*/
Proc sgscatter data=songs11;
 	compare y=target x=(acousticness chorus_hit danceability duration_ms)/loess;
 	run;
Proc sgscatter data=songs11;
 	compare y=target x=(energy instrumentalness key liveness loudness mode)/loess;
 	run;
Proc sgscatter data=songs11;
 	compare y=target x=(sections speechiness tempo time_signature valence)/ loess;
 	run;
 	
 	

/* Logistic model using valence*/
proc logistic data = songs11;
	model target (event = '1') = valence;
Run;
/*create an empirical logit plot*/
proc rank data=songs11 groups=20 out=out;
   Var valence;
   ranks Bin;
Run;
/*Summarize by each bin*/
proc means data=out nway noprint;
 class bin;
 var target valence;
 output out=bins Sum(target)=target mean(valence)=valence;
run;
proc print data=bins;
run;
/*Calculate empirical logits for each group*/
Data bins2;
 set Bins;
 EmpLogit=log((target+.5)/(_freq_- target +.5));
Run;
/*comment on linearity*/
Title 'Empirical Logit Plot for Linearity Check';
proc sgplot data=bins2;
 reg y=EmpLogit x=valence;
Run;


/*odds ratio with 95% confidence limits*/
proc logistic data = songs11;
	model target (event = '1') = valence /clodds=wald;
run;


/*select new value of interest for x, produce predicted probability of success*/
proc logistic data=songs11 descending; /*descending defines a 1 as success*/
	model target = valence/expb rsquare; /*expb exponentiates each of the estimated parameters*/
run;
/*Predict the prob of popularity (target=1) for valence=.9*/
/*Hidden y trick*/
Data new;
input valence;
datalines;
.9
;
run;
/*Concatenate with the original*/
Data songs13;
	set new songs11;
run;
proc logistic data=songs13 descending;
	model target = valence;
	output out=PredProbs predicted=phat; /*PredProbs is the file name and 
	                                       phat is the variable name for 
	                                       predicted probabilities*/
run;
proc print data=PredProbs;
run;
/*What valence score will give a 0.5 probabilty*/
Data Fifty50;
B0 = -1.3574;
B1 = 2.4576;
p = .5;
logit = log(p/(1-p));
X = (logit - B0)/B1;
put X; /*result will go into the log*/
run;
proc sgplot data=songs13;
	loess y=target x=valence/smooth=.2;
run;
/*print .5 probability*/
proc print data= fifty50;
run;



/* Check for multicollinearity*/
proc reg data = songs11;
	model target =  acousticness chorus_hit danceability duration_ms
					energy instrumentalness key liveness loudness mode
					sections speechiness tempo time_signature valence/ VIF;
Run;


/* Backwards selection*/
proc logistic data = songs11;
	model target (event = '1') = acousticness chorus_hit danceability duration_ms
								energy instrumentalness key liveness loudness mode
								sections speechiness tempo time_signature valence / selection = b;
Run;


/*Assess best model*/
proc logistic data = songs11;
	model target (event = '1') = energy instrumentalness loudness valence ;
Run;



/* Prediction model of probability of success */
proc surveyselect data = songs11 samprate=.8 method = srs
		                outall out= songs12;
run;
proc print data = songs12;
/*split into 2 data sets */
data training validation;
set songs12;
if selected = 1 then output training;
				else output Validation;
run;
proc print data=training;
run;
proc print data= Validation;
run;
/* create the model */
proc logistic data = training;
	model Target (event = '1') = energy instrumentalness loudness valence;
/* scoring model.*/
score data = Validation out= results;
run; 
proc print data = results;
run;



/* ROC for best model and model of choosing */
proc logistic data = songs11 plots = ROC ;
	model target (event = '1') =  energy instrumentalness loudness valence ;
	ROC 'instrumentalness & loudness ' instrumentalness loudness ;
Run;






