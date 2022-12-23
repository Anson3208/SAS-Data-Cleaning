/*Ban130 Project*/

/*1.	Data Import
This phase requires you to import the data from the provided excel file into SAS using Proc Import.
Product sheet in excel file should be imported as Product dataset in SAS.
SalesOrderDetail sheet in excel file should be imported as SalesOrderDetail dataset in SAS.
*/

libname ban130pj '/home/u62262551/BAN130-Programming for Analytics/Project';

proc import datafile = '/home/u62262551/BAN130-Programming for Analytics/Project/AdventureWorks.xlsx'
out= ban130pj.AdventureWorks dbms= xlsx;
run;


/*2.	Data Cleaning*/
/*Product_Clean
•	Create a Product_Clean dataset from Product dataset by bringing in only ProductID, Name, ProductNumber, Color and ListPrice
•	All the missing values in Color column should be replaced by ‘NA’
•	ListPrice column should be numeric (final column name should be ListPrice) and format should have a dollar sign with 2 decimal places
•	No un-necessary columns should be part of the Product_Clean dataset. Please see below expected output.
*/

proc contents data=ban130pj.AdventureWorks;
run;

proc print data=ban130pj.AdventureWorks (obs=10);
run;



/*keep required column and replace missing value with NA*/
data ban130pj.Product_Clean;
set ban130pj.AdventureWorks (keep=ProductID Name ProductNumber Color ListPrice);
   array variablesOfcolor{*} $color;
   do i =1 to dim (variablesOfcolor);
      if variablesOfcolor{i} = ' ' then 
      variablesOfcolor{i} ='NA';
   end;
   drop i;
run;

/*Convert List price to numerical*/
data ban130pj.Product_Clean;
set ban130pj.Product_Clean;
   ListPrice_num = input (ListPrice,9.);
   format ListPrice_num dollar10.2 ;
   DROP ListPrice;
   rename ListPrice_num = ListPrice;
run;


/*
SalesOrderDetail_Clean:
•	Create SalesOrderDetail_Clean dataset from SalesOrderDetail dataset by bringing in only SalesOrderID SalesOrderDetailID OrderQty ProductID UnitPrice LineTotal and ModifiedDate
•	ModifiedDate should be numeric with column name ModifiedDate
•	UnitPrice should be numeric with column name UnitPrice
•	LineTotal should be numeric with column name LineTotal
•	OrderQty should be numeric with column name OrderQty
•	Include date for year 2013 and 2014 in ModifiedDate only
•	ModifiedDate should be mmddyy10. Format
•	UnitPrice and LineTotal should have a dollar with 2 decimal places
•	No un-necessary columns should be part of the SalesOrderDetail_Clean dataset. Please see expected output below:
*/



/*Create SalesOrderDetail_Clean dataset*/
proc import datafile = '/home/u62262551/BAN130-Programming for Analytics/Project/AdventureWorks.xlsx'
out=ban130pj.SalesOrderDetail_temp dbms= xlsx;
sheet= 'SalesOrderDetail';
run;
data ban130pj.SalesOrderDetail_Clean;
	set ban130pj.SalesOrderDetail_temp (keep=SalesOrderID SalesOrderDetailID OrderQty ProductID UnitPrice LineTotal ModifiedDate);
run;



/*ModifiedDate should be numeric with column name ModifiedDate
ModifiedDate should be mmddyy10. Format*/
data ban130pj.SalesOrderDetail_Clean;
	set ban130pj.SalesOrderDetail_Clean;
	ModifiedDate_num6 = input (ModifiedDate, yymmdd10.);
	format ModifiedDate_num6 mmddyy10.;
	drop ModifiedDate;
	rename ModifiedDate_num6 = ModifiedDate;
run;



/*UnitPrice should be numeric with column name UnitPrice
LineTotal should be numeric with column name LineTotal
OrderQty should be numeric with column name OrderQty
*/
data ban130pj.SalesOrderDetail_Clean;
	set ban130pj.SalesOrderDetail_Clean;
	UnitPrice_num = input (UnitPrice, 8.);
	LineTotal_num = input (LineTotal, 10.);
	OrderQty_num = input(OrderQty, 10.);
	drop UnitPrice LineTotal OrderQty;
	rename UnitPrice_num = UnitPrice;
	rename LineTotal_num = LineTotal;
	rename OrderQty_num = OrderQty;
run;



/*Include date for year 2013 and 2014 in ModifiedDate only*/
data ban130pj.SalesOrderDetail_Clean;
	set ban130pj.SalesOrderDetail_Clean	(where = (ModifiedDate between '01Jan2013'd and '31Dec2014'd));
run;



/*UnitPrice and LineTotal should have a dollar with 2 decimal places*/
data ban130pj.SalesOrderDetail_Clean;
	set ban130pj.SalesOrderDetail_Clean;
	format 	UnitPrice dollar10.2
			LineTotal dollar10.2;
run;



/*3.	Joining and Merging
•	This phase requires you to join / merge your datasets to create a dataset for analysis.
SalesDetails:
•	Create a SalesDetails dataset by joining SalesOrderDetail_Clean and Product_Clean datasets
•	Use ProductID column for joining the tables
•	SalesDetails table should contain all the observations from SalesOrderDetail_Clean table along with columns from Product_Clean
•	Drop SalesOrderID SalesOrderDetailID ProductNumber and ListPrice from the result dataset. Please see expected output below:
*/

proc sort data= ban130pj.SalesOrderDetail_Clean; by productID; run;
proc sort data= ban130pj.Product_Clean; by productID; run;

data ban130pj.SalesDetails;
merge ban130pj.SalesOrderDetail_Clean(in=Q1) ban130pj.Product_Clean(in=Q2);
by productID;
if (q1=1 and q2=1) or (q1=1 and q2=0);
drop SalesOrderID SalesOrderDetailID ProductNumber ListPrice;
run;


/*SalesAnalysis:
•	Create a SalesAnalysis dataset from SalesDetails dataset that groups all the products by ProductID (hint: research on obtaining a total for each by group in SAS)
•	Create a SubTotal column in SalesAnalysis that provides an aggregate sum of each product by its ProductID.
•	SubTotal column should have a dollar and 2 decimal places. 
•	Please see below expected output:
*/

proc sort data=ban130pj.SalesDetails out=ban130pj.SalesAnalysis;
by ProductID;
run;

data ban130pj.SalesAnalysis;
   set ban130pj.SalesAnalysis;
   by ProductID;
   if First.ProductID then SubTotal=0;
   SubTotal + LineTotal;
   if First.ProductID then SubOrderTotal=0;
	SubOrderTotal + OrderQty;
	if Last.ProductID then output;
	
   format SubTotal dollar10.2;
run;

/*4.	Data Analysis
•	This phase requires you to analyze the SalesAnalysis for Adventure Works and answer the following 5 questions by generating reports using Proc Print for each of the 5 questions:
	How many Red color Helmets are sold in 2013 and 2014?
	How many items sold in 2013 and 2014 have a Multi color?
	What is the combined Sales total for all the helmets sold in 2013 and 2014?
	How many Yellow Color Touring-1000 where sold in 2013 and 2014?
	What was the total sales in 2013 and 2014?
•	Create at least one chart in SAS for any analysis of your choice from SalesAnalysis dataset (this analysis can be of your choice and not necessarily from above 5 questions.)
*/


/*	How many Red color Helmets are sold in 2013 and 2014?
Answer: 4657
*/
proc print data=ban130pj.SalesAnalysis Grandtotal_label='Total';;
sum SubTotal SubOrderTotal ;
where Name like '%Helmet%' and Color = 'Red';
run;


/*	How many items sold in 2013 and 2014 have a Multi color?
Answer: 15009
*/
proc print data=ban130pj.SalesAnalysis Grandtotal_label='Total';
sum SubTotal SubOrderTotal ;
where Color = 'Multi';
run;


/*	What is the combined Sales total for all the helmets sold in 2013 and 2014?
Answer: $381800.34
*/
proc print data=ban130pj.SalesAnalysis Grandtotal_label='Total';
sum SubTotal SubOrderTotal ;
where Name like '%Helmet%';
run;


/*	How many Yellow Color Touring-1000 where sold in 2013 and 2014?
Answer: 3168
*/
proc print data=ban130pj.SalesAnalysis Grandtotal_label='Total';
sum SubTotal SubOrderTotal ;
where Name like '%Touring-1000%'and Color = 'Yellow';
run;


/*	What was the total sales in 2013 and 2014?
Answer: $63680407.9
*/
proc print data=ban130pj.SalesAnalysis Grandtotal_label='Total';
sum SubTotal SubOrderTotal ;
run;

proc report data=ban130pj.SalesAnalysis;
columns SubTotal SubOrderTotal;
run;


/*Create a bar chart to show SubTotal by Color*/
title "Total Sales by color";
proc gchart data=ban130pj.SalesAnalysis;
format Subtotal dollar10.;
vbar color / type=sum sumvar=Subtotal;
run;
quit;



