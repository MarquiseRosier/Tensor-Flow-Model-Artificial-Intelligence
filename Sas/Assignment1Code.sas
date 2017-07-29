proc import datafile="/home/mr13c0/my_courses/RealRegression/gala.csv"
out=gala
dbms=csv replace;

/*PART 1*/
proc sort data=gala out=sortedGala;
by endemics;
run;

/*PART 2*/
data sortedGala;
set sortedGala;
sspecies=sqrt(species);
run;

proc univariate data=sortedGala noprint;
var sspecies;
output out=galaStatistics mean=galaMean std=galaStandardDeviation;
run;

/*PART 3*/
data newGala;
set sortedGala;
pred=2.51 + 0.193*endemics;
pred1=1 + 0.4*endemics;
run;

proc univariate data=newGala noprint;
var pred;
output out=galaPredVarStatistics mean=predMean std=predStd;
run;

proc univariate data=newGala noprint;
var pred1;
output out=galaPred1VarStatistics mean=pred1Mean std=pred1Std;
run;

proc print data=galaStatistics;
run;

proc print data=galaPredVarStatistics;
run;

proc print data=galaPred1VarStatistics;
run;

proc sgplot data=newGala;
scatter x=endemics y=sspecies;
scatter x=endemics y=pred;
series x=endemics y=pred / lineattrs=(color=red);
series x=endemics y=pred1 / lineattrs=(color=blue);
run;

data partFGala;
set newGala;
rez=pred-sspecies;
rez1=pred1-sspecies;
run;

proc univariate data=partFGala noprint;
var rez;
output out=rezData mean=rezMean std=rezStd;
run;

proc univariate data=partFGala noprint;
var rez1;
output out=rez1Data mean=rez1Mean std=rez1Std;
run;

proc print data=rezData;
run;

proc print data=rez1Data;
run;

data partFGala;
set partFGala;
rezS=(rez-.00326808)**2;
rez1S=(rez1-3.89597)**2;
run;

proc print data=partFGala;
run;

proc print data=partFGala;
sum rezS rez1S;
run;
