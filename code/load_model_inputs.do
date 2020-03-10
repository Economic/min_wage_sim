*Load correct minimum wage and tipped minimum wage values for data year of
*dataset and month and years of each proposed increase

*create data set of all relevant state minimum wages 

import delimited using `1'.csv

label variable new_mw "Proposed minimum wage"
label variable new_tw "Proposed tipped minimum wage"

gen mdate = ym(year,month)
format %tm mdate
label variable mdate "Date of proposed min wage change"

gen step=_n-1
global steps = _N-1

merge 1:m mdate using ${allmins}
keep if _merge==3
drop _merge

drop mdate
drop month
drop year

reshape wide new_mw new_tw stmin tipmin, i(pwstate) j(step)

drop new_mw0 new_tw0

label variable stmin0 "State minimum wage at in data period"
label variable tipmin0 "State tipped minimum wage in data period"

forvalues a = 1/$steps {
    label variable stmin`a' "State minimum wage at Step `a'"
    label variable tipmin`a' "State tipped minimum wage at Step `a'"
    label variable new_mw`a' "Proposed minimum wage at Step `a'"
    label variable new_tw`a' "Proposed tipped minimum wage at Step `a'"
}

*save file of relevant minimum wages
save $activemins, replace
