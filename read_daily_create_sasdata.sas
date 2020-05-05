title;
footnote;

/* import the CSV file */
%let path=D:\Covid19 virus data\COVID Tracking Project;
libname ctp "&path";

options validvarname=v7;

proc import datafile="&path\daily.csv"
		out=daily2
		dbms=csv replace;
		guessingrows=max;
		run;

proc import datafile="&path\dailyus.csv"
		out=dailyus
		dbms=csv replace;
		guessingrows=max;
		run;

proc import datafile="&path\postal.xlsx"
		out=postal
		dbms=xlsx replace;
		run;

proc import datafile="&path\population2019.xlsx"
		out=pop
		dbms=xlsx replace;
		run;

data dailyus;
		set dailyus;
		drop fips;
		run;

data ctp.daily;
	format date newdate mmddyy10.; 
	set daily2 (in=a)
		dailyus (in=b);
		if a then type="A";
		if b then do;
				state="US";
				type="B";
				end;
	newdate=input(put(date,8.),yymmdd8.);
	date=newdate;
	drop newdate;
	run;
proc print data=ctp.daily(obs=5);
    format date newdate mmddyy10.;
	where fips=.;
    run;
proc contents data=stp.daily; 
	run;


proc sort data=ctp.daily; by state; run;
proc sort data=postal; by state; run;


Data ctp.temp2;
merge ctp.daily postal(drop=abv); 
		by state;

if hospitalizedCumulative > 0 and  inIcuCumulative > 0 then
	hospnotINICU = hospitalizedCumulative - inIcuCumulative;
	else hospnotINICU = .;

if hospitalizedCumulative > 100 then do; 
		pcticu = inIcuCumulative/hospitalizedCumulative;
		deathrate_hosp = death/hospitalizedCumulative;
		end;
		else do;
			pcticu=.;
			deathrate_hosp =.;
			end;

if positive > 0 then deathrate_cases = death/positive;
		else deathrate_cases = .;
If inIcuCumulative >= 50 then 
		deathrate_hospicu = death/inIcuCumulative;
		else deathrate_hospicu=.;

If hospnotINICU > 50 then 
		deathrate_hospnoicu = death/hospnotINICU;
		else deathrate_hospnoicu = .;

If totaltestresults > 100 then do;
		deathrate_totaltestresults= death/totaltestresults;
		percent_positive = positive / totaltestresults;
		end;
		else do;
			deathrate_totaltestresults=.;
			percent_positive=.;
			end;

run;


proc sort data=ctp.temp2; by state_name; run;
proc sort data=pop; by state_name; run;

/* population is not merging yet with ctp.temp2 */

Data pop;
length state_name $20 state_name2 $20;
format state_name $20.;

set pop;
state_name2=state_name;
if substr(state_name2,1,13)='Total U. S. (' then state_name='United States';
if substr(state_name2,1,11)='District of' then state_name='District of Columbia';
if substr(state_name2,1,10)='Northern M' then state_name='Northern Marianas';
if substr(state_name2,1,11)='U.S. Virgin' then state_name='Virgin Islands';


run;
proc contents data=ctp.temp2; run;
proc contents data=pop; run;

Data ctp.temp;
merge ctp.temp2 pop; by state_name;
run;
proc print data=ctp.temp;
where date='1may20'd;
run;


proc print data=ctp.temp2; var state_name ; where date='1may20'd; run;
proc print data=pop; var state_name state_name2; run;
