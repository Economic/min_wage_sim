* EPI minimum wage model v0.1
* David Cooper
* 12/27/2018


set more off
clear all

global base /home/dcooper/projects/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

append_extracts, begin(2017m1) end(2017m12) sample(org)

local datayear 2017

scalar popgrowth 1.0 *assumed population growth rate

scalar wagegrowth1 1.248 *assumed "natural" wage growth leading up to increase 1
scalar monthstoraise1 12 *number of months between data year and increase 1
scalar month_pre_raise1 7 *month before the first raise
scalar year_raise1 2019 *year of first raise
scalar newmw1 9.25 *proposed minimum wage in first step
scalar newtw1 4.15 *proposed tipped min wage in first step

scalar numsteps 1 *number of steps in the proposal
