*create local minimum wages by PWPUMA for min wage sim model
*9/20/2020
*D.Cooper

set more off
*set trace on
clear all

global base /projects/dcooper/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/
global log ${base}logs/

global allmins ${data}stmins.dta
global active_stmins ${data}sim_active_mins.dta
global simdata ${data}allsimdata.dta

use ${data}pwpuma_months.dta

gen local_mw = .
gen local_tw = .

*Arizona
**Flagstaff - uses all of Coconino County
replace local_mw = 10 if pwstate == 4 & pwpuma == 400 & year == 2017 & month < 7  
replace local_mw = 10.5 if pwstate == 4 & pwpuma == 400 & year == 2017 & month >= 7
replace local_mw = 11 if pwstate == 4 & pwpuma == 400 & year == 2018
replace local_mw = 12 if pwstate == 4 & pwpuma == 400 & year == 2019
replace local_mw = 13 if pwstate == 4 & pwpuma == 400 & year == 2020
replace local_mw = 15 if pwstate == 4 & pwpuma == 400 & year == 2021
replace local_mw = 15.5 if pwstate == 4 & pwpuma == 400 & year == 2022
replace local_mw = 15.8 if pwstate == 4 & pwpuma == 400 & year == 2023
replace local_mw = 16.15 if pwstate == 4 & pwpuma == 400 & year == 2024
replace local_mw = 16.5 if pwstate == 4 & pwpuma == 400 & year == 2025
replace local_mw = 16.85 if pwstate == 4 & pwpuma == 400 & year == 2026
replace local_mw = 17.25 if pwstate == 4 & pwpuma == 400 & year == 2027
replace local_mw = 17.65 if pwstate == 4 & pwpuma == 400 & year == 2028
replace local_mw = 18.05 if pwstate == 4 & pwpuma == 400 & year == 2029

replace local_tw = 9 if pwstate == 4 & pwpuma == 400 & year == 2017 
replace local_tw = 9.5 if pwstate == 4 & pwpuma == 400 & year == 2018
replace local_tw = 10 if pwstate == 4 & pwpuma == 400 & year == 2019
replace local_tw = 11 if pwstate == 4 & pwpuma == 400 & year == 2020
replace local_tw = 12 if pwstate == 4 & pwpuma == 400 & year == 2021
replace local_tw = 13 if pwstate == 4 & pwpuma == 400 & year == 2022
replace local_tw = 13.8 if pwstate == 4 & pwpuma == 400 & year == 2023
replace local_tw = 14.65 if pwstate == 4 & pwpuma == 400 & year == 2024
replace local_tw = 15.5 if pwstate == 4 & pwpuma == 400 & year == 2025
replace local_tw = 16.85 if pwstate == 4 & pwpuma == 400 & year == 2026
replace local_tw = 17.25 if pwstate == 4 & pwpuma == 400 & year == 2027
replace local_tw = 17.65 if pwstate == 4 & pwpuma == 400 & year == 2028
replace local_tw = 18.05 if pwstate == 4 & pwpuma == 400 & year == 2029

*Illinios
**Chicago and Cook County - Uses Cook County minimum
replace local_mw = 10 if pwstate == 17 & pwpuma == 3400 & year == 2017 & month >= 7
replace local_mw = 10 if pwstate == 17 & pwpuma == 3400 & year == 2018 & month < 7
replace local_mw = 11 if pwstate == 17 & pwpuma == 3400 & year == 2018 & month >= 7
replace local_mw = 11 if pwstate == 17 & pwpuma == 3400 & year == 2019 & month < 7
replace local_mw = 12 if pwstate == 17 & pwpuma == 3400 & year == 2019 & month >= 7
replace local_mw = 12 if pwstate == 17 & pwpuma == 3400 & year == 2020 & month < 7
replace local_mw = 13 if pwstate == 17 & pwpuma == 3400 & year == 2020 & month >= 7
replace local_mw = 13 if pwstate == 17 & pwpuma == 3400 & year == 2021 & month < 7
replace local_mw = 13.2 if pwstate == 17 & pwpuma == 3400 & year == 2021 & month >= 7
replace local_mw = 13.2 if pwstate == 17 & pwpuma == 3400 & year == 2022 & month < 7
replace local_mw = 13.45 if pwstate == 17 & pwpuma == 3400 & year == 2022 & month >= 7
replace local_mw = 13.45 if pwstate == 17 & pwpuma == 3400 & year == 2023 & month < 7
replace local_mw = 13.75 if pwstate == 17 & pwpuma == 3400 & year == 2023 & month >= 7
replace local_mw = 13.75 if pwstate == 17 & pwpuma == 3400 & year == 2024 & month < 7
*Illinois State MW will overtake cook county on Jan 1 2024 when it goes to $14, but county ///
    will go above for 6 months in July
replace local_mw = 14.05 if pwstate == 17 & pwpuma == 3400 & year == 2024 & month >= 7
replace local_mw = 14.05 if pwstate == 17 & pwpuma == 3400 & year == 2026 & month < 7

replace local_tw = 5.1 if pwstate == 17 & pwpuma == 3400 & year == 2018 & month >= 7
replace local_tw = 5.1 if pwstate == 17 & pwpuma == 3400 & year == 2019 & month < 7
replace local_tw = 5.2 if pwstate == 17 & pwpuma == 3400 & year == 2019 & month >= 7
replace local_tw = 5.2 if pwstate == 17 & pwpuma == 3400 & year == 2020 & month < 7
replace local_tw = 5.25 if pwstate == 17 & pwpuma == 3400 & year == 2020 & month >= 7
replace local_tw = 5.25 if pwstate == 17 & pwpuma == 3400 & year == 2021 & month < 7
replace local_tw = 5.35 if pwstate == 17 & pwpuma == 3400 & year == 2021 & month >= 7
replace local_tw = 5.35 if pwstate == 17 & pwpuma == 3400 & year == 2022 & month < 7
replace local_tw = 5.45 if pwstate == 17 & pwpuma == 3400 & year == 2022 & month >= 7
replace local_tw = 5.45 if pwstate == 17 & pwpuma == 3400 & year == 2023 & month < 7
replace local_tw = 5.55 if pwstate == 17 & pwpuma == 3400 & year == 2023 & month >= 7
replace local_tw = 5.55 if pwstate == 17 & pwpuma == 3400 & year == 2024 & month < 7
replace local_tw = 5.65 if pwstate == 17 & pwpuma == 3400 & year == 2024 & month >= 7
replace local_tw = 5.65 if pwstate == 17 & pwpuma == 3400 & year == 2025 & month < 7
replace local_tw = 5.8 if pwstate == 17 & pwpuma == 3400 & year == 2025 & month >= 7
replace local_tw = 5.8 if pwstate == 17 & pwpuma == 3400 & year == 2026 & month < 7
replace local_tw = 5.95 if pwstate == 17 & pwpuma == 3400 & year == 2026 & month >= 7
replace local_tw = 5.95 if pwstate == 17 & pwpuma == 3400 & year == 2027 & month < 7
replace local_tw = 6.1 if pwstate == 17 & pwpuma == 3400 & year == 2027 & month >= 7
replace local_tw = 6.1 if pwstate == 17 & pwpuma == 3400 & year == 2028 & month < 7
replace local_tw = 6.25 if pwstate == 17 & pwpuma == 3400 & year == 2028 & month >= 7
replace local_tw = 6.25 if pwstate == 17 & pwpuma == 3400 & year == 2029 & month < 7
replace local_tw = 6.4 if pwstate == 17 & pwpuma == 3400 & year == 2029 & month >= 7
replace local_tw = 6.4 if pwstate == 17 & pwpuma == 3400 & year == 2030 & month < 7

*Maine
**Portland and surrounding areas (SE Maine)
replace local_mw = 10.1 if pwstate == 23 & pwpuma == 790 & year == 2016
replace local_mw = 10.68 if pwstate == 23 & pwpuma == 790 & year == 2017
replace local_mw = 10.68 if pwstate == 23 & pwpuma == 790 & year == 2018 & month < 7
replace local_mw = 10.9 if pwstate == 23 & pwpuma == 790 & year == 2018 & month >= 7
replace local_mw = 10.9 if pwstate == 23 & pwpuma == 790 & year == 2019 & month < 7
replace local_mw = 11.17 if pwstate == 23 & pwpuma == 790 & year == 2019 & month >= 7
*State MW overtakes in Jan 2020
*State TW is above local TW from 2017 onward

*Maryland
**Montgomery County
replace local_mw = 8.4 if pwstate == 24 & pwpuma == 1000 & year == 2014 & month >= 10
replace local_mw = 8.4 if pwstate == 24 & pwpuma == 1000 & year == 2015 & month < 10
replace local_mw = 9.55 if pwstate == 24 & pwpuma == 1000 & year == 2015 & month >= 10
replace local_mw = 9.55 if pwstate == 24 & pwpuma == 1000 & year == 2016 & month < 10
replace local_mw = 10.75 if pwstate == 24 & pwpuma == 1000 & year == 2016 & month >= 10
replace local_mw = 10.75 if pwstate == 24 & pwpuma == 1000 & year == 2017 & month < 10
replace local_mw = 11.50 if pwstate == 24 & pwpuma == 1000 & year == 2017 & month >= 10
replace local_mw = 11.50 if pwstate == 24 & pwpuma == 1000 & year == 2018 & month < 7
replace local_mw = 12.25 if pwstate == 24 & pwpuma == 1000 & year == 2018 & month >= 7
replace local_mw = 12.25 if pwstate == 24 & pwpuma == 1000 & year == 2019 & month < 7
replace local_mw = 13 if pwstate == 24 & pwpuma == 1000 & year == 2019 & month >= 7
replace local_mw = 13 if pwstate == 24 & pwpuma == 1000 & year == 2020 & month < 7
replace local_mw = 14 if pwstate == 24 & pwpuma == 1000 & year == 2020 & month >= 7
replace local_mw = 14 if pwstate == 24 & pwpuma == 1000 & year == 2021 & month < 7
replace local_mw = 15 if pwstate == 24 & pwpuma == 1000 & year == 2021 & month >= 7
replace local_mw = 15 if pwstate == 24 & pwpuma == 1000 & year == 2022 & month < 7
replace local_mw = 15.21 if pwstate == 24 & pwpuma == 1000 & year == 2022 & month >= 7
replace local_mw = 15.21 if pwstate == 24 & pwpuma == 1000 & year == 2023 & month < 7
replace local_mw = 15.5 if pwstate == 24 & pwpuma == 1000 & year == 2023 & month >= 7
replace local_mw = 15.5 if pwstate == 24 & pwpuma == 1000 & year == 2024 & month < 7
replace local_mw = 15.83 if pwstate == 24 & pwpuma == 1000 & year == 2024 & month >= 7
replace local_mw = 15.83 if pwstate == 24 & pwpuma == 1000 & year == 2025 & month < 7
replace local_mw = 16.19 if pwstate == 24 & pwpuma == 1000 & year == 2025 & month >= 7
replace local_mw = 16.19 if pwstate == 24 & pwpuma == 1000 & year == 2026 & month < 7
replace local_mw = 16.55 if pwstate == 24 & pwpuma == 1000 & year == 2026 & month >= 7
replace local_mw = 16.55 if pwstate == 24 & pwpuma == 1000 & year == 2027 & month < 7
replace local_mw = 16.92 if pwstate == 24 & pwpuma == 1000 & year == 2027 & month >= 7
replace local_mw = 16.92 if pwstate == 24 & pwpuma == 1000 & year == 2028 & month < 7
replace local_mw = 17.30 if pwstate == 24 & pwpuma == 1000 & year == 2028 & month >= 7
replace local_mw = 17.30 if pwstate == 24 & pwpuma == 1000 & year == 2029 & month < 7
replace local_mw = 17.68 if pwstate == 24 & pwpuma == 1000 & year == 2029 & month >= 7

replace local_tw = 4 if pwstate == 24 & pwpuma == 1000 & year == 2014 & month >= 10
replace local_tw = 4 if pwstate == 24 & pwpuma == 1000 & year > 2014 & year != .

**Prince Georges County
replace local_mw = 8.4 if pwstate == 24 & pwpuma == 1100 & year == 2014 & month >= 10
replace local_mw = 8.4 if pwstate == 24 & pwpuma == 1100 & year == 2015 & month < 10
replace local_mw = 9.55 if pwstate == 24 & pwpuma == 1100 & year == 2015 & month >= 10
replace local_mw = 9.55 if pwstate == 24 & pwpuma == 1100 & year == 2016 & month < 10
replace local_mw = 10.75 if pwstate == 24 & pwpuma == 1100 & year == 2016 & month >= 10
replace local_mw = 10.75 if pwstate == 24 & pwpuma == 1100 & year == 2017 & month < 10
replace local_mw = 11.50 if pwstate == 24 & pwpuma == 1100 & year == 2017 & month >= 10
replace local_mw = 11.50 if pwstate == 24 & pwpuma == 1100 & year >= 2018 & month != .

*PGC has no local tipped min - it's equal to the state tipped min

*Minnesota
**Minneapolis
replace local_mw = 10 if pwstate == 27 & pwpuma == 1400 & year == 2018 & month < 7
replace local_mw = 11.25 if pwstate == 27 & pwpuma == 1400 & year == 2018 & month >= 7
replace local_mw = 11.25 if pwstate == 27 & pwpuma == 1400 & year == 2019 & month < 7
replace local_mw = 12.25 if pwstate == 27 & pwpuma == 1400 & year == 2019 & month >= 7
replace local_mw = 12.25 if pwstate == 27 & pwpuma == 1400 & year == 2020 & month < 7
replace local_mw = 13.25 if pwstate == 27 & pwpuma == 1400 & year == 2020 & month >= 7
replace local_mw = 13.25 if pwstate == 27 & pwpuma == 1400 & year == 2021 & month < 7
replace local_mw = 14.25 if pwstate == 27 & pwpuma == 1400 & year == 2021 & month >= 7
replace local_mw = 14.25 if pwstate == 27 & pwpuma == 1400 & year == 2022 & month < 7
replace local_mw = 15 if pwstate == 27 & pwpuma == 1400 & year == 2022 & month >= 7
replace local_mw = 15 if pwstate == 27 & pwpuma == 1400 & year == 2023 & month < 7
replace local_mw = 15.32 if pwstate == 27 & pwpuma == 1400 & year == 2023 & month >= 7
replace local_mw = 15.32 if pwstate == 27 & pwpuma == 1400 & year == 2024 & month < 7
replace local_mw = 15.67 if pwstate == 27 & pwpuma == 1400 & year == 2024 & month >= 7
replace local_mw = 15.67 if pwstate == 27 & pwpuma == 1400 & year == 2025 & month < 7
replace local_mw = 16.02 if pwstate == 27 & pwpuma == 1400 & year == 2025 & month >= 7
replace local_mw = 16.02 if pwstate == 27 & pwpuma == 1400 & year == 2026 & month < 7
replace local_mw = 16.38 if pwstate == 27 & pwpuma == 1400 & year == 2026 & month >= 7
replace local_mw = 16.74 if pwstate == 27 & pwpuma == 1400 & year == 2027 & month < 7
replace local_mw = 16.74 if pwstate == 27 & pwpuma == 1400 & year == 2027 & month >= 7
replace local_mw = 17.11 if pwstate == 27 & pwpuma == 1400 & year == 2028 & month < 7
replace local_mw = 17.11 if pwstate == 27 & pwpuma == 1400 & year == 2028 & month >= 7
replace local_mw = 17.49 if pwstate == 27 & pwpuma == 1400 & year == 2029 & month < 7
replace local_mw = 17.49 if pwstate == 27 & pwpuma == 1400 & year == 2029 & month >= 7

replace local_tw = 10 if pwstate == 27 & pwpuma == 1400 & year == 2018 & month < 7
replace local_tw = 11.25 if pwstate == 27 & pwpuma == 1400 & year == 2018 & month >= 7
replace local_tw = 11.25 if pwstate == 27 & pwpuma == 1400 & year == 2019 & month < 7
replace local_tw = 12.25 if pwstate == 27 & pwpuma == 1400 & year == 2019 & month >= 7
replace local_tw = 12.25 if pwstate == 27 & pwpuma == 1400 & year == 2020 & month < 7
replace local_tw = 13.25 if pwstate == 27 & pwpuma == 1400 & year == 2020 & month >= 7
replace local_tw = 13.25 if pwstate == 27 & pwpuma == 1400 & year == 2021 & month < 7
replace local_tw = 14.25 if pwstate == 27 & pwpuma == 1400 & year == 2021 & month >= 7
replace local_tw = 14.25 if pwstate == 27 & pwpuma == 1400 & year == 2022 & month < 7
replace local_tw = 15 if pwstate == 27 & pwpuma == 1400 & year == 2022 & month >= 7
replace local_tw = 15 if pwstate == 27 & pwpuma == 1400 & year == 2023 & month < 7
replace local_tw = 15.32 if pwstate == 27 & pwpuma == 1400 & year == 2023 & month >= 7
replace local_tw = 15.32 if pwstate == 27 & pwpuma == 1400 & year == 2024 & month < 7
replace local_tw = 15.67 if pwstate == 27 & pwpuma == 1400 & year == 2024 & month >= 7
replace local_tw = 15.67 if pwstate == 27 & pwpuma == 1400 & year == 2025 & month < 7
replace local_tw = 16.02 if pwstate == 27 & pwpuma == 1400 & year == 2025 & month >= 7
replace local_tw = 16.02 if pwstate == 27 & pwpuma == 1400 & year == 2026 & month < 7
replace local_tw = 16.38 if pwstate == 27 & pwpuma == 1400 & year == 2026 & month >= 7
replace local_tw = 16.74 if pwstate == 27 & pwpuma == 1400 & year == 2027 & month < 7
replace local_tw = 16.74 if pwstate == 27 & pwpuma == 1400 & year == 2027 & month >= 7
replace local_tw = 17.11 if pwstate == 27 & pwpuma == 1400 & year == 2028 & month < 7
replace local_tw = 17.11 if pwstate == 27 & pwpuma == 1400 & year == 2028 & month >= 7
replace local_tw = 17.49 if pwstate == 27 & pwpuma == 1400 & year == 2029 & month < 7
replace local_tw = 17.49 if pwstate == 27 & pwpuma == 1400 & year == 2029 & month >= 7

**St. Paul
replace local_mw = 12.50 if pwstate == 27 & pwpuma == 1300 & year >= 2020 & year < 2022
replace local_mw = 12.50 if pwstate == 27 & pwpuma == 1300 & year == 2022 & month < 7
replace local_mw = 15 if pwstate == 27 & pwpuma == 1300 & year == 2022 & month >= 7
replace local_mw = 15 if pwstate == 27 & pwpuma == 1300 & year == 2023 & month < 7
replace local_mw = 15.32 if pwstate == 27 & pwpuma == 1300 & year == 2023 & month >= 7
replace local_mw = 15.32 if pwstate == 27 & pwpuma == 1300 & year == 2024 & month < 7
replace local_mw = 15.67 if pwstate == 27 & pwpuma == 1300 & year == 2024 & month >= 7
replace local_mw = 15.67 if pwstate == 27 & pwpuma == 1300 & year == 2025 & month < 7
replace local_mw = 16.02 if pwstate == 27 & pwpuma == 1300 & year == 2025 & month >= 7
replace local_mw = 16.02 if pwstate == 27 & pwpuma == 1300 & year == 2026 & month < 7
replace local_mw = 16.38 if pwstate == 27 & pwpuma == 1300 & year == 2026 & month >= 7
replace local_mw = 16.74 if pwstate == 27 & pwpuma == 1300 & year == 2027 & month < 7
replace local_mw = 16.74 if pwstate == 27 & pwpuma == 1300 & year == 2027 & month >= 7
replace local_mw = 17.11 if pwstate == 27 & pwpuma == 1300 & year == 2028 & month < 7
replace local_mw = 17.11 if pwstate == 27 & pwpuma == 1300 & year == 2028 & month >= 7
replace local_mw = 17.49 if pwstate == 27 & pwpuma == 1300 & year == 2029 & month < 7
replace local_mw = 17.49 if pwstate == 27 & pwpuma == 1300 & year == 2029 & month >= 7

replace local_tw = 12.50 if pwstate == 27 & pwpuma == 1300 & year >= 2020 & year < 2022
replace local_tw = 12.50 if pwstate == 27 & pwpuma == 1300 & year == 2022 & month < 7
replace local_tw = 15 if pwstate == 27 & pwpuma == 1300 & year == 2022 & month >= 7
replace local_tw = 15 if pwstate == 27 & pwpuma == 1300 & year == 2023 & month < 7
replace local_tw = 15.32 if pwstate == 27 & pwpuma == 1300 & year == 2023 & month >= 7
replace local_tw = 15.32 if pwstate == 27 & pwpuma == 1300 & year == 2024 & month < 7
replace local_tw = 15.67 if pwstate == 27 & pwpuma == 1300 & year == 2024 & month >= 7
replace local_tw = 15.67 if pwstate == 27 & pwpuma == 1300 & year == 2025 & month < 7
replace local_tw = 16.02 if pwstate == 27 & pwpuma == 1300 & year == 2025 & month >= 7
replace local_tw = 16.02 if pwstate == 27 & pwpuma == 1300 & year == 2026 & month < 7
replace local_tw = 16.38 if pwstate == 27 & pwpuma == 1300 & year == 2026 & month >= 7
replace local_tw = 16.74 if pwstate == 27 & pwpuma == 1300 & year == 2027 & month < 7
replace local_tw = 16.74 if pwstate == 27 & pwpuma == 1300 & year == 2027 & month >= 7
replace local_tw = 17.11 if pwstate == 27 & pwpuma == 1300 & year == 2028 & month < 7
replace local_tw = 17.11 if pwstate == 27 & pwpuma == 1300 & year == 2028 & month >= 7
replace local_tw = 17.49 if pwstate == 27 & pwpuma == 1300 & year == 2029 & month < 7
replace local_tw = 17.49 if pwstate == 27 & pwpuma == 1300 & year == 2029 & month >= 7

*New Mexico
**ABQ - Uses all of Bernalillo County
replace local_mw = 8.6 if pwstate == 35 & pwpuma == 790 & year == 2014
replace local_mw = 8.75 if pwstate == 35 & pwpuma == 790 & year == 2015
replace local_mw = 8.75 if pwstate == 35 & pwpuma == 790 & year == 2016
replace local_mw = 8.8 if pwstate == 35 & pwpuma == 790 & year == 2017
replace local_mw = 8.95 if pwstate == 35 & pwpuma == 790 & year == 2018
replace local_mw = 9.2 if pwstate == 35 & pwpuma == 790 & year == 2019
replace local_mw = 9.35 if pwstate == 35 & pwpuma == 790 & year == 2020
replace local_mw = 9.45 if pwstate == 35 & pwpuma == 790 & year == 2021
replace local_mw = 9.6 if pwstate == 35 & pwpuma == 790 & year == 2022
replace local_mw = 9.8 if pwstate == 35 & pwpuma == 790 & year == 2023
replace local_mw = 10 if pwstate == 35 & pwpuma == 790 & year == 2024
replace local_mw = 10.2 if pwstate == 35 & pwpuma == 790 & year == 2025
replace local_mw = 10.45 if pwstate == 35 & pwpuma == 790 & year == 2026
replace local_mw = 10.7 if pwstate == 35 & pwpuma == 790 & year == 2027
replace local_mw = 10.95 if pwstate == 35 & pwpuma == 790 & year == 2028
replace local_mw = 11.2 if pwstate == 35 & pwpuma == 790 & year == 2029

*Bernalillo county doesn't have a tipped minimum. ABQ does, but sticking with Bernalillo 
*due to PWPUMA scope

**Santa Fe - using all of Santa Fe County
replace local_mw = 10.29 if pwstate == 35 & pwpuma == 500 & year == 2012 & month >=3
replace local_mw = 10.29 if pwstate == 35 & pwpuma == 500 & year == 2013 & month <3
replace local_mw = 10.51 if pwstate == 35 & pwpuma == 500 & year == 2013 & month >=3
replace local_mw = 10.51 if pwstate == 35 & pwpuma == 500 & year == 2014 & month <3
replace local_mw = 10.66 if pwstate == 35 & pwpuma == 500 & year == 2014 & month >=3
replace local_mw = 10.66 if pwstate == 35 & pwpuma == 500 & year == 2015 & month <3
replace local_mw = 10.84 if pwstate == 35 & pwpuma == 500 & year == 2015 & month >=3
replace local_mw = 10.84 if pwstate == 35 & pwpuma == 500 & year == 2016 & month <3
replace local_mw = 10.91 if pwstate == 35 & pwpuma == 500 & year == 2016 & month >=3
replace local_mw = 10.91 if pwstate == 35 & pwpuma == 500 & year == 2017 & month <3
replace local_mw = 11.09 if pwstate == 35 & pwpuma == 500 & year == 2017 & month >=3
replace local_mw = 11.09 if pwstate == 35 & pwpuma == 500 & year == 2018 & month <3
replace local_mw = 11.40 if pwstate == 35 & pwpuma == 500 & year == 2018 & month >=3
replace local_mw = 11.40 if pwstate == 35 & pwpuma == 500 & year == 2019 & month <3
replace local_mw = 11.68 if pwstate == 35 & pwpuma == 500 & year == 2019 & month >=3
replace local_mw = 11.68 if pwstate == 35 & pwpuma == 500 & year == 2020 & month <3
replace local_mw = 11.89 if pwstate == 35 & pwpuma == 500 & year == 2020 & month >=3
replace local_mw = 11.89 if pwstate == 35 & pwpuma == 500 & year == 2021 & month <3
replace local_mw = 12.01 if pwstate == 35 & pwpuma == 500 & year == 2021 & month >=3
replace local_mw = 12.01 if pwstate == 35 & pwpuma == 500 & year == 2022 & month <3
replace local_mw = 12.19 if pwstate == 35 & pwpuma == 500 & year == 2022 & month >=3
replace local_mw = 12.19 if pwstate == 35 & pwpuma == 500 & year == 2023 & month <3
replace local_mw = 12.41 if pwstate == 35 & pwpuma == 500 & year == 2023 & month >=3
replace local_mw = 12.41 if pwstate == 35 & pwpuma == 500 & year == 2024 & month <3
replace local_mw = 12.68 if pwstate == 35 & pwpuma == 500 & year == 2024 & month >=3
replace local_mw = 12.68 if pwstate == 35 & pwpuma == 500 & year == 2025 & month <3
replace local_mw = 12.96 if pwstate == 35 & pwpuma == 500 & year == 2025 & month >=3
replace local_mw = 12.96 if pwstate == 35 & pwpuma == 500 & year == 2026 & month <3
replace local_mw = 13.26 if pwstate == 35 & pwpuma == 500 & year == 2026 & month >=3
replace local_mw = 13.26 if pwstate == 35 & pwpuma == 500 & year == 2027 & month <3
replace local_mw = 13.55 if pwstate == 35 & pwpuma == 500 & year == 2027 & month >=3
replace local_mw = 13.55 if pwstate == 35 & pwpuma == 500 & year == 2028 & month <3
replace local_mw = 13.85 if pwstate == 35 & pwpuma == 500 & year == 2028 & month >=3
replace local_mw = 13.85 if pwstate == 35 & pwpuma == 500 & year == 2029 & month <3
replace local_mw = 14.16 if pwstate == 35 & pwpuma == 500 & year == 2029 & month >=3
replace local_mw = 14.16 if pwstate == 35 & pwpuma == 500 & year == 2030 & month <3

*County tipped min is 30% of regular min. Santa Fe City has no tipped min
replace local_tw = (.3 * local_mw) if pwstate == 35 & pwpuma == 500 & year < 2030 ///
    & year > 2011

**Las Cruces - uses all of Dona Ana County (PWPUMA=1000)
replace local_mw = 8.4 if pwstate == 35 & pwpuma == 1000 & year == 2015 
replace local_mw = 8.4 if pwstate == 35 & pwpuma == 1000 & year == 2016
replace local_mw = 9.2 if pwstate == 35 & pwpuma == 1000 & year == 2017
replace local_mw = 9.2 if pwstate == 35 & pwpuma == 1000 & year == 2018
replace local_mw = 10.1 if pwstate == 35 & pwpuma == 1000 & year == 2019
replace local_mw = 10.3 if pwstate == 35 & pwpuma == 1000 & year == 2020
replace local_mw = 10.4 if pwstate == 35 & pwpuma == 1000 & year == 2021
replace local_mw = 10.55 if pwstate == 35 & pwpuma == 1000 & year == 2022
replace local_mw = 10.75 if pwstate == 35 & pwpuma == 1000 & year == 2023
replace local_mw = 11 if pwstate == 35 & pwpuma == 1000 & year == 2024
replace local_mw = 11.25 if pwstate == 35 & pwpuma == 1000 & year == 2025
replace local_mw = 11.5 if pwstate == 35 & pwpuma == 1000 & year == 2026
replace local_mw = 11.75 if pwstate == 35 & pwpuma == 1000 & year == 2027
replace local_mw = 12 if pwstate == 35 & pwpuma == 1000 & year == 2028
replace local_mw = 12.25 if pwstate == 35 & pwpuma == 1000 & year == 2029
replace local_mw = 12.5 if pwstate == 35 & pwpuma == 1000 & year == 2030

*tipped minimum is 40% of regular minimum
replace local_tw = (.4 * local_mw) if pwstate == 35 & pwpuma == 1000 & year <= 2030 ///
    & year > 2014

*New York
**NYC
replace local_mw = 11 if pwstate == 36 & inlist(pwpuma, 3700,3800,3900,4000,4100) ///
    & year == 2017
replace local_mw = 13 if pwstate == 36 & inlist(pwpuma, 3700,3800,3900,4000,4100) ///
    & year == 2018
replace local_mw = 15 if pwstate == 36 & inlist(pwpuma, 3700,3800,3900,4000,4100) ///
    & year >= 2019

replace local_tw = 8.65 if pwstate == 36 & inlist(pwpuma, 3700,3800,3900,4000,4100) ///
    & year == 2018
replace local_tw = 10 if pwstate == 36 & inlist(pwpuma, 3700,3800,3900,4000,4100) ///
    & year >= 2019

**Nassau, Suffolk, Westchester Counties
replace local_mw = 10 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2017
replace local_mw = 11 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2018
replace local_mw = 12 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2019
replace local_mw = 13 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2020
replace local_mw = 14 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2021
replace local_mw = 15 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year >= 2022

replace local_tw = 8 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2019
replace local_tw = 8.65 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2020
replace local_tw = 9.35 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year == 2021
replace local_tw = 10 if pwstate == 36 & inlist(pwpuma, 3100,3200,3300) ///
    & year >= 2022

*Oregon
**Portland Urban Growth Area
replace local_mw = 11.25 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2017 ///
    & month >= 7
replace local_mw = 11.25 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2018 ///
    & month < 7
replace local_mw = 12 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2018 ///
    & month >= 7
replace local_mw = 12 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2019 ///
    & month < 7
replace local_mw = 12.5 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2019 ///
    & month >= 7
replace local_mw = 12.5 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2020 ///
    & month < 7
replace local_mw = 13.25 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2020 ///
    & month >= 7
replace local_mw = 13.25 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2021 ///
    & month < 7
replace local_mw = 14 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2021 ///
    & month >= 7
replace local_mw = 14 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2022 ///
    & month < 7
replace local_mw = 14.75 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2022 ///
    & month >= 7
replace local_mw = 14.75 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2023 ///
    & month < 7
replace local_mw = 15 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2023 ///
    & month >= 7
replace local_mw = 15 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2024 ///
    & month < 7
replace local_mw = 15.3 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2024 ///
    & month >= 7
replace local_mw = 15.3 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2025 ///
    & month < 7
replace local_mw = 15.6 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2025 ///
    & month >= 7
replace local_mw = 15.6 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2026 ///
    & month < 7
replace local_mw = 15.9 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2026 ///
    & month >= 7
replace local_mw = 15.9 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2027 ///
    & month < 7
replace local_mw = 16.25 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2027 ///
    & month >= 7
replace local_mw = 16.25 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2028 ///
    & month < 7
replace local_mw = 16.6 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2028 ///
    & month >= 7
replace local_mw = 16.6 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2029 ///
    & month < 7
replace local_mw = 16.95 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2029 ///
    & month >= 7
replace local_mw = 16.95 if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year == 2030 ///
    & month < 7

replace local_tw = local_mw if pwstate == 41 & inlist(pwpuma,1325,1326,1327) & year <= 2030 & year > 2016

**Nonurban counties
replace local_mw = 10 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2017 ///
    & month >= 7
replace local_mw = 10 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2018 ///
    & month < 7
replace local_mw = 10.5 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2018 ///
    & month >= 7
replace local_mw = 10.5 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2019 ///
    & month < 7
replace local_mw = 11 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2019 ///
    & month >= 7
replace local_mw = 11 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2020 ///
    & month < 7
replace local_mw = 11.5 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2020 ///
    & month >= 7
replace local_mw = 11.5 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2021 ///
    & month < 7
replace local_mw = 12 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2021 ///
    & month >= 7
replace local_mw = 12 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2022 ///
    & month < 7
replace local_mw = 12.5 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2022 ///
    & month >= 7
replace local_mw = 12.5 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2023 ///
    & month < 7
replace local_mw = 12.75 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2023 ///
    & month >= 7
replace local_mw = 12.75 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2024 ///
    & month < 7
replace local_mw = 13.05 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2024 ///
    & month >= 7
replace local_mw = 13.05 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2025 ///
    & month < 7
replace local_mw = 13.35 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2025 ///
    & month >= 7
replace local_mw = 13.35 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2026 ///
    & month < 7
replace local_mw = 13.65 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2026 ///
    & month >= 7
replace local_mw = 13.65 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2027 ///
    & month < 7
replace local_mw = 14 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2027 ///
    & month >= 7
replace local_mw = 14 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2028 ///
    & month < 7
replace local_mw = 14.35 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2028 ///
    & month >= 7
replace local_mw = 14.35 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2029 ///
    & month < 7
replace local_mw = 14.7 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2029 ///
    & month >= 7
replace local_mw = 14.7 if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year == 2030 ///
    & month < 7

replace local_tw = local_mw if pwstate == 41 & inlist(pwpuma,100,200,300,800,1000) & year <= 2030 & year > 2016

*Washington
**Seattle - includes SEATAC and all of King County
replace local_mw = 11 if pwstate == 53 & pwpuma == 11600 & year == 2015 & month >= 4
replace local_mw = 13 if pwstate == 53 & pwpuma == 11600 & year == 2016 
replace local_mw = 15 if pwstate == 53 & pwpuma == 11600 & year == 2017
replace local_mw = 15.45 if pwstate == 53 & pwpuma == 11600 & year == 2018
replace local_mw = 16 if pwstate == 53 & pwpuma == 11600 & year == 2019
replace local_mw = 16.29 if pwstate == 53 & pwpuma == 11600 & year == 2020
replace local_mw = 16.46 if pwstate == 53 & pwpuma == 11600 & year == 2021
replace local_mw = 16.7 if pwstate == 53 & pwpuma == 11600 & year == 2022
replace local_mw = 17.01 if pwstate == 53 & pwpuma == 11600 & year == 2023
replace local_mw = 17.37 if pwstate == 53 & pwpuma == 11600 & year == 2024
replace local_mw = 17.76 if pwstate == 53 & pwpuma == 11600 & year == 2025
replace local_mw = 18.17 if pwstate == 53 & pwpuma == 11600 & year == 2026
replace local_mw = 18.57 if pwstate == 53 & pwpuma == 11600 & year == 2027
replace local_mw = 18.98 if pwstate == 53 & pwpuma == 11600 & year == 2028
replace local_mw = 19.4 if pwstate == 53 & pwpuma == 11600 & year == 2029
replace local_mw = 19.83 if pwstate == 53 & pwpuma == 11600 & year == 2030

replace local_tw = local_mw if pwstate == 53 & pwpuma == 11600 & year > 2014 & year < 2031

**Takoma
replace local_mw = 10.35 if pwstate == 53 & pwpuma == 11500 & year == 2016 & month >= 2
replace local_mw = 11.15 if pwstate == 53 & pwpuma == 11500 & year == 2017 
replace local_mw = 12 if pwstate == 53 & pwpuma == 11500 & year == 2018
replace local_mw = 12.35 if pwstate == 53 & pwpuma == 11500 & year == 2019

replace local_tw = local_mw if pwstate == 53 & pwpuma == 11500 & year > 2015 & year < 2020

keep if local_mw != .

gen mdate = ym(year,month)
format %tm mdate

label variable mdate "Month and Year"
label variable pwstate "State FIPS code"
label variable pwpuma "Place of Work PUMA"

save ${data}local_mins.dta, replace

