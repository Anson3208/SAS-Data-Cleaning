/* Week 10 Chapter 5-Automatic Outlier Detection for Number Data*/

libname Clean '~'; 

*Use PROC MEANS to Output means and standard deviations to a data set;
proc means data=Clean.Patients noprint ;
   var HR;
   *where HR not in (900); 
   output out=Mean_Std(drop=_type_ _freq_)
          mean=
          std= / autoname;
run;

title "Outliers for HR Based on 2 Standard Deviations";
data _null_;
   file print;
   set Clean.Patients(keep=Patno HR );
   ***bring in the means and standard deviations;
   if _n_ = 1 then set Mean_Std;
   if HR lt HR_Mean - 2*HR_StdDev and not missing(HR)
      or HR gt HR_Mean + 2*HR_StdDev then put Patno= HR=;
      /*2*stdDev is to calculate 95% of normal distribution*/
run;



/*check outlier for DBP*/
proc means data=Clean.Patients noprint ;
   var DBP;
   output out=Mean_Std(drop=_type_ _freq_)
          mean=
          std= / autoname;
run;

proc print data=Mean_Std;
run;


title "Outliers for DBP Based on 2 Standard Deviations";
data _null_;
   file print;
   set Clean.Patients(keep=Patno DBP );
   ***bring in the means and standard deviations;
   if _n_ = 1 then set Mean_Std;
   if DBP lt DBP_Mean - 2*DBP_StdDev and not missing(HR)
      or DBP gt DBP_Mean + 2*DBP_StdDev then put Patno= DBP=;
      /*2*stdDev is to calculate 95% of normal distribution*/
run;




/*Program 5.2: Computing Trimmed Statistics*/
proc rank data=Clean.Patients(keep=Patno HR) out=Tmp groups=10;
   var HR;
   ranks Rank_HR;
run;

proc sort data=tmp; 
by rank_HR; 
run; 

proc print data=Tmp ; 
run;



/*in[4]*/
proc means data=Tmp noprint;
   where Rank_HR not in (0,9); *Trimming the top and bottom 10%;
   var HR;
   output out=Mean_Std_Trimmed(drop=_type_ _freq_)
          mean=
          std= / autoname;
run;
title 'mean and std after trimming'; 
proc print data=Mean_Std_Trimmed; 
run; 



title "Outliers for HR Based on Trimmed Statistics";
data _null_;
   file print;
   set Clean.Patients(keep=Patno HR);
   ***bring in the means and standard deviations;
   if _n_ = 1 then set Mean_Std_Trimmed;
   *Adjust the standard deviation;
   Mult = 1.49;
   if HR lt HR_Mean - 2*Mult*HR_StdDev and not missing(HR)
      or HR gt HR_Mean + 2*Mult*HR_StdDev then put Patno= HR=;
run;



/*Program 5.4: Creating Trimmed Statistics Using PROC UNIVARIATE with the TRIM= Option*/

ods output TrimmedMeans=Trimmed (keep=VarName Mean Stdmean DF);

title;
proc univariate data=Clean.Patients trim=.1;
   var HR SBP DBP;
run;

ods output close;



/*Program 2-25: Using ODS to Capture Trimmed Statistics from PROC UNIVARIATE*/
title; 
proc print data=TRIMMED; 
run;



/*Program 5.4: (continued)*/
data Restructure;
   set Clean.Patients;
   length VarName $ 32;
   array Vars[*] HR SBP DBP;
   do i = 1 to dim(Vars);
      VarName = vname(Vars[i]);
      Value = Vars[i];
      output;
   end;
   keep Patno VarName Value;
run;

proc print data=Restructure; 
run;




/*Program 5.4: (continued)*/
proc sort data=Trimmed;
   by VarName;
run;

proc sort data=Restructure;
   by VarName;
run;

data Outliers;
   merge Restructure Trimmed;
   by VarName;
   
   Std = StdMean*sqrt(DF + 1);

   if Value lt Mean - 2*Std and not
   missing(Value) then do;
      Reason = 'Low  ';
      output;
   end;

   else if Value gt Mean + 2*Std then do;
      Reason = 'High';
      output;
   end;
run;



proc sort data=outliers; 
    by patno; 
run; 

title "Outliers based on trimmed Statistics"; 
proc print data=outliers; 
    id patno; 
    var varname value reason; 
run;




/*Presenting a Macro Based on Trimmed Statistics ( optional)¶*/

*Method using automatic outlier detection;
%macro Auto_Outliers  /*defining the parameter of the macro*/
(
   Dsn=,      /* Data set name                        */
   ID=,       /* Name of ID variable                  */
   Var_list=, /* List of variables to check           */
              /* separate names with spaces           */
   Trim=.1,   /* Integer 0 to n = number to trim      */
              /* from each tail; if between 0 and .5, */
              /* proportion to trim in each tail      */
   N_sd=2     /* Number of standard deviations        */);

   ods listing close;
   ods output TrimmedMeans=Trimmed(keep=VarName Mean Stdmean DF);
   proc univariate data=&Dsn trim=&Trim;
     var &Var_list;
   run;
   ods output close;

   data Restructure;
      set &Dsn;
      length VarName $ 32;
      array Vars[*] &Var_list;
      do i = 1 to dim(Vars);
         VarName = vname(Vars[i]);
         Value = Vars[i];
         output;
      end;
      keep &ID VarName Value;
   run;

   proc sort data=Trimmed;
      by VarName;
   run;

   proc sort data=restructure;
      by VarName;
   run;

   data Outliers;
      merge Restructure Trimmed;
      by VarName;
      Std = StdMean*sqrt(DF + 1);
      if Value lt Mean - &N_sd*Std and not missing(Value)
         then do;
            Reason = 'Low  ';
            output;
         end;
      else if Value gt Mean + &N_sd*Std
         then do;
         Reason = 'High';
         output;
      end;
   run;
   proc sort data=Outliers;
      by &ID;
   run;

   ods listing;
   title "Outliers Based on Trimmed Statistics";
   proc print data=Outliers;
      id &ID;
      var VarName Value Reason;
   run;

   proc datasets nolist library=work;
      delete Trimmed;
      delete Restructure;
   run;
   quit;
%mend Auto_Outliers;



/*recall the macro*/
 %Auto_Outliers(Dsn=Clean.Patients,
                   Id=Patno,
                   Var_List=HR SBP DBP,
                   Trim=.1,
                   N_Sd=2)



/*Program 5.6: Using PROC SGPLOT to Create a Box Plot*/
*Using PROC SGPLOT to Create a Box Plot for SBP;
title "Using PROC SGPLOT to Create a Box Plot";
proc sgplot data=clean.Patients(keep=Patno SBP);
   hbox SBP;
run;



/*Program 5.7: Creating a Box Plot for SBP for Each Level of Gender*/
*Using PROC SGPLOT to Create a Box Plot for SBP;
title "Using PROC SGPLOT to Create a Box Plot";
proc sgplot data=clean.Patients(keep=Patno SBP Gender
                                where=(Gender in ('F','M')));
   hbox SBP / category=Gender;
run;





/*Program 5.8: Detecting Outliers Using the Interquartile Range*/
title "Outliers Based on Interquartile Range";
proc means data=Clean.Patients noprint;
   var HR;
   output out=Tmp
          Q1=
          Q3=
          QRange= / autoname;
run;

data _null_;
   file print;
   set Clean.Patients(keep=Patno HR);
   if _n_ = 1 then set Tmp;
   if HR le HR_Q1 - 1.5*HR_QRange and not missing(HR) or
      HR ge HR_Q3 + 1.5*HR_QRange then
      put "Possible Outlier for patient " Patno "Value of HR is " HR;
run;
