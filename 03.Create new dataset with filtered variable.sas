/*Create new dataset with filtered variable*/
/*Create new dataset*/
data Check_Char;
   set Clean.Patients(keep=Patno Gender);  *2; 
run; 

/*Check frequency table*/
title "Frequencies for Gender";
proc freq data=Check_Char; *3; 
   tables gender  / nocum nopercent; *4; 
run;
