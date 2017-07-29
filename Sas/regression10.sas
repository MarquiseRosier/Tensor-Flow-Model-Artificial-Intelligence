proc import datafile='/home/mr13c0/my_courses/RealRegression/gala.csv'
out=gala
dbms=csv replace;

proc import datafile='/home/mr13c0/my_courses/RealRegression/divusa.csv'
out=divusa
dbms=csv replace;

proc reg data=gala outest=galaf;
	model species=area elevation nearest scruz adjacent
	/selection=forward sle=0.05 aic;
run;
quit;

proc reg data=divusa outest=divf;
	model divorce=year unemployed femlab marriage birth military
	/selection=forward sle=0.05 aic;
run;
quit;

proc reg data=gala outest=galab;
	model species=area elevation nearest scruz adjacent
	/selection=backward sls=0.05 aic;
run;
quit;

proc reg data=divusa outest=divb;
	model divorce=year unemployed femlab marriage birth military
	/selection=backward sls=0.05 aic;
run;
quit;

proc reg data=gala outest=galaa;
	model species=area elevation nearest scruz adjacent
	/selection=adjrsq aic;
run;
quit;

proc reg data=divusa outest=diva;
	model divorce=year unemployed femlab marriage birth military
	/selection=adjrsq aic;
run;
quit;

proc reg data=gala;
	model species=area elevation nearest scruz adjacent
	/selection=cp;
run;
quit;

proc reg data=divusa;
	model divorce=year unemployed femlab marriage birth military
	/selection=cp;
run;
quit;


proc print data=galaf;
var _AIC_ _RSQ_;
run;

proc print data=galab;
var _AIC_ _RSQ_;
run;

proc print data=galaa (firstobs=1 obs=1);
var _AIC_ _RSQ_;
run;

proc print data=divf;
var _AIC_ _RSQ_;
run;

proc print data=divb;
var _AIC_ _RSQ_;
run;

proc print data=diva (firstobs=1 obs=1);
var _AIC_ _RSQ_;
run;
