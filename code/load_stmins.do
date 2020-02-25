*Load correct minimum wage and tipped minimum wage values for data year of
*dataset and month and years of each proposed increase

set more off
clear all

global base Projects/min_wage/
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

*create data set of all relevant state minimum wages 
use ${allmins}

gen step0 = ym(`year_data',`month_data')
format %tm step0

label variable step0 "Date of model source data"

keep if mdate==step0

tempfile mindata
save `mindata'

forvalues a = 1 / `numsteps' {
    use ${allmins},clear

    gen step`a' = ym(`year_raise`a'',`month_raise`a'')
    format %tm step`a'
    label variable step`a' "Date of step `a' raise"

    keep if mdate == step`a'
    drop mdate
    drop month
    drop year
    
    if `a' == 1 {
        tempfile combine_mins
        save `combine_mins'
    }
    else {
        append using `combine_mins'
        save `combine_mins', replace
    }
}

append using `mindata'
save `mindata', replace

