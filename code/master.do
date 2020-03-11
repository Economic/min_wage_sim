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

*inputs proposed [tipped] minimums by month/year, plus current-law state mins
*specify csv file with proposed increase schedule and data year of ACS data
do ${code}load_model_inputs.do "${data}test_inputs"

*need to add parameters for population/employment growth and wage growth
*specify lower bound on population eligible for minimum wage increase?
*specify upper bound of spillover effect?

include ${code}load_acs_data.do

merge m:1 pwstate using $activemins
drop _merge

*create adusted weights for t1, t2...tx

*generate counterfactual wage values at t1, t2...tx
**consider natural nominal wage growth
**apply state minimum wage changes between t0 and t1

*identify directly affected observations (hrwage2<stmin1)
**calculate resulting/implied wage increases for those workers

*identify indirectly affected observations (stmin1<=hrwage2<spillover cutoff)
**calculate resulting/implied wage increases for those workers

*generate and output descriptive statistics of affected workers
**by various demographic cuts

log close
exit
