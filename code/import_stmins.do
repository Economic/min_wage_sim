*input state minimum wage and tipped minimum wage values for all months
*from excel-generated csv file.
*See r:/The Data/Min Wage/Historical and projected State Minimum Wages MASTER.xlsx
*12/27/2018

set more off
clear all

global base /projects/dcooper/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

import delimited using ${data}stmins_current.csv

label variable stmin "State minimum wage"
label variable tipmin "State tipped minimum wage"

rename state statecensus

gen mdate = ym(year,month)
format %tm mdate

label variable mdate "Month and Year"
label variable pwstate "State FIPS code"
label variable statecensus "State Census code"

save ${data}stmins, replace
