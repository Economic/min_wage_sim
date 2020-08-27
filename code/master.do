*master do file for EPI minimum wage model
*3/5/2020
*D.Cooper

set more off
clear all

global base /projects/dcooper/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/
global log ${base}logs/

global allmins ${data}stmins.dta
global activemins ${data}sim_active_mins.dta

capture log close
log using "${log}min_wage_test.txt", text replace
numlabel, add

*input latest CPI projections
do ${code}load_cpi_projections.do "${data}CPI_projections_8_2020"

*consider adding state-specific wage growth rates

*input proposed [tipped] minimums by month/year, plus current-law state mins
*passed objects:
*1) specify csv file with proposed increase schedule and data year of ACS data first
*2) specify lower bound on population eligible for minimum wage increase second
*3) specify upper bound of spillover effect third
do ${code}load_model_inputs.do "${data}test_inputs" 0.75 1.15

*input current population growth projections by race/ethnicity
do ${code}load_pop_projections.do "${data}pop_projections_8_2020"

*load the ACS data file, merge population and wage projections into it
*generate counterfactual wage values at t1, t2...tx
**apply state minimum wage changes between t0, t1...tx
include ${code}load_acs_data.do

*identify directly affected observations (hrwageX<stminX)
**calculate resulting/implied wage increases for those workers

*identify indirectly affected observations (stmin1<=hrwage2<spillover cutoff)
**calculate resulting/implied wage increases for those workers

*generate and output descriptive statistics of affected workers
**by various demographic cuts

log close
exit
