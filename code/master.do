*master do file for EPI minimum wage model
*3/5/2020
*D.Cooper

set more off
*set trace on
clear all

global base /projects/dcooper/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/
global log ${base}logs/

global allmins ${data}stmins.dta
global activemins ${data}sim_active_mins.dta
global simdata ${data}allsimdata.dta

global outputfile ${output}rtwa_output.xlsx

*define the subgroups for which to describe specific impacts 
local groups "worker female teen agec racec poc childc hourc edc indc sectc faminc povstat tipc"

*set any special restrictions on the simulation dataset
*(e.g., limit to a specific pwstate for individual state proposal)
*"worker == 1" is the default, which is essentially no restrictions
global conditions "worker == 1"

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
do ${code}load_model_inputs.do "${data}rtwa_inputs" 0.75 1.15

*input current population growth projections by race/ethnicity
do ${code}load_pop_projections.do "${data}pop_projections_8_2020"

*load the ACS data file, merge population and wage projections into it
*generate counterfactual wage values at t1, t2...tx
**apply state minimum wage changes between t0, t1...tx
include ${code}load_acs_data.do 

*calculate affected counts, shares, and raises for affected workers for all steps
include ${code}analyze_summary.do

*calculate affected counts, shares, raises by demographic groups within each step
*using $steps in the first passed object calculates affected in final step

do ${code}analyze_by_group.do `groups'
 
*generate and output descriptive statistics of affected workers
**by various demographic cuts

*erase ${data}allsimdata.dta

log close
exit
