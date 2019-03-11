* create microdata used for model input
* the final microdata needs a minimum wage schedule and population adjustment factors
* this is currently just some example code with example data

load_epiextracts, begin(2018m1) end(2018m12) sample(org)

* create unique id
gen uniqueid = _n

* merge min wage data
merge m:1 statecensus month using "${inputdir}example_stmin.dta", assert(3) nogenerate

* identify tipped workers
* first identify industries with tipped food servers
gen byte tippedind = .
* 8580 Bowling centers
replace tippedind = 1 if ind12 == 8580
* 8590 Other amusement, gambling, and recreation industries
replace tippedind = 1 if ind12 == 8590
* 8660 Traveler accommodation
replace tippedind = 1 if ind12 == 8660
* 8670 Recreational vehicle parks and camps, and rooming/boarding houses
replace tippedind = 1 if ind12 == 8670
* 8680 Restaurants and other food services
replace tippedind = 1 if ind12 == 8680
* 8690 Drinking places, alcoholic beverages
replace tippedind = 1 if ind12 == 8690
* 8970 Barber shops
replace tippedind = 1 if ind12 == 8970
* 8980 Beauty salons
replace tippedind = 1 if ind12 == 8980
* 8990 Nail salons and other personal care services
replace tippedind = 1 if ind12 == 8990
* 9090 Other personal services
replace tippedind = 1 if ind12 == 9090

* identify tipped status
gen byte tipped = 0
* 4040 Bartenders
replace tipped = 1 if occ10 == 4040
* 4060 Counter attendants, cafeteria, food concession, and coffee shop
replace tipped = 1 if occ10 == 4060
* 4110 Waiters and waitresses
replace tipped = 1 if occ10 == 4110
* 4130 Dining room and cafeteria attendants and bartender helpers
replace tipped = 1 if occ10 == 4130
* 4400 Gaming services workers
replace tipped = 1 if occ10 == 4400
* 4500 Barbers
replace tipped = 1 if occ10 == 4500
* 4510 Hairdressers, hairstylists, and cosmetologists
replace tipped = 1 if occ10 == 4510
* 4520 Miscellaneous personal appearance workers
replace tipped = 1 if occ10 == 4520
* 4120 Nonrestaurant food servers in tipped industry
replace tipped = 1 if occ10 == 4120 & tippedind == 1

* mark certain obs as ineligible for increases
gen byte wagevalid = 0
replace wagevalid = 1 if tipped == 0 & wageotc > 0 & wageotc ~= . & wageotc >= 0.80 * mw2018
replace wagevalid = 1 if tipped == 1 & wageotc > 0 & wageotc ~= . & wageotc >= 0.80 * tipmw2018
gen byte eligible = emp == 1 & wagevalid == 1

* merge population adjustments
merge m:1 wbhao using ${inputdir}example_popadjust.dta, assert(3) nogenerate

compress
saveold "${inputdir}example_inputdata.dta", replace version(13)
