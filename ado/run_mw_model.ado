capture program drop run_mw_model
program define run_mw_model
syntax,	inputdata(string asis) outputdata(string asis) outputlog(string asis)	inputdataym(integer)	policysteplistym(string) policynumsteps(integer) cfactwagegrowth(real) idvar(name) wagevar(name) weightvar(name)	popadjvar(name)	eligiblevar(name)

********************************************************************************
* LOG MODEL PARAMETERS
********************************************************************************
# delimit ;
create_log,
	inputdata(`inputdata')
	outputdata(`outputdata')
	outputlog(`outputlog')
	inputdatayear(`inputdatayear')
	policybegyear(`policybegyear')
	policydates(`policydates')
	cfactwagegrowth(`cfactwagegrowth')
	idvar(`idvar')
	wagevar(`wagevar')
	weightvar(`weightvar')
	popadjvar(`popadjvar')
	eligiblevar(`eligiblevar')
;
# delimit cr;

********************************************************************************
* LOAD INPUT DATA
********************************************************************************
use `inputdata', clear
* save all data for merging later
tempfile alldata
save `alldata'


********************************************************************************
* SANITY CHECKS
********************************************************************************
* pop-adjustments are percents/100:
assert `popadjvar' < 0.1

* number of steps equal = number of dated increases
* this is just to help ensure the policysteplistym was entered correctly
local counter = 0
foreach step in `policysteplistym' {
	local counter = `counter' + 1
}
assert `counter' == `policynumsteps'


********************************************************************************
* PREPARE DATA FOR MODEL
********************************************************************************
* restrict to necessary variables
keep `idvar' year month `wagevar' `weightvar' `popadjvar'


********************************************************************************
* RUN MODEL
********************************************************************************

* CF wages
* adjust wages in data to ym of policy
	* 1. cfwagegrowth, then wage increase due to cf min wages



********************************************************************************
* SAVE OUTPUT WITH ORIGINAL DATA
********************************************************************************
keep `idvar' cf_`wagevar'* treat_`wagevar'* `weightvar'* `popadjvar'
merge 1:1 `idvar' using `inputdata', assert(3) nogenerate
save `outputdata'


end
