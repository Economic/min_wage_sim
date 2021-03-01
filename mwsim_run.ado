capture program drop mwsim_run
program define mwsim_run
syntax, microdata(string) POLICY_schedule(string) steps(integer) CPI_projections(string) POPULATION_projections(string) real_wage_growth(real) [conditions(string) lower_bound(real 0.8) spillover(real 1.15)]


qui {
    * grab dates from policy schedule
    use `"`policy_schedule'"', clear
    * check policy schedule and steps are correct
    sum step 
    if r(max) != `steps' {
        noi disp as err `"Number of specified steps does not agree with policy schedule:"'
        noi disp as err `"`steps' steps specified by user but"'
        noi disp as err `"`r(max)' steps in policy schedule `policy_schedule'"' _n
        exit 198
    }
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

* load input microdata
if "`conditions'" != "" {
    di as txt _n(1) "Loading input microdata with restrictions: `conditions'"
    use if `conditions' using `microdata', clear 
}
else {
    di as txt _n(1) "Loading input microdata"
    use `microdata', clear
}

* identify and confirm required input variables
local mwvars stmin0 tipmin0
forvalues i = 1 / `steps' {
    local mwvars `mwvars' stmin`i' tipmin`i' prop_mw`i' prop_tw`i'
}
local input_varlist hrwage0 perwt0 nom_wage_growth0 tipc racec worker uhrswork `mwvars'
confirm variable `input_varlist'

* model output variables
local output_varlist ""
foreach x in direct indirect affected raise d_wage d_annual_inc cf_annual_inc perwt hrwage cf_hrwage {
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
qui merge m:1 racec using `population_projections', assert(3) nogenerate

*adjust person weights to reflect weights at t[n]
qui forvalues i = 1/`steps' {
  *gen perwt`i' = perwt`=`i'-1' * (((months_to_`i'/12) * (growthann-1))+1)
  gen perwt`i' = perwt`=`i'-1' * ((growthann)^(months_to_`i'/12))
  label var perwt`i' "Person weight at step `a'" 
}

* Determine mw eligible worker
qui gen byte mw_eligible = .
qui replace mw_eligible = 1 if worker == 1 & (hrwage0 > (stmin0 * `lower_bound')) & hrwage != . & tipc == 0
qui gen byte tip_eligible = .
qui replace tip_eligible = 1 if worker == 1 & (hrwage0> (tipmin0 * `lower_bound')) & hrwage != . & tipc == 1

di as txt _n(1) "Creating counterfactual wage values"
qui gen cf_hrwage0 = hrwage0
qui forvalues a = 1/`steps' {
    noi di as txt "... step `a'"
    gen hrwage`a' = hrwage`=`a'-1'
    label var hrwage`a' "Hourly wage at step `a'"

    * increase hourly wage values by inflation between data period and each step
    * for first step use specified wage growth 
    if `a' == 1 {
        replace hrwage`a' = hrwage`=`a'-1' * ((1 + nom_wage_growth0)^(months_to_`a'/12)) if hrwage0 != .
    }
    else {
        replace hrwage`a' = hrwage`=`a'-1' * ((cpi`a' / cpi`=`a'-1') + (1+`real_wage_growth')^(months_to_`a'/12) - 1) if hrwage0 != .
    }
   
    * in places where there was a minimum wage increase...
    * if their cpi-adjusted wage is less than the new minimum wage...
    * raise nontipped workers either up to the new minimum or 1/4 distance to spillover if they were above the lower bound initially
    replace hrwage`a' = max(stmin`a', (hrwage`a' + (.25*((stmin`a' * `spillover') - hrwage`a')))) ///
    if (stmin`a' > hrwage`a') & mw_eligible == 1 & (stmin`a' > stmin`=`a'-1')
    *raise tipped workers hourly wages by any increase in the tipped minimum
    replace hrwage`a' = (hrwage`a' + (tipmin`a' - tipmin`=`a'-1')) if tip_eligible == 1 & (tipmin`a' > tipmin`=`a'-1') 
    *if their wages were above the regular minimum previously, ensure they're at least at the new minimum 
    replace hrwage`a' = stmin`a' if stmin`a' > hrwage`a' & (hrwage`=`a'-1' > stmin`=`a'-1') & tip_eligible == 1

    gen cf_hrwage`a' = hrwage`a'
    label var cf_hrwage`a' "Counterfactual wage at step `a'"

    gen cf_annual_inc`a' = cf_hrwage`a' * uhrswork * 52
    lab var cf_annual_inc`a' "Counterfactual annual income at step `a'"
}

di as txt _n(1) "Calculating directly and indirectly affected status and raise amounts"
qui forvalues a = 1/`steps' {
    noi di as txt "... step `a'"
    gen direct`a' = .
    gen indirect`a' = .
    gen affected`a' = .
    gen raise`a' = .
    gen d_wage`a' = .
    gen d_annual_inc`a' = .

    label var direct`a' "Directly affected at step `a'"
    label var indirect`a' "Indirectly affected at step `a'"
    label var affected`a' "Affected (directly or indirectly) at step `a'"
    label var raise`a' "Raise resulting from increase at step `a'"

    replace direct`a' = 0
    replace indirect`a' = 0
    replace affected`a' = 0
    *flag workers with wages below the new MW and above the old lower bound as directly affected
    *mw_eligible denotes above lower bound; tip_eligible denotes above tipped lower bound
    *tipped workers directly affected if wages (inclusive of tips) < new min wage (regardless of change in tipped min)
    replace direct`a' = 1 if prop_mw`a' > stmin`a' & (prop_mw`a' > hrwage`a') & (mw_eligible == 1 | tip_eligible == 1)
    replace direct`a' = 1 if prop_tw`a' > tipmin`a' & (prop_mw`a' > hrwage`a') & tip_eligible == 1
    
    *flag workers with wages above the new MW and below the spillover cutoff as indirectly affected
    *tipped workers are indirectly affected if wages > new minimum wage and tipped min increases
    replace indirect`a' = 1 if prop_mw`a' > stmin`a' & (hrwage`a' >= prop_mw`a') & (hrwage`a' < (`spillover' * prop_mw`a')) /// 
        & mw_eligible == 1
    replace indirect`a' = 1 if prop_tw`a' > tipmin`a' & (hrwage`a' >= prop_mw`a') & tip_eligible == 1

    *calculate implied raises for both
    *directly affected nontipped workers get 1/4 distance to spillover or up to new MW, whichever is higher
    replace raise`a' = min(max((prop_mw`a' - hrwage`a'), 0.25 * ((`spillover' * prop_mw`a') - hrwage`a')), prop_mw`a' - stmin`a') /// 
        if direct`a' == 1 & mw_eligible == 1
    *directly affected tipped workers get change in tipped minimum 
    replace raise`a' = (prop_tw`a' - tipmin`a') if direct`a' == 1 & tip_eligible == 1
    **CONSIDER: should directly affected tipped workers get something if tipped min is unchanged? 

    *indirectly affected nontipped workers get 1/4 distance to spillover
    replace raise`a' = 0.25 * ((`spillover' * prop_mw`a') - hrwage`a') if indirect`a' == 1 & mw_eligible == 1
    *indirectly affected tipped workers get 1/2 change in tipped minimum
    replace raise`a' = 0.5 * (prop_tw`a' - tipmin`a') if indirect`a' == 1 & tip_eligible == 1

    *add raise to existing hourly wage
    replace hrwage`a' = hrwage`a' + raise`a' if (raise`a' > 0 & raise`a' != .)
 
    *calculate difference between new hourly wage and counterfactual wage
    replace d_wage`a' = hrwage`a' - cf_hrwage`a' if (raise`a' > 0 & raise`a' != .)
    replace d_annual_inc`a' = d_wage`a' * uhrswork * 52 if (raise `a' > 0 & raise`a' != .)

    replace affected`a' = direct`a' + indirect`a'
  }

di as txt _n(1) "Adding output variables to input microdata"
keep `id' `output_varlist'
tempfile results 
qui save `results'
restore
qui merge 1:1 `id' using `results', assert(3) nogenerate

end
