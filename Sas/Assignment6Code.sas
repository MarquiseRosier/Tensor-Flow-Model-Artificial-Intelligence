proc import datafile='/home/mr13c0/my_courses/RealRegression/uswages.csv'
out=uswages
dbms=csv replace;

data logWages;
set uswages;
lWage = log(wage);
run;

proc reg data=logWages;
model lWage=educ exper /partial;
output out=new rstudent=rez;
run;

data quantiles;
cuttoff=abs(tinv(0.05/(2*2000),2000-9-1));
run;

proc print data=quantiles;
run;

data outliers;
do i=1 to 2000 by 1;
set new point=i;
index = i;
if (abs(rez)>4.22476) then output;
end;
stop;
run;


data outliers;
do i=1 to 2000 by 1;
set logWages point=i;
if (( 0 < i < 1033) OR (1033 < i < 1576) OR (i > 1576)) then output;
end;
stop;
run;

proc reg data=outliers;
model lWage=educ exper /partial;
output out=new rstudent=rez;
run;

data quantiles;
cuttoff=abs(tinv(0.05/(2*1998),1998-9-1));
run;

proc print data=quantiles;
run;

data outliers;
do i=1 to 1998 by 1;
set new point=i;
index = i;
if (abs(rez)>4.22454) then output;
end;
stop;
run;

proc print data=outliers;
run;

data outliers;
do i=1 to 1998 by 1;
set logWages point=i;
if (( 0 < i < 1112) OR (i > 1112)) then output;
end;
stop;
run;

proc reg data=outliers;
model lWage=educ exper /partial;
run;