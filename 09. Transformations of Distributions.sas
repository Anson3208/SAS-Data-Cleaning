/* Week 11 Chapter 5-Automatic Outlier Detection for Number Data*/
/*16.6: Transformations of Distributions
In right-skewed (also known as positive skewed) distributions extreme values or outliers are likely to occur. The minimum for many variables is naturally bounded at zero—for example, at all count variables or measurements that logically can start only at zero. Examples of variables that usually have highly skewed distributions and outliers in the upper values are laboratory values, number of events, minutes of mobile phone usage, claim amounts in insurance, or loan amounts in banking.

The presence of skewed distribution or outlier influences has an effect on the analysis because some types of analyses accept only normal (or close to normal) distribution.

titlesrc: http://analystnotes.com/graph/quan/SS02SBloso1.gif

In order to achieve a close to normal distribution of values you must

Perform a transformation to maximize the normality of a distribution.
Filter outliers or replace them with other values.
Note that in some types of analysis a filtering of outliers is not possible, because it is not allowed to leave out certain observations. For example, in medical statistics where the variability of values can be high due to biological variability, observations (patients) must not be excluded from the analysis only because of their extreme values.

16.6.1 Transformations to Maximize the Normality
log transformation : The most frequently used transformation to transform a right-skewed distribution is the log transformation . Note that the logarithm is defined only for positive values. In the case of negative values, a constant has to be added to the data in order to make them all positive.
root transformation : Another transformation that normalizes data is the root transformation .
Let's look at the following example where we transform a skewed variable:*/



libname Clean '~'; 

DATA skewed;
INPUT a @@;
CARDS;
1 0 -1 20 4 60 8 50 2 4 7 4 2 1
;

RUN;


/*Analysis
Analyzing the distribution can be done as follows.

First we calculate the minimum for each variable in order to see whether we have to add a constant for the logarithm in order to have positive values:

PROC MEANS DATA = skewed MIN; RUN;

Second we analyze the distribution with PROC UNIVARIATE and use ODS SELECT to display only the tests for normality:

ODS SELECT TestsForNormality Plots;
 PROC UNIVARIATE DATA = skewed NORMAL PLOT; RUN;
ODS SELECT ALL;*/

PROC means data=skewed MIN;
RUN;

proc univariate data=skewed normal plot; 
run;


proc sgplot data=skewed; 
histogram a; 
run; 
/* data is not normal distributed*/


/*Tranformation of distribution
We apply a log and a root transformation to the data. We see from this the minimum for variable A is -1; therefore, we add a constant of 2 before applying the log and the root transformation:*/

Data skewed; 
SET skewed;
 log_a = log(a+2); 
 /*log function is natural log based on e, normal log 10 is another function*/
 /*log can only applied to positive number, added 2 because the minimum value is -1*/
 root4_a = (a+2) ** 0.25;
 root2_a = (a+2) ** 0.5; /*check*/
RUN;

/*showing the charts to check which transformation is the best*/
ODS select TestsForNormality Plots;
PROC UNIVARIATE DATA = skewed NORMAL PLOT; 
 RUN;
 ODS select All;

/*log is the best transformation that have skewness closer to 0 and 
kurtosis closer to 3, and
have closer dot line in the plot*/