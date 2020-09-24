*identify directly and indirectly affected workers in each step

clear*

tempfile all_affected
save `all_affected', emptyok

use $simdata, clear

forvalues a = 1/$steps {
    preserve
    collapse (sum) pop=pop direct=direct`a' indirect=indirect`a' d_wage=d_wage`a' d_annual_inc=d_annual_inc`a' ///
        (mean) m_pop=pop m_direct=direct`a' m_indirect=indirect`a' m_d_wage=d_wage`a' m_d_annual_inc=d_annual_inc`a' ///
        [pw=perwt`a']  

    drop m_pop d_wage
    gen step = `a'

    append using `all_affected'
    save `"`all_affected'"', replace
    restore
}

use `all_affected', clear
sort step

gen affected = direct + indirect
label var affected "Total affected directly or indirectly"

gen m_affected = m_direct + m_indirect
label var m_affected "Share affected directly or indirectly"
label var pop "Wage-earning workforce"
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

*save `"`all_affected'"', replace
save ${data}outputdata, replace

erase `all_affected'

clear all

program type_affected
    clear

    *Directly affected
    tempfile `1'_affected
    save ``1'_affected', emptyok

    use $simdata, clear

    forvalues a = 1/$steps {
        preserve
        collapse (sum) d_wage_`1'=d_wage`a' d_annual_inc_`1'=d_annual_inc`a' ///
            (mean) m_d_wage_`1'=d_wage`a' m_d_annual_inc_`1'=d_annual_inc`a' ///
            [pw=perwt`a'] if `1'`a' == 1

        drop d_wage_`1' 
        gen step = `a'
        append using ``1'_affected'
        save `"``1'_affected'"', replace
        restore
    }

    use ``1'_affected', clear

    label var m_d_wage_`a' "Average change in hourly wage (`1' only)"
    label var d_annual_inc_`1' "Total change in annual wagebill (`1' only)"
    label var m_d_annual_inc_`1' "Average change in annual wages (`1' only)"

    sort step
    save `"``1'_affected'"', replace
end

capture type_affected direct

merge 1:1 step using ${data}outputdata
drop _merge

save ${data}outputdata, replace

capture type_affected indirect

merge 1:1 step using ${data}outputdata
drop _merge

order step pop direct m_direct indirect m_indirect affected m_affected d_annual_inc /// 
    m_d_annual_inc m_d_wage d_annual_inc_direct m_d_annual_inc_direct m_d_wage_direct ///
    d_annual_inc_indirect m_d_annual_inc_indirect m_d_wage_indirect

save ${data}outputdata, replace

export excel using ${outputfile}, sheet("Summary") ///	
	firstrow(varlabels) sheetreplace

*erase ${data}outputdata.dta

