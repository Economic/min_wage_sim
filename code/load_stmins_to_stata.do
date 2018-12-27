*input state minimum wage and tipped minimum wage values for all months
*12/27/2018

set more off
clear all

global base /home/dcooper/projects/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

import delimited using ${data}/stmins.csv

label variable stmin "State minimum wage"
label variable tipmin "State tipped minimum wage"

rename state statecensus

save ${data}/stmins, replace
