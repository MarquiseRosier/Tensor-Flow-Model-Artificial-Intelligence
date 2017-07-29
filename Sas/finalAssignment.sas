PROC IMPORT 
DATAFILE='/home/mr13c0/my_courses/RealRegression/data100.csv'
OUT=data100
DBMS=CSV
REPLACE;

PROC IMPORT 
DATAFILE='/home/mr13c0/my_courses/RealRegression/data1000.csv'
OUT=data1000
DBMS=CSV
REPLACE;

PROC IMPORT 
DATAFILE='/home/mr13c0/my_courses/RealRegression/test1000.csv'
OUT=test1000
DBMS=CSV
REPLACE;

/*Question 1*/
/*Part A*/
PROC REG DATA=data100 outtest=firstModel;
MODEL y=x1-x1000;
RUN;
QUIT;

/*PART B*/

PROC SCORE DATA=test1000 
SCORE=firstModel 
OUT=firstModelScore 
RESIDUAL TYPE=parms;
var x1-x1000 y;
RUN;

PROC UNIVARIATE DATA=firstModel;
VAR model1;
OUTPUT OUT=ScoreStats USS=SS1;
RUN;

DATA ScoreStats;
SET ScoreStats;
RootMeanSquared=sqrt(SS1/1000);
RUN;

/*PART C*/

PROC REG DATA=data100;
MODEL y = x1-x1000
/SELECTION=forward sle=0.01;
RUN;

/*PART D*/
PROC REG DATA=data100 outest=secondModel;
MODEL y=x15 x27 x38 x45 x48 x53 x60 x73 x90 x100 x123 x142 x147 x519 x635 x738;
RUN;

PROC SCORE DATA=test1000 
SCORE=secondModel OUT=model2Test
RESIDUAL TYPE=parms;
VAR x15 x27 x38 x45 x48 x53 x60 x73 x90 x100 x123 x142 x147 x519 x635 x738 y;
RUN;

PROC UNIVARIATE DATA=model2Test;
VAR model1;
OUTPUT OUT=model2ScoreStats USS=SS1;
RUN;

DATA model2ScoreStats;
SET model2ScoreStats;
RMSE=sqrt(SS1/1000);
RUN;

/*PART E*/
PROC REG DATA=data100;
MODEL y=x1-x1000
/SELECTION=forward 
SLE=0.001;
RUN;

/*PART F*/
PROC REG DATA=data100 outest=thirdModel;
MODEL y=x27 x38 x53 x60 x90 x100 x123 x142 x147;
RUN;

PROC SCORE DATA=test1000 
SCORE=thirdModel OUT=thirdModelScore RESIDUAL TYPE=parms;
VAR x27 x38 x53 x60 x90 x100 x123 x142 x147 y;
RUN;

PROC UNIVARIATE DATA=fourthModelScore;
VAR model1;
OUTPUT OUT=thirdScoreStats USS=SS1;
RUN;

DATA thirdScoreStats;
SET thirdScoreStats;
RMSE=sqrt(SS1/1000);
RUN;

/*QUESTION 2*/
/*PART A*/

PROC REG DATA=data1000;
MODEL y=x1-x1000
/SELECTION=stepwise 
SLE=0.001;
RUN;

/*PART B*/
PROC REG DATA=data1000 OUTTEST=firstModel2;
MODEL y=x15 x30 x45 x60 x75 x90 x105 x120 x135 x150;
RUN;

PROC SCORE DATA=test1000 
SCORE=firstModel2 OUT=firstModel2Score RESIDUAL TYPE=parms;
VAR x15 x30 x45 x60 x75 x90 x105 x120 x135 x150 y;
RUN;

PROC UNIVARIATE DATA=firstModel2Score;
VAR model1;
OUTPUT OUT=firstScore2Stats USS=SS1;
RUN;

DATA firstScore2Stats;
SET firstScore2Stats;
RMSE=sqrt(SS1/1000);
RUN;

/*PART C ANSWER QUESTIN HERE*/
/*THERE ARE SIMPLY TOO MANY VARIABLES AND THUS, TOO MANY DIFFERENT COMBINATIONS OF THOSE VARIABLES!
THE ADJRSQ METHOD WOULD HAVE TO CONDUCT 1000^1000 POWER*/ 

/*PART D*/

PROC PLS DATA=data1000 
NFAC=10;
MODEL y=x1-x1000;
OUTPUT OUT=PLSOutput p=predid;
RUN;

data predictedAndTrue;
set PLSOUTPUT(keep=predid);
set test1000(keep=y);
run;

data error;
RMSE=0;
totalSquareError=0;
do obsnum=1 to 1000;
set predictedAndTrue point=obsnum;
totalSquareError=totalSquareError+(y-predid)**2;
RMSE=sqrt(totalSquareError/1000);
OUTPUT;
END;
STOP;
RUN;

/*PART E*/
PROC REG DATA=data100 OUTVIF
		OUTTEST=b ridge=0 to 0.001 by 0.0001;
	MODEL y=x1-x1000;
RUN;

PROC PRINT DATA=b;
RUN;


/*PART F*/
PROC REG DATA=data1000;
MODEL y=x15 x30 x45 x60 x75 x90 x105 x120 x135 x150
/dwprob; /*here we test for correlated errors*/
OUTPUT OUT=studs rstudent=rez;
RUN;
QUIT;

data quantiles;
cuttoff=abs(tinv(0.05/(2*1000),1000-11-1));
run;

data outliers;
do i=1 to 1000 by 1;
set new point=i;
if (abs(rez)>4.0736028735) then output;
end;
stop;
run;

/*PART I*/
PROC CORR DATA=data1000;
VAR x15 x30 x45 x60 x75 x90 x105 x120 x135 x150;
RUN;

PROC REG DATA=data1000;
MODEL y=x15 x30 x45 x60 x75 x90 x105 x120 x135 x150
/COLLIN;
RUN;

PROC REG DATA=data1000;
MODEL y=x15 x30 x45 x60 x75 x90 x105 x120 x135 x150
/PARTIAL;
RUN;