*Loads CPI values and projected CPI vales and saves in data folder

clear

import delimited using `1'.csv

label var quarter "Calendar quarter"
drop yearmonth

gen mdate = ym(year,month)
format %tm mdate

keep mdate quarter cpi_u
drop if cpi_u == .

save ${data}cpi_projections, replace
