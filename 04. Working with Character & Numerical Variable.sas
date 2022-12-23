/*Convert all character to upper case*/
data Clean.Patients_Caps;
   set Clean.Patients;
   array Chars{*} _character_; *1;
   do i = 1 to dim(Chars); *2;
      Chars[i] = upcase(Chars[i]); *3;
   end;
   drop i;
run;


/*Given the patients dataset, define a format that converts gender to numerical formatted values as 0 for male and 1 for female.
use proc print to display the dataset*/
DATA PATIENTS_NUM;
	SET clean.patients ;
RUN;

proc format;
    value gender1 1= 'MALE'
                0= 'FEMALE';                
RUN;



/*Given the patients dataset, define a format that converts gender to numerical formatted values as 0 for male and 1 for female.
use proc print to display the dataset*/
data pat_num; 
    set clean.patients;
    
proc format;
    value $gender_num  	'M'=1
    					'F'=0;
Proc print data=pat_num;
format gender $gender_num.;               
RUN;




/*create day, month, year columns based on visit
use proc print to display the dataset*/
DATA date_apart;
	set clean.patients ;
DAY = DAY(VISIT);
MON = MONTH(VISIT);
YEAR = YEAR(VISIT); 
HR_part = substr (dx,1,1);
run;

proc print data=date_apart;
run;



/*Create a new variable named productSubgroup based on extracting the second and third digit of the product code.*/
data codes;
    set codes; 
    productmainGroup2= SUBSTR(ProductCode, 2,1) ;
    productmainGroup3= SUBSTR(ProductCode, 3,1) ; 
run; 

proc print data=codes; 
run; 



/*Create an indicator.*/
data codes; 
    set codes; 
    IF ProductMainGroup = '2' THEN ProductMainGroupMF = 1;
    ELSE ProductMainGroupMF =0;
run; 

proc print data=codes; 
run;



/*Converting between Character and Numeric Formats*/
data gender_example_new; 
    set gender_example; 
    gender_char=put(gender, 3.);
    gender_char_num= input(gender_char, 3.); 
run; 


/*Replace N/A in Year column to 0*/
data learn.vgsales_clean;
	set learn.vgsales;
	Year=tranwrd(Year, "N/A", 0); 
run;
