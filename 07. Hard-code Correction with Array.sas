/*Chapter 12
1. Hard coding corrections
For small data sets with only a few corrections to be made,
you might consider hard coding your corrections.
 */


libname Clean '~'; 
proc print data=Clean.patients; 
run;

data clean.patients; 
    set clean.patients; 
    * file print; 
    array Char_Vars[3] Patno Gender Dx; 
    do i =1 to 3; 
        Char_vars[i]= upcase (Char_vars[i]);
    end; 
    
    if patno='003' then SBP=110; 
    else if patno='011' then Dx='530'; 
    else if Patno='023' then do;
        SBP=146;
        DBP=98; 
        end; 
    drop i; 
run;





/* in21. Program 12.2: Describing Named Input*/

data Named; 
    length Char $3; 
    informat Date mmddyy10.; 
    input x=
          y=
          char=
          date= ; 
datalines;
x=3 y=4 Char=abc Date=10/21/2010 
y=7
date=11/12/2016 Char=xyz x=9
;

proc print data=Named; 
run; 


/* in26. Program 9-4: Demonstrating How UPDATE Works*/

data inventory;
    length PartNo $ 3;
    input PartNo $ Quantity Price;
datalines;
133 200 10.99
198 105 30.00
933 45 59.95
;

proc print data=inventory;
run;


data transaction;
    length PartNo $ 3;
    input Partno=
         Quantity=
          Price=;

datalines;
PartNo=133 Quantity=195
PartNo=933 Quantity=40 Price=69.95
;

proc print data=transaction;
run;


proc sort data=inventory;
by PartNo;
run; 

proc sort data=transaction;
by PartNo;
run; 


data inventory_19Oct2022;
    update inventory transaction;
    by partno; 
run; 


proc print data=inventory;
run;
proc print data=transaction;
run;
proc print data=inventory_19Oct2022;
run;







/* in2. 4.1. Using PROC STANDARD for Replacement: Imputation using the mean*/
/*replace is by default replace with mean value from the dataset*/
DATA TEST; 
    INPUT AGE @@;
    CARDS;
    12 60 . 24 . 50 48 34 .
    ;
 RUN;

proc print data=TEST; 
run;


proc standard data=test replace print out=test_imputed;
    var age;
run; 

proc print data=test_imputed;
run;

/*test without print*/

proc standard data=test replace out=est_imputed_2;
    var age;
run; 

proc print data=test_imputed_2;
run;



/*4.2. Standarization: imputation using z score*/

proc standard data=test replace mean=0 std=1 print out=test_zscore;
    var age;
run; 

proc print data=test_zscore;
run;




/*5. Searching for specific numeric value*/


***Create test data set;
data Test;
   input X Y A $ X1-X3 Z $;
datalines;
1 2 X 3 4 5 Y
2 999 Y 999 1 999 J
999 999 R 999 999 999 X
1 2 3 4 5 6 7
;

proc print data=test; 
run;


***Program to detect the specified values;
title "Looking for Values of 999 in Data Set Test";
data _null_;
   set Test;
   file print;
   array Nums[*] _numeric_;
   length Varname $ 32;
   do iii = 1 to dim(Nums);
      if Nums[iii] = 999 then do;
         Varname = vname(Nums[iii]);
         put "Value of 999 found for variable " Varname
             "in observation " _n_;
      end;
   end;
   drop iii;
run;



/*6. Converting Values Such as 999 to a SAS Missing Value*/

data Set_999_to_Missing;
   set Test;
   array Nums[*] _numeric_;
   do iii = 1 to dim(Nums);
      if Nums[iii] = 999 then Nums[iii] = .;
   end;
   drop iii;
run;

proc print data=Set_999_to_Missing; 
run;