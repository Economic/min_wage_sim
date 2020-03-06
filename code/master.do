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

capture log close
log using "${log}min_wage_test.txt", text replace
numlabel, add

**************Set parameters for model****************
local year_data 2017
local month_data 7

local month_raise1 7
local year_raise1 2019
scalar newmw1 = 9.25
scalar newtw1 = 4.15

local month_raise2 7
local year_raise2 2020
scalar newmw1 = 10.10
scalar newtw1 = 5.30

*set number of steps in the model
local numsteps = 2 
*need to add parameters for population/employment growth and wage growth
*specify lower bound on population eligible for minimum wage increase?
*specify upper bound of spillover effect?

************End parameters for model************************

include ${code}load_stmins.do

include ${code}load_acs_data.do

merge m:1 pwstate using `mindata'
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
