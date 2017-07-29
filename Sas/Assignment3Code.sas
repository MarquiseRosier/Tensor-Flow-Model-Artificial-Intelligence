data X;    /* set random number seed */
do i = 1 to 300;
   Max = 10;
   xVar = floor((1+Max)*ranuni(123));
   vVar = rand('normal', 0, 1);
   eVar = rand('normal', 0, 1);
   output;
end;
run;


axis1 label=(angle=90 height=0.75);
symbol1 value=circle color=red height=.5;
symbol2 value=square color=blue height=.5;
proc gplot data=X;
plot eVar * xVar / overlay noframe
vaxis=axis1 vminor=1 hminor=0;
run;

data X;
set X(keep=eVar xVar vVar);
aVar = xVar + 0.1*eVar;
run;

data X;
set X(keep=eVar xVar vVar aVar);
y = xVar + aVar + vVar;
z = 0.1*eVar;
run;

proc reg data=X;
model aVar=xVar;
output out=regData predicted=predid;
run;

axis1 label=(angle=90 height=0.75);
symbol1 value=circle color=red height=.5;
symbol2 value=none color=blue interpol=join;
proc gplot data=regData;
plot aVar*xVar predid*xVar/ overlay noframe
vaxis=axis1 vminor=1 hminor=0;
run;

proc reg data=X;
model y = xVar aVar;
output out=regDataY predicted=predid;
run;

axis1 label=(angle=90 height=0.75);
symbol1 value=circle color=red height=.5;
symbol2 value=none color=blue interpol=join;
proc gplot data=regDataY;
plot z*xVar predid*xVar/ overlay noframe
vaxis=axis1 vminor=1 hminor=0;
run;

proc reg data=X;
model z = xVar;
output out=regDataZ predicted=predid;
run;

axis1 label=(angle=90 height=0.75);
symbol1 value=circle color=red height=.5;
symbol2 value=none color=blue interpol=join;
proc gplot data=regDataZ;
plot z*xVar predid*xVar/ overlay noframe
vaxis=axis1 vminor=1 hminor=0;
run;
