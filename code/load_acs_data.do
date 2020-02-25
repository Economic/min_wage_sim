*loads the ACS_state.dta file and formats demographic variables

use ${data}ACS_state.dta
keep if pwstate>0

replace ftotinc = . if ftotinc>=9999999
replace hhincome = . if hhincome>=9999999
replace inctot = . if inctot>=9999999
replace incwage = . if incwage>=9999999

*define demographic categories
*age
gen teens = irecode(age,20)
label define l_teens 0 "Teenager" 1 "Age 20 or older"
label values teens l_teens

gen agecat = irecode(age,25,40,55)
label define agecats 0 "Age 16 to 24" 1 "Age 25 to 39" 2 "Age 40 to 54" ///
  3 "Age 55 or older"
label values agecat agecats

*sex
gen byte female = .
replace female = 1 if sex==2
replace female = 0 if sex==1

lab var female "Female"
#delimit ;
lab define female
0 "Male"
1 "Female"
;
#delimit cr
lab val female female

*education
gen byte edc =.
replace edc=1 if (2<=educd<62)
replace edc=2 if (62<=educd<=64)
replace edc=3 if (65<=educd<=71)
replace edc=4 if (81<=educd>=83)
replace edc=5 if (101<=educd)

lab var edc "Educational attainment"
#delimit ;
lab define edc
1 "Less than high school"
2 "High school"
3 "Some college, no degree"
4 "Associates degree"
5 "Bachelor's degree or higher"
;
#delimit cr
lab val edc edc

*Marital and parental status
gen byte parent=.
replace parent=1 if (nchild>=1 & hasyouth_fam=1)

gen byte childc=.
replace childc = 1 if (parent==1 & (1<=marst<=2))
replace childc = 2 if (parent==1 & marst>2)
replace childc = 3 if (parent~=1 & (1<=marst<=2))
replace childc = 4 if (parent~=1 & marst>2)

lab var childc "Family status"
#delimit ;
1 "Married parent"
2 "Single parent"
3 "Married, no children"
4 "Unmarried, no children"
;
#delimit cr
lab val childc childc

*Family income and poverty
gen faminc = irecode(ftotinc,25000,50000,75000,100000,150000)
label define l_faminc 0 "Less than $25,000" 1 "$25,000 - $49,999" 2 "$50,000 - $74,999" ///
  3 "$75,000 - $99,999" 4 "$100,000 - $149,999" 5 "$150,000 or more"
label values faminc l_faminc
lab var faminc "Family income category"

gen povstat = irecode(poverty,100,200,400)
label define l_povstat 0 "In Poverty" 1 "100 - 199% poverty" 2 "200-399% poverty" 3 "400%+ poverty"
label values povstat l_povstat
lab var povstat "Family income-to-poverty status"

*define worker-specific categories
gen byte worker = .
replace worker = 1 if (age>=16 & hrwage2>0 & (22<=classwkrd<=28) & (10<=empstatd<=12))
label variable worker "Wage earner"
lab var worker "Wage-earning worker status"

*work hours
gen hourc = irecode(uhrswork,20,35)
label define l_hourc 0 "Part time (<20 hours per week)" 1 "Mid time (20-34 hours)" 2 "Full time (35+ hours)"
label values hourc l_hourc
lab var hourc "Usual weekly work hours category"

*sector
gen byte sectc=.
replace sectc = 1 if classwkrd==22
replace sectc = 2 if classwkrd==23
replace sectc = 3 if (24<=classwkrd<=28)
replace sectc = 4 if (10<=classwkrd<20)

lab var sectc "Sector"
#delimit ;
1 "For profit"
2 "Nonprofit"
3 "Government"
4 "Self-employed"
;
#delimit cr
lab val sectc sectc

*industry
gen byte indc=.
replace indc = 1 if (170<=ind<=490)
replace indc = 2 if ind=770
replace indc = 4 if (1070<=ind<=3990)
replace indc = 5 if (4070<=ind<=4590)
replace indc = 6 if (4670<=ind<=5790)
replace indc = 7 if ((6070<=ind<=6390)|(570<=ind<=690))
replace indc = 8 if (6470<=ind<=6780) 
replace indc = 9 if (6870<=ind<=7190)
replace indc = 10 if (7270<=ind<=7570) 
replace indc = 11 if (7580<=ind<=7790)
replace indc = 12 if (7860<=ind<=7890) 
replace indc = 13 if (7970<=ind<=8470)
replace indc = 14 if (8560<=ind<=8590)
replace indc = 15 if (8660<=ind<=8670) 
replace indc = 16 if (8680<=ind<=8690) 
replace indc = 17 if (8770<=ind<=9290)
replace indc = 18 if (9370<=ind<=9590)
replace indc = 19 if (9670<=ind<=9870)

lab var indc "Major Industry"
#delimit ;
1 "Agriculture, fishing, forestry, mining"
2 "Construction"
4 "Manufacturing"
5 "Wholesale trade"
6 "Retail trade"
7 "Transportation, warehousing, utilities"
8 "Information"
9 "Finance, insurance, real estate"
10 "Professional, science, management services"
11 "Administrative, support, waste services"
12 "Educational services"
13 "Healthcare, social assistance"
14 "Arts, entertainment, recreational services"
15 "Accommodation"
16 "Restaurants"
17 "Other services"
18 "Public administration"
19 "Active duty military"

;
#delimit cr
lab val indc indc




