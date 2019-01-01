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
/* run ${code}/load_stmins_to_stata */

local yeardata 2017

scalar popgrowth = 1.0

scalar wagegrowth1 = 1.248
local monthstoraise1 12
local month_pre_raise1 7
local year_raise1 2019
scalar newmw1 = 9.25
scalar newtw1 = 4.15

scalar wagegrowth2 = 1.248
local monthstoraise2 12
local month_pre_raise2 7
local year_raise2 2020
scalar newmw1 = 10.10
scalar newtw1 = 5.30

local numsteps 2

append_extracts, begin(2017m1) end(2017m12) sample(org)

merge m:1 statecensus year month using ${data}/stmins
drop if _merge==2
drop _merge

gen year0 = `yeardata'
label variable year0 "Data year"
gen month0 = month
label variable month0 "Data month"
rename stmin stmin0
rename tipmin tipmin0

forvalues a = 1 / `numsteps' {
  replace year = `year_raise`a''
  replace month = `month_pre_raise`a''
  merge m:1 statecensus year month using ${data}/stmins, keepusing(stmin tipmin)
  drop if _merge==2
  drop _merge
  rename stmin stmin`a'
  rename tipmin tipmin`a'
  label variable stmin`a' "CF min wage in step `a'"
  label variable tipmin`a' "CF tip min wage in step `a'"
}
