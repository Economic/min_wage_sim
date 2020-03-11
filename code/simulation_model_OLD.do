* EPI minimum wage model v0.1
* David Cooper
* 12/27/2018


set more off
clear all

global base /home/dcooper/projects/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

cd "${base}"

/*If you need to reload an updated set of state min wages, uncomment below*/
/* run ${code}/import_stmins.do */

local yeardata 2017

scalar popgrowth_w = 1.0
scalar popgrowth_b = 1.0
scalar popgrowth_h = 1.0
scalar popgrowth_a = 1.0
scalar popgrowth_o = 1.0

scalar wagegrowth1 = 1.248
local monthstoraise1 12
local month_raise1 7
local year_raise1 2019
scalar newmw1 = 9.25
scalar newtw1 = 4.15

scalar wagegrowth2 = 1.248
local monthstoraise2 12
local month_raise2 7
local year_raise2 2020
scalar newmw1 = 10.10
scalar newtw1 = 5.30

local numsteps 2

load_epiextracts, begin(2017m1) end(2017m12) sample(org)

merge m:1 statecensus year month using ${data}stmins
drop if _merge==2
drop _merge

gen year0 = `yeardata'
label variable year0 "Data year"
gen month0 = month
label variable month0 "Data month"
rename stmin stmin0
rename tipmin tipmin0

*merge counterfactual minimum wages to each obs for all steps
forvalues a = 1 / `numsteps' {
  replace year = `year_raise`a''
  replace month = `month_pre_raise`a''
  merge m:1 statecensus year month using ${data}stmins, keepusing(stmin tipmin)
  drop if _merge==2
  drop _merge
  rename stmin stmin`a'
  rename tipmin tipmin`a'
  label variable stmin`a' "CF min wage in step `a'"
  label variable tipmin`a' "CF tip min wage in step `a'"
}

*define workers and demographic categories
gen byte worker = 0
replace worker =1 if age>=16 & wage>0 & emp==1
label variable worker "Wage earner"

gen teens = irecode(age,20)
label define l_teens 0 "Teenager" 1 "Age 20 or older"
label values teens l_teens

gen agecat = irecode(age,25,40,55)
label define agecats 0 "Age 16 to 24" 1 "Age 25 to 39" 2 "Age 40 to 54" ///
  3 "Age 55 or older"
label values agecat agecats

*gen byte parent = 0
*replace parent = 1 if



*adjust weights and wage values to month preceding first increase
