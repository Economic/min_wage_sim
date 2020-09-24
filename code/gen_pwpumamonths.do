*create file with all PWPUMAS for model months
*9/20/2020
*D.Cooper

set more off
*set trace on
clear all

global base /projects/dcooper/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/
global log ${base}logs/

tempfile mergedpumas
save `mergedpumas', emptyok
clear

forvalues y = 2015/2030 {
	forvalues m = 1/12 {
	clear
	use ${data}pwpumas.dta
	gen month = `m'
	gen year = `y'
	append using `mergedpumas'
	save `mergedpumas', replace
	}
}

save ${data}pwpuma_months.dta, replace
