capture program drop mwsim_run
program define mwsim_run
syntax, microdata(string) POLICY_schedule(string) steps(integer) CPI_projections(string) POPULATION_projections(string) conditions(string) real_wage_growth(real) [lower_bound(real 0.8) spillover(real 1.15)]


qui {
    * grab dates from policy schedule
    use `"`policy_schedule'"', clear
    * check policy schedule and steps are correct
    sum step 
    assert r(max) == `steps'
    * calculate months to steps info
    keep mdate step
    tsset step 
    gen months_to_step = D.mdate
    keep if step >= 1
    sort step
    forvalues i = 1/`steps' {
        scalar months_to_`i' = months_to_step[`i']
    }
}

* add CPI projections as scalars
use `"`policy_schedule'"', clear
qui {
    merge 1:1 mdate using `cpi_projections', keep(3) nogenerate 
    forvalues i = 0 / `steps' {
        scalar cpi`i' = cpi_u[`i' + 1]
    }
}

di as txt _n(1) "Loading input microdata with restrictions: `conditions'"
* load input microdata
use if `conditions' using `microdata', clear 

* identify and confirm required input variables
local mwvars stmin0 tipmin0
forvalues i = 1 / `steps' {
    local mwvars `mwvars' stmin`i' tipmin`i' prop_mw`i' prop_tw`i'
}
local input_varlist hrwage0 perwt0 tipc racec worker uhrswork `mwvars'
confirm variable `input_varlist'

* model output variables
local output_varlist ""
foreach x in direct indirect raise d_wage d_annual_inc perwt hrwage cf_hrwage {
    forvalues i = 1 / `steps' {
        local output_varlist `output_varlist' `x'`i'
    }
}

* prepare data for simulation
* generate id for merging later and remove everything but reqlist
tempvar id
gen `id' = _n
preserve
keep `id' `input_varlist'

* add population growth projections
qui merge m:1 racec using `population_projections'
* THERE IS A RACE = 5 in the pop projections that is not in the data
* this is weird and needs to be fixed
* temporary fix now:
qui count if _merge == 2
assert r(N) == 1
qui drop if _merge == 2
drop _merge 

*adjust person weights to reflect weights at t[n]
qui forvalues i = 1/`steps' {
  gen perwt`i' = perwt`=`i'-1' * (((months_to_`i'/12) * (growthann-1))+1)
  label var perwt`i' "Person weight at step `a'" 
}

* Determine mw eligible worker
qui gen byte mw_eligible = .
qui replace mw_eligible = 1 if worker == 1 & (hrwage0 > (stmin0 * `lower_bound')) & hrwage != .

di as txt _n(1) "Creating counterfactual wage values"
qui gen cf_hrwage0 = hrwage0
qui forvalues a = 1/`steps' {
  noi di as txt "... step `a'"

  gen hrwage`a' = hrwage`=`a'-1'
  label var hrwage`a' "Hourly wage at step `a'"
  *increase hourly wage values by inflation between data period and each step
  replace hrwage`a' = hrwage`=`a'-1' * ((cpi`a' / cpi`=`a'-1') + `real_wage_growth') if hrwage0 != .
   *replace hrwage`a' = (cpi`a' / cpi0) * hrwage0 if hrwage0 != .
  
   *increase hourly wage to new MW if increase occured since data period
    *simple option:
    replace hrwage`a' = max(stmin`a', (hrwage`a' + (.25*((stmin`a' * `spillover') - hrwage`a')))) ///
      if (stmin`a' > hrwage`a') & mw_eligible == 1

   *old model's logic:/*
  *in places where there was a minimum wage increase...
   if stmin`a' > stmin`=`a'-1' {
      *if their cpi-adjusted wage is less than the new minimum wage, either:
      if hrwage`a' < (stmin`a' * spillover) & hrwage0 > (stmin0 * lower_bound) {
      *bring them to the same position relative to the previous minimum if they were previously below the minimum
        replace hrwage`a' = (hrwage`=`a'-1' / stmin`=`a'-1') * stmin`a' if (hrwage`=`a'-1' < (lower_bound * stmin`=`a'-1'))
        *otherwise, bring them either 1/4 the distance to the spillover cutoff or up to the new minimum, whichever is larger
        replace hrwage`a' = hrwage`a' + (((stmin`a' * spillover) - hrwage`a')*.25) if (hrwage`=`a'-1' >= (lower_bound * stmin`=`a'-1'))
        replace hrwage`a' = stmin`a' if hrwage`a' < stmin`a'
      }
    }*/
 gen cf_hrwage`a' = hrwage`a'
 label var cf_hrwage`a' "Counterfactual wage at step `a'"
}

di as txt _n(1) "Calculating directly and indirectly affected status and raise amounts"
qui forvalues a = 1/`steps' {
    noi di as txt "... step `a'"
    gen direct`a' = .
    gen indirect`a' = .
    gen raise`a' = .
    gen d_wage`a' = .
    gen d_annual_inc`a' = .

    label var direct`a' "Directly affected at step `a'"
    label var indirect`a' "Indirectly affected at step `a'"
    label var raise`a' "Raise resulting from increase at step `a'"

    replace direct`a' = 0
    replace indirect`a' = 0
    *flag workers with wages below the new MW and above the old lower bound as directly affected
    *flag workers with wages above the new MW and below the spillover cutoff as indirectly affected
  
    *replace direct`a' = 1 if (prop_mw`a' > hrwage`a') & (hrwage`a' > (lower_bound * stmin`a')) & (hrwage0 > (lower_bound * stmin0))
    replace direct`a' = 1 if prop_mw`a' > stmin`a' & (prop_mw`a' > hrwage`a') & mw_eligible == 1
    replace indirect`a' = 1 if prop_mw`a' > stmin`a' & (hrwage`a' >= prop_mw`a') & (hrwage`a' < (`spillover' * prop_mw`a'))

    *calculate implied raises for both 
    replace raise`a' = min(max((prop_mw`a' - hrwage`a'), 0.25 * ((`spillover' * prop_mw`a') - hrwage`a')), prop_mw`a' - stmin`a') if direct`a' == 1
    replace raise`a' = 0.25 * ((`spillover' * prop_mw`a') - hrwage`a') if indirect`a' == 1

    *add raise to existing hourly wage
    replace hrwage`a' = hrwage`a' + raise`a' if (raise`a' > 0 & raise`a' != .)
 
    *calculate difference between new hourly wage and counterfactual wage
    replace d_wage`a' = hrwage`a' - cf_hrwage`a' if (raise`a' > 0 & raise`a' != .)
    replace d_annual_inc`a' = d_wage`a' * uhrswork * 52 if (raise `a' > 0 & raise`a' != .)
  }

di as txt _n(1) "Adding output variables to input microdata"
keep `id' `output_varlist'
tempfile results 
qui save `results'
restore
qui merge 1:1 `id' using `results', assert(3) nogenerate

end
