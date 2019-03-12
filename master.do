set more off
clear all
macro drop _all

********************************************************************************
* DIRECTORY SETUP
********************************************************************************
* input data for run_model
global inputdir input/
* output data from run_model
global outputdir output/
* run_model and other ado files
adopath + ado

stop

********************************************************************************
* EXAMPLE: CREATE INPUT DATA
********************************************************************************
* Min wage data
do create_mwdata.do

* Population adjustments
*do create_popadjust.do

* Microdata + min wage data
*do create_modeldata.do


********************************************************************************
* EXAMPLE: RUN MODEL
********************************************************************************
#delimit ;

run_mw_model,
	inputdata("${inputdir}example_inputdata.dta")
	inputcfmwdata("${inputdir}example_cf_stmin.dta")
	inputpolicymwdata("${inputdir}example_policy_stmin.dta")
	outputdata("${outputdir}example_outputdata.dta", replace)
	outputlog("${outputdir}example_outputlog.txt", replace text)
	inputdatayear(2018)
	policybegyear(2019)
	policydates(6)
	cfactwagegrowth(0.025)
	idvar(uniqueid)
	wagevar(wageotc)
	weightvar(orgwgt)
	popadjvar(popadjust_annual)
	eligiblevar(eligible)
;

#delimit cr;



********************************************************************************
* EXAMPLE: ANALYZE MODEL OUTPUT
********************************************************************************
* do analyze_modeloutput.do
