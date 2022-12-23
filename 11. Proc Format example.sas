*Chapter 5 Programs;

*5-1;
libname Learn '/home/u62262551/BAN130-Programming for Analytics';
data Learn.Test_Scores;
   length ID $ 3 Name $ 15;
   input ID $ Score1-Score3 Name $;
   label ID = 'Student ID'
         Score1 = 'Math Score'
         Score2 = 'Science Score'
         Score3 = 'English Score';
datalines;
1 90 95 98 Jan 
2 78 77 99 Preston
3 88 91 92 Russell
;
title "Descriptive Statistics for Student Scores";
proc means data=Learn.Test_Scores;
run;

*5-2;
proc format;
   value $Gender 'M' = 'Male'
                 'F' = 'Female'
                 ' ' = 'Not entered'
               other = 'Miscoded';
   value Age low-29  = 'Less than 30'
             30-50   = '30 to 50'
             51-high = '51+';
   value $Likert '1' = 'Str Disagree'
                 '2' = 'Disagree'
                 '3' = 'No Opinion'
                 '4' = 'Agree'
                 '5' = 'Str Agree';
run;

*5-3;
title "Data Set SURVEY with Formatted Values";
proc print data=Learn.Survey;
   id ID;
   var Gender Age Salary Ques1-Ques5;
   format Gender      $Gender.
          Age         Age.
          Ques1-Ques5 $Likert.
          Salary      Dollar11.2;
run;

*5-4;
proc format;
   value $Three 1,2   = 'Disagreement'
                3     = 'No opinion'
                4,5   = 'Agreement';
run;

*5-5;
title "Question Frequencies Using the Three Format";
proc freq data=Learn.Survey;
   tables Ques1-Ques5;
   format Ques1-Ques5 $Three.;
run;

*5-6;
libname Myfmts 'C:\books\learning';
proc format library=Myfmts;
   value $Gender 'M' = 'Male'
                 'F' = 'Female'
                 ' ' = 'Not entered'
               other = 'Miscoded';
   value Age low-29  = 'Less than 30'
             30-50   = '30 to 50'
             51-high = '51+';
   value $Likert '1' = 'Strongly disagree'
                 '2' = 'Disagree'
                 '3' = 'No opinion'
                 '4' = 'Agree'
                 '5' = 'Strongly agree';
run;

*5-7;
libname Learn 'C:\books\learning';
libname Myfmts 'C:\books\learning';
options fmtsearch=(Myfmts);
data Learn.Survey;
   infile 'C:\books\learning\Survey.txt' pad;
   input ID : $3.
         Gender : $1.
         Age
         Salary
         (Ques1-Ques5)(: $1.);
   format Gender      $Gender.
          Age         Age.
          Ques1-Ques5 $Likert.
          Salary      Dollar10.0;
   label ID     = 'Subject ID'
         Gender = 'Gender'
         Age    = 'Age as of 1/1/2006'
         Salary = 'Yearly Salary'
         Ques1  = 'The governor is doing a good job?'
         Ques2  = 'The property tax should be lowered'
         Ques3  = 'Guns should be banned'
         Ques4  = 'Expand the Green Acre program'
         Ques5  = 'The school needs to be expanded';
run;

*5-8;
title "Data set Survey";
proc contents data=learn.Survey varnum;
run;

*5-9;
libname Learn 'C:\books\learning';
libname Myfmts 'C:\books\learning';
options fmtsearch=(Myfmts);
 title "Using User-defined Formats";
proc freq data=Learn.Survey;
   tables Ques1-Ques5;
run;

*5-10;
title "Format Definitions in the Myfmts Library";
proc format library=Myfmts fmtlib;
   select Age $Likert $Gender;
run;

*5-11;
proc format library=Myfmts;
   select Age $Likert;
run;