proc import datafile='/home/mr13c0/my_courses/RealRegression/seatpos.csv'
out=seatpos
dbms=csv replace;

data seatpos;
set seatpos(drop=id);
run;

proc standard mean=0 std=1 data=seatpos out=seatPos;
var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg;
run;
quit;

proc print data=seatPos;
run;

data seatpos1;
   do obsnum=1 to 38 by 2;
      set seatpos point=obsnum;
      if _error_ then abort;
      output;
   end;
   stop;
run;

data seatpos0;
   do obsnum=2 to 38 by 2;
      set seatpos point=obsnum;
      if _error_ then abort;
      output;
   end;
   stop;
run;

proc princomp data=seatpos0 outstat=pos0PCA;
var Age	Weight	HtShoes	Ht	Seated	Arm Thigh Leg;
run;

proc score data=seatpos0 score=pos0PCA out=seat0PCA;
	var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg;
run;

proc reg data=seat0PCA outest=modelpos0;
	model hipcenter=Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg;
run;
quit;

proc princomp data=seatpos1 outstat=pos1PCA;
var Age	Weight	HtShoes	Ht	Seated	Arm Thigh Leg;
run;

proc score data=seatpos1 score=pos1PCA out=seat1PCA;
	var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg;
run;

proc reg data=seat1PCA outest=modelpos1;
	model hipcenter=Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg;
run;
quit;

proc score data=seatpos1 score=modelpos1 out=trainpos1 residual type=parms;
	var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg hipcenter;
run;

proc univariate data=trainpos1 noprint;
	var model1;
	output out=trainpos1stat uss=ssl;
run;

data trainpos1stat;
set trainpos1stat;
rmse=sqrt(ssl/19);
run;

proc print data=trainpos1stat;
run;

proc score data=seatpos0 score=modelpos0 out=trainpos0 residual type=parms;
	var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg hipcenter;
run;

proc univariate data=trainpos0 noprint;
	var model1;
	output out=trainpos0stat uss=ssl;
run;

data trainpos0stat;
set trainpos0stat;
rmse=sqrt(ssl/19);
run;

proc print data=trainpos0stat;
run;

proc autoreg data=seatpos0;
model hipcenter=Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg/ nlag=1 method=yw dwprob;
run;
quit;

proc reg data=seatpos0 outest=pos0RSQ;
model12: model hipcenter=Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg/selection=adjrsq aic;
run;
quit;

proc score data=seatpos0 score=pos0RSQ out=train0RSQ residual type=parms;
	var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg hipcenter;
run;

proc univariate data=train0RSQ noprint;
	var model12;
	output out=train0RSQstat uss=ssl;
run;

data train0RSQstat;
set train0RSQstat;
rmse=sqrt(ssl/19);
run;

proc reg data=seatpos1 outest=pos1RSQ;
model hipcenter=Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg/selection=adjrsq aic;
run;
quit;

proc score data=seatpos1 score=pos1RSQ out=train1RSQ residual type=parms;
	var Age	Weight	HtShoes	Ht	Seated	Arm	Thigh	Leg hipcenter;
run;

proc univariate data=train1RSQ noprint;
	var model13;
	output out=train1RSQstat uss=ssl;
run;

data train1RSQstat;
set train1RSQstat;
rmse=sqrt(ssl/19);
run;






