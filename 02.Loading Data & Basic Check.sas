*Chapter 1 Problems;

*Replace the line below with your folder name;
libname Learn '/home/u62262551/BAN130-Programming for Analytics';
options fmtsearch=(learn);

*1-1;
*SAS Program to read the Veggie.txt data file and to produce
 several reports;
options nonumber nodate;


data Learn.Veg;
   infile "/home/u62262551/BAN130-Programming for Analytics/veggies.txt";
   input Name $ Code $ Days Number Price; 
   CostPerSeed = Price / Number;
   PricePerDays = Price / Days;
run;


title "List of the Raw Data";
proc print data=Learn.Veg;
run;


title "Frequency Distribution of Vegetable Names";
proc freq data=Learn.Veg;
   tables Name;
run;
 
 
title "Average Cost of Seeds";
proc means data=Veg;
   var CostPerSeed;
run;