capture program drop create_log
program define create_log
syntax, inputdata(string asis) outputdata(string asis) outputlog(string asis) inputdatayear(integer) policybegyear(integer) policydates(string) cfactwagegrowth(real) idvar(name) wagevar(name) weightvar(name) popadjvar(name) eligiblevar(name)

* legible names
local inputdataname "Input data file"
local outputdataname "Output data file"
local outputlogname "Output log file"

local inputdatayearname "Year of input data"
local policybegyearname "Year policy begins"
local policydatesname "Policy dates"

local idvarname "Unique ID variable"
local wagevarname "Wage variable"
local weightvarname "Weight variable"
local popadjvarname "Annual pop. adj. variable"
local eligiblevarname "Eligibility flag variable"

local cfactwagegrowthname "Counterfactual annual wage growth"

* column placement
local col1end = 35
local col2beg = `col1end' + 2

* BEGIN LOG
log using `outputlog'
di _n(1)

di "Parameters"
foreach stat in inputdatayear policybegyear policydates cfactwagegrowth {
	di as text "``stat'name'" _column(`col1end') "{c |}" _column(`col2beg') `"``stat''"'
}

di _n(1)

di "File names"
foreach stat in inputdata outputdata outputlog {
	di as text "``stat'name'" _column(`col1end') "{c |}" _column(`col2beg') `"``stat''"'
}

di _n(1)

di "Input variables"
foreach stat in idvar wagevar weightvar popadjvar eligiblevar {
	di as text "``stat'name'" _column(`col1end') "{c |}" _column(`col2beg') `"``stat''"'
}

di _n(1)

* END LOG

log close

end
