/*week 12 Chapter 8: Some PROC SQL Solutions to Data Cleaning*/

libname Clean '~'; 



/*2. Checking for Invalid Character Values
This example uses the SAS data set PATIENTS (see the Appendix for the program and data file), and look for invalid values for Gender, DX, and AE (ignoring missing values).
Program 8-2: Using PROC SQL to Look for Invalid Character Values*/

***Checking for invalid character data;
title "Checking for Invalid Character Data";
proc sql;
  select Patno,
     Gender,
     DX,
     AE
  from clean.patients
  where Gender not in ('M','F',' ') or
      notdigit(trim(DX))and not missing(DX) or
      AE not in ('0','1',' ');
quit;


/*3. Checking for Outliers¶
Program 8-3: Program 8-3 Using SQL to Check for Out-of-Range Numeric Values*/

title "Checking for out-of-range numeric values";
proc sql;
   select Patno,
           HR,
          SBP,
           DBP
   from clean.patients
   where HR  not between 40 and 100 and HR is not missing     or
         SBP not between 80 and 200 and SBP is not missing    or
         DBP not between 60 and 120 and DBP is not missing;
quit;



/*4. Checking a Range Using an Algorithm Based on the Standard Deviation¶
Program 8-4: Using SQL to Check for Out-of-Range Values Based on the Standard Deviation*/

title "Data values beyond two standard deviations";
proc sql;
   select Patno,
          SBP
   from clean.patients
    having SBP not between mean(SBP) - 2 * std(SBP) and
      mean(SBP) + 2 * std(SBP)                      and
      SBP is not missing;
quit;

/*HAVING in SQL is doing the same as WHERE but it can be used in Aggregation while WHERE not*/



/*5. Checking for Missing Values
It's particularly easy to use PROC SQL to check for missing values. The WHERE clause IS MISSING can be used for both character and numeric variables. The simple query shown in Program 8-5 checks the data set for all character and numeric missing values and prints out any observation that contains a missing value for one or more variables.

Program 8-5: Using SQL to List Missing Values*/

title "Observations with missing values";
proc sql;
   select *
   from clean.patients
   where Patno   is missing or
         Gender  is missing  or
         Visit    is missing or
         HR       is missing or
         SBP      is missing or
         DBP      is missing or
         DX      is missing or
         AE      is missing;
quit;




/*6. Range Checking for Dates
You can also use PROC SQL to check for dates that are out of range. Suppose you want a list of all patients in the PATIENTS data set that have nonmissing visit dates before June 1, 1998 or after October 15, 1999.

Program 8-6: Using SQL to Perform Range Checks on Dates*/

title "Dates before June 1, 1998 or after October 15, 1999";
proc sql;
   select Patno,
          Visit
   from clean.patients
   where Visit not between '01jun1998'd and '15oct1999'd and
         Visit is not missing;
quit;




/*7. Checking for Duplicates
If you have a GROUP BY clause in your PROC SQL and follow it with a COUNT function, you can count the frequency of each level of the GROUP BY variable. If you choose patient number (Patno) as the grouping variable, the COUNT function will tell you how many observations there are per patient. Remember to use a HAVING clause when you use summary functions such as COUNT.

7.1. Using SQL to List Duplicates
in Program 8-7, you are telling PROC SQL to list any duplicate patient numbers. Note that multiple missing patient numbers will not appear in the listing because the COUNT function returns a frequency count only for nonmissing values. Here are the results:

Program 8-7: Using SQL to List Duplicate Patient Numbers*/

title "Duplicate Patient Numbers";
proc sql;
   select Patno,
          Visit
      from clean.patients
      group by Patno
      having count(Patno) gt 1;
quit;



/*7.2. Eliminating Duplicates by Using PROC SORT¶
Suppose you have a data set where each patient is supposed to be represented by a single observation. To demonstrate what happens when you have multiple observations with the same ID, some duplicates in the PATIENTS data set were included on purpose. Observations with duplicate ID numbers are shown next.

In the following code, Notice that two options, OUT= and NODUPKEY, are used here. The OUT= option is used to create the new data set SINGLE, leaving the original data set PATIENTS unchanged*/

proc sort data=clean.patients out=single nodupkey;
   by Patno;
run;

title "Data Set  - Duplicated ID's  Removed from PATIENTS";
proc print data=single;
    id Patno;
run;




/*The option NODUPRECS also deletes duplicates, but only for two observations where all the variables have identical values. The main limitation is that the NODUPRECS option only removes successive duplicates. One way to guarantee that all duplicates are removed is to use PROC SQL with the DISTINCT keyword like this:*/

data multiple;
   input Patno $ x y;
datalines;
001 1 2
006 1 2
009 1 2
001 3 4
001 1 2
009 1 2
001 1 2
;

proc sql;
   create table single as
   select distinct *
   from multiple;
quit;

proc print data=single; 
run;

proc sql;
   select x
   from multiple;
quit;







