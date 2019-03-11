* create a schedule of minimum wages by geographic area and time
* this is currently just some example code with example data

import delimited using ${inputdir}example_stmin.csv, clear

* geographic identifier
rename state statecensus

* ensure panel is balanced
gen yearmonth = ym(year, month)
tsset statecensus yearmonth
assert r(balanced) == "strongly balanced"
drop yearmonth

* keep year of data through end of policy
keep if year >= 2018 & year <= 2024

reshape wide mw tipmw, i(statecensus month) j(year)

keep statecensus month mw* tipmw*

compress
saveold ${inputdir}example_stmin.dta, replace version(13)
