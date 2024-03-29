capture program drop mwsim_analyze
program define mwsim_analyze
syntax, microdata(string) steps(integer) OUTPUT_excel(string) [by(string)]

***********************
*** OVERALL RESULTS ***
***********************
di as txt _n(1) "Calculating overall affected totals"
qui forvalues i = 1 / `steps' {
    noi di as txt "... step `i'"
    use direct`i' indirect`i' d_annual_inc`i' cf_annual_inc`i' d_wage`i' d_annual_inc`i' perwt`i' using `microdata', clear
    gen byte pop = 1
    gcollapse ///
        (sum) pop direct = direct`i' indirect = indirect`i' ///
        d_annual_inc = d_annual_inc`i' cf_annual_inc = cf_annual_inc`i' ///
        (mean) m_direct = direct`i' m_indirect = indirect`i' m_d_wage = d_wage`i' m_d_annual_inc = d_annual_inc`i' ///
        [pw=perwt`i']  
    gen step = `i'
    tempfile step`i'
    save `step`i''
}
clear 
forvalues i = 1 / `steps' {
    append using `step`i''
}

gen affected = direct + indirect
label var affected "Total affected directly or indirectly"

gen m_affected = m_direct + m_indirect
label var m_affected "Share affected directly or indirectly"
label var pop "Wage-earning workforce"
label var direct "Count directly affected"
label var indirect "Count indirectly affected"
label var m_direct "Share directly affected"
label var m_indirect "Share indirectly affected"
label var d_annual_inc "Total change in annual wage bill"
label var cf_annual_inc "Total counterfactual annual wage bill"
label var m_d_annual_inc "Average change in annual wages"
label var m_d_wage "Average change in hourly wages"

format pop direct indirect affected m_d_annual_inc %12.0fc
format d_annual_inc %14.0fc
format m_direct m_indirect m_affected %6.3fc
format m_d_wage %8.2fc

tempfile results_overall 
qui save `results_overall'

qui foreach x in direct indirect {
    noi di as txt _n(1) "Calculating overall `x'ly affected income changes"
    forvalues i = 1 / `steps' {
        noi di as txt "... step `i'"
        use d_wage`i' d_annual_inc`i' cf_annual_inc`i' d_wage`i' d_annual_inc`i' perwt`i' `x'`i' using `microdata', clear
        gcollapse ///
            (sum) d_annual_inc_`x' = d_annual_inc`i' cf_annual_inc_`x' = cf_annual_inc`i' ///
            (mean) m_d_wage_`x' = d_wage`i' m_d_annual_inc_`x' = d_annual_inc`i' ///
            if `x'`i' == 1 [pw=perwt`i'] 
        gen step = `i'
        tempfile step`i'_`x'
        save `step`i'_`x''
    }

    clear 
    forvalues i = 1 / `steps' {
        append using `step`i'_`x''
    }
    tempfile results_`x'
    save `results_`x''
}

use `results_overall', clear 
qui merge 1:1 step using `results_direct', assert(3) nogenerate
qui merge 1:1 step using `results_indirect', assert(3) nogenerate

order step pop ///
    direct m_direct indirect m_indirect affected m_affected ///
    d_annual_inc cf_annual_inc m_d_annual_inc m_d_wage ///
    d_annual_inc_direct cf_annual_inc_direct m_d_annual_inc_direct m_d_wage_direct ///
    d_annual_inc_indirect cf_annual_inc_indirect m_d_annual_inc_indirect m_d_wage_indirect

di _n(1) "Saving overall results to spreadsheet" _n(1)
export excel using `output_excel', sheet("Summary") firstrow(varlabels) replace


******************************
*** GROUP-SPECIFIC RESULTS ***
******************************
qui if "`by'" != "" {
    noi di as txt _n(1) "Calculating group-specific results for step `steps'"
    foreach group in `by' {
        noi di as text "... `group'"
        local i = `steps'
        use direct`i' indirect`i' d_annual_inc`i' direct`i' indirect`i' d_wage`i' d_annual_inc`i' perwt`i' `group' using `microdata', clear
        gen byte pop = 1

        gcollapse ///
            (sum) pop direct = direct`i' indirect = indirect`i' d_annual_inc = d_annual_inc`i' ///
            (mean) m_direct = direct`i' m_indirect = indirect`i' m_d_wage = d_wage`i' m_d_annual_inc = d_annual_inc`i' ///
            [pw=perwt`i'], by(`group')  

        decode `group', generate(category)
        insobs 1, before(1)
        local group_name : var label `group'
        replace category = "`group_name'" in 1
        drop `group'

        tempfile group`group'
        save `group`group''
    }

    clear 
    foreach group in `by' {
        append using `group`group''
    }
            
    label var category "Group"
    label var pop "Wage-earning workforce"
    
    gen affected = direct + indirect
    label var affected "Total affected directly or indirectly"

    gen m_affected = m_direct + m_indirect
    label var m_affected "Share affected directly or indirectly"

    label var direct "Count directly affected"
    label var indirect "Count indirectly affected"
    label var m_direct "Share directly affected"
    label var m_indirect "Share indirectly affected"
    label var d_annual_inc "Total change in annual wagebill"
    label var m_d_annual_inc "Average change in annual wages"
    label var m_d_wage "Average change in hourly wages"

    format pop direct indirect affected m_d_annual_inc %12.0fc
    format d_annual_inc %14.0fc
    format m_direct m_indirect m_affected %6.3fc
    format m_d_wage %8.2fc

    order category pop direct m_direct indirect m_indirect affected m_affected d_annual_inc /// 
    m_d_annual_inc m_d_wage 

    noi di _n(1) "Adding group-specific results for step `steps' to spreadsheet" _n(1)
    noi export excel using `output_excel', sheet("Step `steps'") firstrow(varlabels) sheetreplace
}

end
