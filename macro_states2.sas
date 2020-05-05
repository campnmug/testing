/* macro example 2 dynamic report creation - josh horstman */
/* Paper 4679-2020
Using SAS® Macro Variable Lists to Create
Dynamic Data-Driven Programs, SAS Global Forum 
https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2020/4679-2020.pdf
*/
title;
footnote;
Title1 bold height=14pt "Positive cases as a percent of total tests for COVID";
Footnote1 height=8pt justify=left "Source: The COVID Tracking Project.  Data Accessed on &accesseddate at https://covidtracking.com/data";
Footnote2 height=8pt justify=left italic 'Created by Steven C. Myers, The University of Akron, https://econdatascience.com' ;


proc sort data=ctp.temp; by state_type state date; run;
ods graphics on / height=3.5in width=7in;
ods html file="D:\Covid19 virus data\COVID Tracking Project\x\states_testing.html";
ods pdf file="D:\Covid19 virus data\COVID Tracking Project\x\states_testing.pdf" author="Steven C. Myers";
ods pdf StartPage=Never; 

Title2 "Summary United States";
proc print data=ctp.temp noobs label ;
var state_name date totaltestresults positive percent_positive death deathrate_cases ;
format 	totaltestresults positive death comma10.0
		percent_positive deathrate_cases percent6.2;
Where state="US" & date>'26apr20'd;
run;
Title2;

%macro graph_testing;
 * Create the horizontal macro variable list.;
 proc sql noprint;
 select distinct state into :state_list separated by '~'
 from ctp.temp;
 %let numstates = &sqlobs;
 quit;
 * Loop through each value and generate a call to SGPLOT ;
 * with ODS statements to output the graph to a PDF. ;

 %do i = 1 %to &numstates;
 proc sgplot data=ctp.temp;
 	where state = "%scan(&state_list,&i,~)";


Title2 bold height=16pt "in the state of %scan(&state_list,&i,~)";
proc sgplot data=ctp.temp;
	where state = "%scan(&state_list,&i,~)";	
	loess y=percent_positive x=date / smooth=.5 curvelabel="Percent Positive tests"  CURVELABELLOC=outside CURVELABELPOS=end  lineattrs=(color=red thickness=3px) ;
	format date mmddyy5. ;
	yaxis label="Percent of tests that are positive";
	format percent_positive  percent6.2;
	xaxis values=(&begindate to &enddate by day)  ; 
run;


Title2 bold height=16pt "Total testing for COVID in the state of %scan(&state_list,&i,~)";
proc sgplot data=ctp.temp;
	where state="%scan(&state_list,&i,~)";
	series y=positive x=date / curvelabel="Total Positive tests"  CURVELABELLOC=outside CURVELABELPOS=end  lineattrs=(color=red thickness=3px) ;
	series y=negative x=date  / curvelabel="Total Negative tests"  CURVELABELLOC=outside CURVELABELPOS=end  lineattrs=(color=navy thickness=3px) ;
	series y=totaltestresults x=date  / curvelabel="Total Tests Completed"  CURVELABELLOC=outside CURVELABELPOS=end  lineattrs=(color=black thickness=3px) ;
	format date mmddyy5. ;
	yaxis label="Number of tests and results";
	xaxis values=(&begindate to &enddate by day)  ; 
run;


 run;
 %end; 


%mend graph_testing;

%graph_testing;

Title2;
proc sort data=ctp.temp; by state_type bea_region descending percent_positive; run;
Title2 "States and Territories";
proc print data=ctp.temp noobs label ;
var state_name date totaltestresults positive percent_positive death deathrate_cases ;
format 	totaltestresults positive death comma10.0
		percent_positive deathrate_cases percent6.2;
Where date='01may20'd and state_type ne "A";
by state_type bea_region;
run;

ods pdf close;
ods html close;
