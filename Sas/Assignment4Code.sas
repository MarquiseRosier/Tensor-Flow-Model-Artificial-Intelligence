proc import datafile='/home/mr13c0/my_courses/RealRegression/prostate.csv'
out=prostate
dbms=csv replace;

proc print data=prostate;
run;

data predict;
lcavol=1.8;
lweight=3.9;
age=68;
lbph=0.4;
svi=0;
lcp=-0.7;
gleason=7.6;
pgg45=14;
run;

data prostate;
set prostate predict;
run;

proc reg data=prostate outest=model1;
model lpsa=lcavol lweight age lbph svi lcp gleason pgg45 /p clm  cli;
newTest: test lweight=0.5;
run;


/*No F Value for test if lweight=0.5 is 0.750 thus we cannot reject the
hypothesis of this test which means we cannot say that lweight is not .5*/


proc score data=predict score=model1 out=prediction residual type=parms;
var lcavol lweight age lbph svi lcp gleason pgg45;
run;

proc print data=prediction;
run;


proc reg data=prostate outest=model1;
model lpsa=age lbph lcp gleason pgg45 /p clm  cli;
restrict intercept=0;
run;

proc score data=predict score=model1 residual type=parms out=prediction2;
var age lbph lcp gleason pgg45;
run;

proc print data=prediction2;
run;

/*-----------------------------------------------------*/

proc import datafile='/home/mr13c0/my_courses/RealRegression/teengamb.csv'
out=teengamb
dbms=csv replace;

proc print data=teengamb;
run;

data teengambTemp;
set teengamb;
run;

proc reg data=teengamb outest=model2;
model gamble=sex status income verbal;
run;	

/*sex is binary parameter (either 0 or 1), if it is 1 however, it has a negative effect on the
likelihood of a person gambling*/

proc univariate data=teengamb;
var income;
output out=meanIncome mean=incomeMean;
run;

proc univariate data=teengamb;
var verbal;
output out=meanVerbal mean=verbalMean;
run;

proc univariate data=teengamb;
var status;
output out=meanStatus mean=statusMean;
run;

proc print data=meanIncome;
run;

proc print data=meanVerbal;
run;

proc print data=meanStatus;
run;

data prediction3;
sex = 0;
income = 4.64191;
verbal = 6.65957;
status = 45.2340;
run;

data prediction4;
sex = 0;
income = 15;
verbal = 10;
status = 75;
run;

data teengamb;
set teengamb prediction3 prediction4;
run;

proc score data=prediction3 score=model2 residual type=parms out=predict3;
var sex status income verbal;
run;

proc print data=predict3;
run;


proc reg data=teengamb;
model gamble=sex status income verbal /p clm cli;
run;

proc reg data=teengambTemp;
model gamble=sex status income verbal;
run;

proc reg data=teengambTemp;
model gamble=income verbal;
run;
