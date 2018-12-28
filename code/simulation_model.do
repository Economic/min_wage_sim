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

run ${code}/load_stmins_to_stata

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

gen year0 = `yeardata'
gen month0 = month

forvalues a = 1/$numsteps {
  replace year = $year_raise`a'
  replace month = $month_pre_raise`a''
  merge m:1 statecensus year month using ${data}/stmins
  gen month`a' = month
  gen year`a' = year
}
