# testing
This is a repository of the SAS code, data and results for my chartbook on COVID19 testing across the states and territories in the US. 

The data is created by running read_daily_create_sasdata.sas
This program uses 4 datasets
1. daily.csv
2. dailyus.csv
3. postal.xlsx
4. population
The resulting data is temp.sas7bdat


The code for the chartbook is in macro_state2.sas
This code reads temp.sas7bdat and produces the chartbook

The chartbook is states_testing.pdf

