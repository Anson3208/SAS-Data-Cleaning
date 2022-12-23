libname Learn '/home/u62262551/BAN130-Programming for Analytics';
*Chapter 10 Programs;

*Programs to create data sets One, Two, and Three;
data Learn.One;
   length ID $ 3 Name $ 12;
   input ID Name Weight;
datalines;
7 Adams 210
1 Smith 190
2 Schneider 110
4 Gregory 90
;
data Learn.Two;
   length ID $ 3 Name $ 12;
   input ID Name Weight;
datalines;
9 Shea 120
3 O'Brien 180
5 Bessler 207
;
data Learn.Three;
   length ID $ 3 Gender $ 1. Name $ 12;
   Input ID Gender Name;
datalines;
10 M Horvath
15 F Stevens
20 M Brown
;

*Temporary SAS data sets EMPLOYEE and HOURS;
data Learn.Employee;
   length ID $ 3 Name $ 12;
   input ID Name;
datalines;
7 Adams
1 Smith
2 Schneider
4 Gregory
5 Washington
;

data Hours;
   length ID $ 3 JobClass $ 1;
   input ID 
         JobClass
         Hours;
datalines;
1 A 39
4 B 44
9 B 57
5 A 35
;

*Temporary SAS data sets BERT and ERNIE used in chapter 10;
data Bert;
   input ID $ X;
datalines;
123 90
222 95
333 100
;
data Learn.Ernie;
   input EmpNo $ Y;
datalines;
123 200
222 205
333 317
;

*Temporary SAS data sets DIVISION1 and DIVISION2 used in chapter 10;
Data Division1;
   input SS
         DOB : mmddyy10.
         Gender : $1.;
   format DOB mmddyy10.;
datalines;
111223333 11/14/1956 M
123456789 5/17/1946 F
987654321 4/1/1977 F
;

data Division2;
   input SS : $11.
         JobCode : $3.
         Salary : comma8.0;
datalines;
111-22-3333 A10 $45,123
123-45-6789 B5 $35,400
987-65-4321 A20 $87,900
;

*Program to create temporary SAS data set OSCAR used in chapter 10;
data Oscar;
   input ID $ Y;
datalines;
123  200
123  250
222  205
333  317
333  400
333  500
;

*Program to create temporary SAS data sets PRICES and
 NEW15DEC2017 used in chapter 10;
data Prices;
   Length ItemCode $ 3 Description $ 17;
   input ItemCode Description & Price;
datalines;
150 50 foot hose  19.95
175 75 foot hose  29.95
200 greeting card  1.99
204 25 lb. grass seed  18.88
208 40 lb. fertilizer  17.98
;

data New15Dec2017;
   Length ItemCode $ 3;
   input ItemCode Price;
datalines;
204 17.87
175 25.11
208 .
;

*10-1;

data Learn.Females;
   set Learn.Survey;
   where Gender = 'F';
run;

*10-2;
data Females;
   set Learn.Survey(keep=ID Gender Age Ques1-Ques5); /*Salary will be dropped*/
   where Gender = 'F';
run;




*10-3;
/*splitting dataset*/
data Males Females; /*output 2 dataset*/
   set Learn.Survey;
   if Gender = 'F' then output Females;
   else if Gender = 'M' then output Males;
run;

proc print data=Males;
run;
proc print data=Females;
run;


*10-4;
/*Appending two dataset*/
data Learn.One_Two;
   set Learn.One Learn.Two;
run;




*10-5;
/*Data one and three has different variable name, below is the example*/
data Learn.One_Three;
   set Learn.One Learn.Three;
run;
proc print data=Learn.One_Three;
run;

*10-5.1;
/*reverse the order of appending*/
data Learn.Three_One;
   set Learn.three Learn.one;
run;
proc print data=Learn.Three_One;
run;




*10-6;
/*Appending two dataset*/

proc sort data=Learn.One;
   by ID;
run;
proc sort data=Learn.Two;
   by ID;
run;
data Learn.Interleave;
   set Learn.One Learn.Two;
   by ID;
run;


*10-6.1;
/*without by ID meaning no sorting in the appending*/

proc sort data=Learn.One;
   by ID;
run;
proc sort data=Learn.Two;
   by ID;
run;
data Learn.Interleave_2;
   set Learn.One Learn.Two;
run;





*10-7;
proc means data=Learn.Blood noprint; /*Proc means will create statistics*/
   var Chol;							/*applying proc means on Chol*/
   output out = Means(keep=Chol_Mean)	/*do not want to produce all statistics, only means*/
          mean = / autoname;
run;

*10-7.1;
/*without keep*/
proc means data=Learn.Blood noprint; /*Proc means will create statistics*/
   var Chol;							/*applying proc means on Chol*/
   output out = Means	
          mean = / autoname;
run;




/*important example*/

data Percent;
   set Learn.Blood(keep=Subject Chol);	/*will only read subject and chol*/
   if _n_ = 1 then set Means;			
   /* want to add all variables within the means dataset*/
  /* if when you start writing the values of the varialbe include the new dataset Means*/
  /* you can merge 2 dataset using _n_=1 */
 /*_n_ will create a index for the rows starting to 1 */
   PercentChol = Chol / Chol_Mean;
   format PercentChol percent8.;
run;







*10-8;
proc sort data=Employee;
   by ID;
run;
proc sort data=Hours;
   by ID;
run;
data Combine;
   merge Employee Hours;
   by ID;
run;

*10-9;
data New;
   merge Employee(in=In_Employee)
         Hours   (in=In_Hours);
   by ID;  
   file print;
   put ID= In_Employee= In_Hours= Name= JobClass= Hours=;
run;

*10-10;
data Combine;
   merge Employee(in=In_Employee)
         Hours(in=In_Hours);
   by ID;
   if In_Employee and In_Hours;
run;

*10-11;
data In_Both 
   Missing_Name(drop = Name);
   merge Employee(in=In_Employee)
         Hours(in=In_Hours);
    by ID;
    if In_Employee and In_Hours then output In_Both;
    else if In_Hours and not In_Employee then 
       output Missing_Name;
run;

*10-12;
data Short;
   input x;
datalines;
1
2
;
data Long;
   input x;
datalines;
3
4
5
6
;
data New;
   set Short;
   output;
   set Long;
   output;
run;

*10-13;
data Sesame;
   merge Bert
         Ernie(rename=(EmpNo = ID));
   by ID;
run;

*10-14;
data Division1C;
   set Division1(rename=(SS = NumSS));
   SS = put(NumSS,ssn11.);
   drop NumSS;
run;
data Both_Divisions;
   ***Note: Both data sets already in order
      of BY variable;
   merge Division1C Division2;
   by SS;
run;

*10-15;
data Division2N;
   set Division2(rename=(SS = CharSS));
   SS = input(compress(CharSS,,'kd'),9.);
   ***Alternative:
   SS = input(CharSS,comma11.);
   drop CharSS;
run;

*10-16;
proc sort data=Prices;
   by ItemCode;
run;
proc sort data=New15Dec2017;
   by ItemCode;
run;
data Prices_15dec2017;
   update Prices New15Dec2017;
   by ItemCode;
run;