* create a schedule of counterfactual minimum wages by geographic area and time
* this is currently just some example code with example data

import delimited using ${inputdir}example_cf_stmin.csv, clear

* geographic identifier
rename state statecensus

* ensure panel is balanced
gen yearmonth = ym(year, month)
tsset statecensus yearmonth
assert r(balanced) == "strongly balanced"
drop yearmonth

* keep year of data through end of policy
keep if year >= 2018 & year <= 2024

rename mw cf_mw
rename tipmw cf_tipmw

keep statecensus year month cf_mw cf_tipmw

compress
saveold ${inputdir}example_cf_stmin.dta, replace version(13)


* create a schedule of policy min wages
* this is currently some example code with example data
* you could alternatively import this, rather than hand-code as below

clear
gen year = .
gen step = .

forvalues i = 2019/2024 {
	moreobs 1
	replace year = `i' if year == .
	replace step = _n if step == .
}

gen policy_mw = .
replace policy_mw =  8.55 if year == 2019
replace policy_mw =  9.85 if year == 2020
replace policy_mw = 11.15 if year == 2021
replace policy_mw = 12.45 if year == 2022
replace policy_mw = 13.75 if year == 2023
replace policy_mw = 15.00 if year == 2024

gen policy_tipmw = .
replace policy_tipmw =  3.60 if year == 2019
replace policy_tipmw =  5.10 if year == 2020
replace policy_tipmw =  6.60 if year == 2021
replace policy_tipmw =  8.10 if year == 2022
replace policy_tipmw =  9.60 if year == 2023
replace policy_tipmw = 11.10 if year == 2024

saveold ${inputdir}example_policy_stmin.dta, replace version(13)
