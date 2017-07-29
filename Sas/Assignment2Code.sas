proc import out=prostate
datafile="/home/mr13c0/my_courses/RealRegression/prostate.csv"
dbms = csv replace;
run;

/*pb 2*/
proc reg data=prostate;
model lpsa=lcavol;
run;

proc reg data=prostate;
model lpsa=lcavol lweight;
run;

proc reg data=prostate;
model lpsa=lcavol lweight svi;
run;

proc reg data=prostate;
model lpsa=lcavol lweight svi lbph;
run;


proc reg data=prostate;
model lpsa=lcavol lweight svi lbph age;
run;

proc reg data=prostate;
model lpsa=lcavol lweight svi lbph age lcp;
run;


proc reg data=prostate;
model lpsa=lcavol lweight svi lbph age lcp pgg45;
run;


proc reg data=prostate;
model lpsa=lcavol lweight svi lbph age lcp pgg45 gleason;
run;

data info;
input predicts rss rsquare;
datalines;
1 58.91476 0.5394
2 52.96626 0.5859
3 47.78486 0.6264
4 46.48480 0.6366
5 45.52556 0.6441
6 45.39629 0.6451
7 44.20247 0.6544
8 44.16302 0.6234
;
run;

symbol1 value=circle color=red;
proc gplot data=info;
plot rss*predicts;
run;

symbol1 value=square color=blue;
proc gplot data=info;
plot rsquare*predicts;
run;

/* pb 3 */

Proc reg data=prostate;
model lpsa=lcavol;
output out=new p=plpsa;
run;
quit;

Proc reg data=prostate;
model lcavol=lpsa;
output out=new1 p=plcavol;
run;
quit;


data new;
set new;
set new1(keep=plcavol);
run;

axis1 label=(angle=90 height=0.75);
symbol1 value=circle color=black height=.5;
symbol2 value=none color=red interpol=join;
symbol3 value=none color=blue interpol=join;
proc gplot data=new;
plot lpsa*lcavol plpsa*lcavol lpsa*plcavol/ overlay noframe
vaxis=axis1 vminor=1 hminor=0;
run;
quit;