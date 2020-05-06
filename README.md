# testing
This is a repository of the SAS code, data and results for my chartbook on COVID19 testing across the states and territories in the US. 

The data is created by running read_daily_create_sasdata.sas
This program uses 4 datasets

1. daily.csv
      source: https://covidtracking.com/api/v1/states/daily.csv Historic state data
2. dailyus.csv
      source: https://covidtracking.com/api/v1/us/daily.csv Historic US data
3. postal.xlsx
      authors assemblage from 
      a. Postal codes and state names 
      b. BEA Region definitions from https://en.wikipedia.org/wiki/List_of_regions_of_the_United_States
4. population
      cource: heavily edited from https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population
      
The resulting data is temp.sas7bdat


The code for the chartbook is in macro_state2.sas
This code reads temp.sas7bdat and produces the chartbook

The chartbook is states_testing.pdf

