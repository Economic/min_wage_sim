*calculate counts/shares of affected workers by demographic group for each step
clear all

save ${data}outputdata, replace emptyok

tempfile bygroup_affected

use $simdata, clear

foreach q in `0' {
    preserve
    sort `q'
    collapse (sum) pop=pop direct=direct$steps indirect=indirect$steps /// 
        d_wage=d_wage$steps d_annual_inc=d_annual_inc$steps ///
       (mean) m_pop=pop m_direct=direct$steps m_indirect=indirect$steps ///
        m_d_wage=d_wage$steps m_d_annual_inc=d_annual_inc$steps ///
       [pw=perwt$steps], by(`q')  

    decode `q', generate(category)
    insobs 1, before(1)
    local group_name : var label `q'
    replace category = "`group_name'" in 1
    
    drop `q'

    drop d_wage m_pop

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

    save `bygroup_affected', replace
    use ${data}outputdata, clear

    append using `bygroup_affected', force
    
    order category pop direct m_direct indirect m_indirect affected m_affected d_annual_inc /// 
    m_d_annual_inc m_d_wage 
    
    /*d_annual_inc_direct m_d_annual_inc_direct m_d_wage_direct ///
    d_annual_inc_indirect m_d_annual_inc_indirect m_d_wage_indirect*/
    save ${data}outputdata, replace
    restore
}
use ${data}outputdata, clear

export excel using ${outputfile}, sheet("Step $steps") ///	
	firstrow(varlabels) sheetreplace

erase ${data}outputdata.dta

