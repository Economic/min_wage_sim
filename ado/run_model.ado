capture program drop run_model
program define run_model
syntax, inputdata(string asis) outputdata(string asis) outputlog(string asis) inputdatayear(integer) policybegyear(integer) policydates(string) cfactwagegrowth(real) idvar(name) wagevar(name) weightvar(name) popadjvar(name) eligiblevar(name)

********************************************************************************
* LOG MODEL PARAMETERS
********************************************************************************
create_log, inputdata(`inputdata') outputdata(`outputdata') outputlog(`outputlog') inputdatayear(`inputdatayear') policybegyear(`policybegyear') policydates(`policydates') cfactwagegrowth(`cfactwagegrowth') idvar(`idvar') wagevar(`wagevar') weightvar(`weightvar') popadjvar(`popadjvar') eligiblevar(`eligiblevar') 

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


********************************************************************************
* PREPARE DATA FOR MODEL
********************************************************************************
* restrict to necessary variables
keep `idvar' year month `wagevar' `weightvar' `popadjvar'


********************************************************************************
* RUN MODEL
********************************************************************************


********************************************************************************
* SAVE OUTPUT WITH ORIGINAL DATA
********************************************************************************
keep `idvar' `wagevar'* `weightvar'* `popadjvar'
merge 1:1 `idvar' using `inputdata', assert(3) nogenerate
save `outputdata'


end
