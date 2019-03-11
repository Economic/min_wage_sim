* create annual population adjustments
* this is currently just some example code with example data

clear
set obs 1
gen popadjust_annual = .
gen wbhao = .

* White
replace wbhao = 1 if wbhao == .
replace popadjust_annual = -0.003 if wbhao == 1
moreobs 1

* Black
replace wbhao = 2 if wbhao == .
replace popadjust_annual = 0.010 if wbhao == 2
moreobs 1

* Hispanic
replace wbhao = 3 if wbhao == .
replace popadjust_annual = 0.025 if wbhao == 3
moreobs 1

* Asian
replace wbhao = 4 if wbhao == .
replace popadjust_annual = 0.021 if wbhao == 4
moreobs 1

* Other
replace wbhao = 5 if wbhao == .
replace popadjust_annual = 0.020 if wbhao == 5

compress
saveold ${inputdir}example_popadjust.dta, replace version(13)
