/*Load correct minimum wage and tipped minimum wage values for data year of
*dataset and month and years of each proposed increase
*/

set more off
clear all

global base /home/dcooper/projects/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

local year_data 2017
local month_data 7

gen data_period = ym(year_data,month_data)
format %tm data_period

scalar wagegrowth1 = 1.248
local month_raise1 7
local year_raise1 2019

scalar newmw1 = 9.25
scalar newtw1 = 4.15

scalar wagegrowth2 = 1.248
local month_raise2 7
local year_raise2 2020
scalar newmw1 = 10.10
scalar newtw1 = 5.30

local numsteps 2

forvalues a = 1 / `numsteps' {
    gen step_`a' = ym(`year_raise`a'',`month_raise`a'')
    format %tm step_`a'
}

tempfile 
