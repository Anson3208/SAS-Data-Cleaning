libname clean "/home/u62262551/BAN110-Data Preparation";

DATA CLEAN.PATIENTS;
	INFILE "/home/u62262551/BAN110-Data Preparation/Patients.txt" ;
	INPUT 	@1 PATNO $3.
			@4 GENDER $1.
			@5 VISIT MMDDYY10.
			@15 HR 3.
			@18 SBP 3.
			@21 DBP 3.
			@24 DX $3.
			@27 AE $1.;

LABEL 	PATNO = "Patient Number"
		GENDER = "Gender"
		VISIT = "Visit Date"
		HR = "Heart Rate"
		SBP = "Systolic Blood Pressure"
		DBP = "Diastolic Blood Pressure"
		DX = "Diagnosis Code"
		AE = "Adverse Event?";

FORMAT VISIT MMDDYY10.;

RUN;

proc sort data=Clean.Patients; 
   by Patno Visit;


proc print data=Clean.Patients; 
  			id Patno;
run;






*Chapter 3 Programs;

*3-1;

libname Learn '/home/u62262551/BAN130-Programming for Analytics';

/*Loading Text file*/
data Learn.Demographics;
  infile '/home/u62262551/BAN130-Programming for Analytics/Mydata.txt';
  input Gender $ Age Height Weight;
run;

title "Listing of data set Demographics";
proc print data=Learn.Demographics;
run;

*3-2;
/*Loading CSV file*/
data Learn.Demographics;
   infile '/home/u62262551/BAN130-Programming for Analytics/mydata.csv' dsd;
   input Gender $ Age Height Weight;
run;


*3-3;
/*Loading CSV file*/
filename Preston '/home/u62262551/BAN130-Programming for Analytics/mydata.csv';
data Learn.Demographics;
   infile Preston dsd;
   input Gender $ Age Height Weight;
run;

*3-4;
/*Loading dataline data*/
data Learn.demographic;
   input Gender $ Age Height Weight;
datalines;
M 50 68 155
F 23 60 101
M 65 72 220
F 35 65 133
M 15 71 166
;


*3-5;
/*Loading dataline data with CSV structure*/
data Learn.Demographics;
   infile datalines dsd;
   input Gender $ Age Height Weight;
datalines;
"M",50,68,155
"F",23,60,101
"M",65,72,220
"F",35,65,133
 "M",15,71,166
;



*3-6;
/*Load data with input statement range*/
data Learn.Financial;
   infile '/home/u62262551/BAN130-Programming for Analytics/bank.txt';
   input Subj     $   1-3
         DOB      $  4-13 
         Gender   $    14
         Balance    15-21;
run;

title "Listing of Financial";
proc print data=Learn.Financial;
run;

*3-7;
data Learn.Financial;
   infile '/home/u62262551/BAN130-Programming for Analytics/bank.txt';
   input @1  Subj         $3.
         @4  DOB    mmddyy10.
         @14 Gender       $1. 
         @15 Balance       7.;
run;
title "Listing of Financial";
proc print data=Learn.Financial;
run;

*3-8;
title "Listing of Financial";
proc print data=Learn.Financial;
   format DOB     mmddyy10. 
          Balance dollar11.2;
run;

*3-9;
title "Listing of Financial";
proc print data=Financial;
   format DOB     date9. 
          Balance dollar11.2;
run;

*3-10;
data List_Example;
   infile '/home/u62262551/BAN130-Programming for Analytics/List.csv' dsd;
   input Subj   :       $3.
         Name   :      $20.
         DOB    : mmddyy10.
         Salary :  dollar8.;
   format DOB date9. Salary dollar8.;
run;

*3-11;
data List_Example;
   informat Subj        $3.
            Name       $20.
            DOB   mmddyy10.
            Salary dollar8.;
   infile '/home/u62262551/BAN130-Programming for Analytics/List.csv' dsd;
   input Subj
         Name
         DOB
         Salary;
   format DOB date9. Salary dollar8.;
run;

*3-12;
data list_example;
   infile '/home/u62262551/BAN130-Programming for Analytics/list.txt';
   input Subj   :       $3.
         Name   &      $20.
         DOB    : mmddyy10.
         Salary :  dollar8.;
   format DOB date9. Salary dollar8.;
run;
