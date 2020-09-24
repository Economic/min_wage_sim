*Load correct minimum wage and tipped minimum wage values for data year of
*dataset and month and years of each proposed increase
*create data set of all relevant state minimum wages 
clear all

import delimited using `1'.csv

label variable new_mw "Proposed minimum wage"
label variable new_tw "Proposed tipped minimum wage"

gen mdate = ym(year,month)
format %tm mdate
label variable mdate "Date of proposed min wage change"

gen step=_n-1
global steps = _N-1

tempfile modelinputs
save `modelinputs', replace

*assign upper bound for spillover effects and lower bound for direct effects
scalar lower_bound = `2'
scalar spillover = `3'

*import actual and projected CPI values for data year and increase periods 
merge 1:m mdate using ${data}cpi_projections
keep if _merge==3
drop _merge

*merge in state minimum and tipped minimum wages
merge 1:m mdate using ${allstmins}
keep if _merge==3
drop _merge

*drop mdate
drop month
drop year
drop quarter

reshape wide new_mw new_tw stmin tipmin mdate cpi_u, i(pwstate) j(step)

drop new_mw0 new_tw0

*create global macro with CPI value for data period
scalar cpi0 = cpi_u0
drop cpi_u0

label variable stmin0 "State minimum wage in data period"
label variable tipmin0 "State tipped minimum wage in data period"
label variable mdate0 "Date of data period"

forvalues a = 1/$steps {
    label variable stmin`a' "State minimum wage at Step `a'"
    label variable tipmin`a' "State tipped minimum wage at Step `a'"

    *create scalars with proposed new minimum and tipped minimums
    scalar prop_mw`a' = new_mw`a'
    scalar prop_tw`a' = new_tw`a'

    global increase_date`a' = mdate`a'

    *create global macro with months between steps
    scalar months_to_`a' = mdate`a' - mdate`=`a'-1'

    *create scalars with projected CPI values at each step 
    scalar cpi`a' = cpi_u`a'
    drop cpi_u`a'
}

drop new_mw* new_tw* mdate*

*save file of relevant minimum wages
save $active_stmins, replace

clear

use `modelinputs'
merge 1:m mdate using ${all_localmins}
keep if _merge == 3
drop _merge month year new_mw new_tw

reshape wide local_mw local_tw mdate, i(pwstate pwpuma) j(step)

drop mdate*
save ${active_localmins}, replace
