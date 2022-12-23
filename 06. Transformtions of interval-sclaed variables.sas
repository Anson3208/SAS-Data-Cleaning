*Week 5 Chapter 16: Transformations of Interval-Scaled Variables;

*in [13];
proc print data=sashelp.class; 
run; 

DATA class;
 FORMAT ID 8.;
 SET sashelp.class(KEEP = weight);
 ID = _N_;
 Weight_Shift = Weight-100.03;
 Weight_Ratio = Weight/100.03;
 Weight_CentRatio = (Weight-100.03)/100.03;
 Weight_STD = (weight-mean)/SD;
RUN;

proc print data=class; 
run;

proc standard data=class (keep= id weight) out=class2 mean=0 std=1; 
/*Proc standard is to standardized value in order to have unitless and on same scale for analysis e.g. regression
data = class -->get data from class
out = the output of the proc standard data
mean =0 ; std = 1 --> to standardized data to be z-score
reference: https://www.youtube.com/watch?v=NxgHwrBkbvM
*/
    var weight; 
run;

proc print data=class2; 
run;

Data class; 
    MERGE class class2(RENAME= (weight=weight_Std)); /*merge two dataset based on unique key ID*/
    By id; 
Run; 

proc print data=class; 
run;




proc rank data=class out=class Ties=low descending; 
/*TIES specify how to rank tied values
https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/proc/p16s2o8e4bnqrin1phywxdaxqba7.htm */

    var weight; 
    ranks weight_Rnk; 
run; 

proc print data=class; 
run;



proc sort data=class; 
by weight; 
run; 


proc print data=class; 
run;


/*Q1 Acitivity
use proc sgplot on the "class" dataset and show the histogram of the variable Weight, Weight_Shift, Weight_Ratio, Weight_CentRatio and weight_Std*
https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/grstatproc/p073bl97jzadkmn15lhq58yiy2uh.htm/ */


proc sgplot data = class;

histogram Weight_Shift;
density Weight_Shift;
density Weight_Shift/type=kernel;

run;





* in [7];
proc print data=sashelp.air; 
run; 

proc rank data=sashelp.air out=air_rank groups=10; 
var air; 
ranks air_grp; 
run; 

proc sort data=air_rank; 
by air; 
run;


proc print data=air_rank; 
run;




*in [37];
DATA air;
 SET sashelp.air;
  Air_grp1 = CEIL(air/10);
  Air_grp2=  CEIL(air/10)*10; 
  Air_grp3= CEIL(air/10)*10 -5; 
  Air_grp4= CEIL(air/10)-10;
RUN;


proc sort data=air; 
    by Air_grp1; 
run; 

proc print data=air; 
run;





*in[44];

data air; 
     set sashelp.air; 
     format air_grp $15.; 
     
     if  air= . then air_grp= '00: Missing'; 
     else if air <220 then air_grp = '01: <220'; 
     else if air <275 then air_grp= '02: 220-274'; 
     else                  air_grp= '03: >=275' ; 
     
run; 

proc print data=air; 
run; 


