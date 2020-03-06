*master do file for EPI minimum wage model
*3/5/2020
*D.Cooper

set more off
clear all

global base projects/dcooper/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

global allmins ${data}stmins.dta

*Set parameters for model
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

*End parameters for model

include ${code}load_stmins.do

use ${data}acs_state.dta

merge m:1 pwstate using `mindata'
