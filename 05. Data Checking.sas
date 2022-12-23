/*Data Cleaning checking - 1.Using Data Null*/

title "Listing of invalid patient numbers and data values";
data _null_;
    set clean.patients; 
     file print;
    *check patno; 
    if  missing(patno) then put 
        "patno missing obs" _n_; 
    if notdigit(patno) and not missing(patno) then
        patno= "is not digit"; 
    
    * check gender; 
    if  missing(gender) then put 
        patno= "has a missing value"; 
    else if gender not in ('M', 'F') then put 
        patno= "has an invalid gender value: " 
        gender= ; 
        
   *check Dx; 
   if missing(Dx) then put
       patno= "has a missing value for Dx"; 
    
    if notdigit(trim(Dx)) and not missing(Dx)
    then put Patno= "has invalid Dx value"
            Dx= ; 
   *check AE; 
   if missing(AE) then put 
        patno= "has a missing value for AE"; 
    
    if AE not in ('0', '1') then put 
        Patno= "has invalid AE value"
            AE= ; 
run;

/*Data Cleaning checking - 2.Using proc print*/
title "Using PROC Print to Identify Data Errors";

proc print data=Clean.patients; 
    id Patno; 
    var Gender; 
    var AE; 
    where notdigit(Patno) or 
        gender not in ('M', 'F') or 
        AE not in ('0', '1');
                   
run;



/*Data Cleaning checking - 3.Using Formats to identify data errors*/
title "Listing Invalid Values of Gender";

* define a gender format; 
proc format; 
 value $gender_check 'M', 'F'= 'valid'
                       ' '   = ' missing'
                       other = 'Error'; 
run; 

* use proc freq to compute frequencies on the formatted values; 
proc freq data=Clean.patients; 
    tables Gender / nocum nopercent missing; 
    format Gender $gender_check.; 
run; 




/*Data Cleaning checking - 3.1.Using Formats to identify data errors*/
title "Listing Invalid Values of Gender";
proc format;
   value $Gender_Check 'M','F' = 'Valid'
                       ' '     = 'Missing'
                       other   = 'Error';
run;

data _null_; 
    set clean.patients (keep=patno Gender); 
    file print; 
    if put(Gender, $gender_check.) = 'Missing' then 
    put 
    " Missing value for Gender for patient" Patno ; 
    else if put(Gender, $gender_check.) = 'Error' then 
    put 
        "missing value of gender=" Gender "for patient" patno; 
run; 


/*Data Cleaning checking - 4.Checking Missing Character Values*/
title "Checking Missing Character Values";

Proc format;
    value $count_missing  ' '= 'missing'
                            other= 'Nonmissing'; 
run; 

proc freq data=Clean.patients; 
 tables _character_ / nocum missing; 
 format _character_  $count_missing. ; 
 run; 


/*Data Cleaning checking - 5.Checking Missing Numerical Values*/
title "Checking Missing numerical Values";
proc means data=learn.new_exam2 nmiss;
run;
title;
