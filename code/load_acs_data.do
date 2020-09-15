*loads the ACS_state.dta file and formats demographic variables
clear

use ${data}acs_state.dta
keep if pwstate>0

drop perwt0 perwt1 hrwage0 hrwage1 metro met2013 nfams subfam foodstmp racamind racblk ///
  racasian racpacis racwht racother racnum empstat ind1990 classwkr adj_wkswork* 

rename hrwage2 hrwage0
label var hrwage0 "Hourly wage at data period"

rename perwt2 perwt0
label var perwt0 "Raked person weight at data period"

gen pop=1

replace ftotinc = . if ftotinc>=9999999
replace hhincome = . if hhincome>=9999999
replace inctot = . if inctot>=9999999
replace incwage = . if incwage>=9999999

*define demographic categories
*age
gen teens = irecode(age,20)
lab var teens "Teenager flag"
label define l_teens 0 "Teenager" 1 "Age 20 or older"
label values teens l_teens

gen agec = irecode(age,25,40,55)
lab var agec "Age category"
label define agec 0 "Age 16 to 24" 1 "Age 25 to 39" 2 "Age 40 to 54" ///
  3 "Age 55 or older"
label values agec agec
drop age

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
drop sex

*race/ethnicity
gen byte racec = .
replace racec = 3 if (1<=hispan<=4)
replace racec = 1 if (hispan==0 & race==1)
replace racec = 2 if (hispan==0 & race==2)
replace racec = 4 if (hispan==0 & race>3 & race ~= .)
*replace racec = 4 if (hispan==0 & (4<=race<=6))
*replace racec = 5 if (hispan==0 & race>6) 

lab var racec "Race / ethnicity"
#delimit ;
lab define racec
1 "White, non-Hispanic" 
2 "Black, non-Hispanic" 
3 "Hispanic, any race" 
4 "Asian or other race, non-Hispanic" 
;
*5 "Other race/ethnicity";
#delimit cr

label val racec racec
drop race raced hispan hispand

*Person of color
gen byte poc = .
replace poc = 0 if racec == 1
replace poc = 1 if racec != 1

lab var poc "Person of color"
lab define poc 0 "Not person of color" 1 "Person of color"
label val poc poc

*education
gen byte edc = .
replace edc=1 if 2<=educd & educd < 62
replace edc=2 if 62<=educd & educd<=64
replace edc=3 if 65<=educd & educd<=71
replace edc=4 if 81<=educd & educd<=83
replace edc=5 if 101<=educd & educd<=. 

label var edc "Educational attainment"

#delimit ;
label define edc 
1 "Less than high school" 
2 "High school"
3 "Some college, no degree"
4 "Associates degree"
5 "Bachelors degree or higher" 
; 

#delimit cr
label val edc edc
drop educ educd

*Marital and parental status
gen byte parent=.
replace parent=1 if (nchild>=1 & hasyouth_fam==1)
label var parent "Parent flag"

gen byte childc=.
replace childc = 1 if (parent==1 & (1<=marst & marst<=2))
replace childc = 2 if (parent==1 & marst>2)
replace childc = 3 if (parent~=1 & (1<=marst & marst<=2))
replace childc = 4 if (parent~=1 & marst>2)

lab var childc "Family status"
#delimit ;
lab define childc
1 "Married parent"
2 "Single parent"
3 "Married, no children"
4 "Unmarried, no children"
;
#delimit cr
lab val childc childc
drop marst

*Family income and poverty
gen faminc = irecode(ftotinc,25000,50000,75000,100000,150000)
label define l_faminc 0 "Less than $25,000" 1 "$25,000 - $49,999" 2 "$50,000 - $74,999" ///
  3 "$75,000 - $99,999" 4 "$100,000 - $149,999" 5 "$150,000 or more" . "Missing family income"
label values faminc l_faminc
lab var faminc "Family income category"

gen povstat = irecode(poverty,100,200,400)
label define l_povstat 0 "In Poverty" 1 "100 - 199% poverty" 2 "200-399% poverty" 3 "400%+ poverty"
label values povstat l_povstat
lab var povstat "Family income-to-poverty status"

*define worker-specific categories
gen byte worker = 0
replace worker = 1 if (age>=16 & hrwage0>0 & (22<=classwkrd & classwkrd<=28) & (10<=empstatd & empstatd <=12))
lab var worker "Wage-earning worker status"
lab define l_worker 0 "Not a wage-earner" 1 "Wage-earner"
label values worker l_worker

*work hours
gen hourc = irecode(uhrswork,20,35)
label define l_hourc 0 "Part time (<20 hours per week)" 1 "Mid time (20-34 hours)" 2 "Full time (35+ hours)"
label values hourc l_hourc
lab var hourc "Usual weekly work hours category"

*sector
gen byte sectc=.
replace sectc = 1 if classwkrd==22
replace sectc = 2 if classwkrd==23
replace sectc = 3 if (24<=classwkrd & classwkrd<=28)
replace sectc = 4 if (10<=classwkrd & classwkrd <20)

lab var sectc "Sector"
#delimit ;
lab define sectc
1 "For profit"
2 "Nonprofit"
3 "Government"
4 "Self-employed"
;
#delimit cr
lab val sectc sectc

*industry
gen byte indc=.
replace indc = 1 if (170<=ind & ind<=490)
replace indc = 2 if ind==770
replace indc = 4 if (1070<=ind & ind<=3990)
replace indc = 5 if (4070<=ind & ind<=4590)
replace indc = 6 if (4670<=ind & ind<=5790)
replace indc = 7 if ((6070<=ind & ind<=6390)|(570<=ind & ind<=690))
replace indc = 8 if (6470<=ind & ind<=6780) 
replace indc = 9 if (6870<=ind & ind<=7190)
replace indc = 10 if (7270<=ind & ind<=7570) 
replace indc = 11 if (7580<=ind & ind<=7790)
replace indc = 12 if (7860<=ind & ind<=7890) 
replace indc = 13 if (7970<=ind & ind<=8470)
replace indc = 14 if (8560<=ind & ind<=8590)
replace indc = 15 if (8660<=ind & ind<=8670) 
replace indc = 16 if (8680<=ind & ind<=8690) 
replace indc = 17 if (8770<=ind & ind<=9290)
replace indc = 18 if (9370<=ind & ind<=9590)
replace indc = 19 if (9670<=ind & ind<=9870)

lab var indc "Major Industry"
#delimit ;
lab define indc
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

*Tipped workers
gen byte tipc = .
replace tipc = 0 if worker == 1
replace tipc = 1 if (worker == 1 & inlist (occ,4040,4060,4110,4400,4500,4510,4520))
replace tipc = 1 if (worker == 1 & inlist (occ,4120,4130) & inlist (ind, 8580,8590,8660,8670,8680,8690,8970,8980,8990,9090))

lab var tipc "Tipped occupations"
lab define tipc 0 "Not tipped" 1 "Tipped worker" 
lab val tipc tipc

*Veteran status
gen byte vetc = .
replace vetc = 1 if (vetstatd > 10 & vetstatd < 99)
replace vetc = 0 if (vetstatd == 10)

lab var vetc "Veteran status"
lab define vetc 0 "Not a veteran" 1 "Veteran"
lab val vetc vetc
drop vetstatd

*PW State
lab var pwstate "Place of work state"
lab val pwstate STATEFIP

lab var pwpuma "Place of work PUMA"

*merge in existing and scheduled minimumw wages
merge m:1 pwstate using $activemins
drop _merge

*merge population growth rate assumptions
merge m:1 racec using ${data}popgrowth
drop _merge

*adjust person weights to reflect weights at t[n]
forvalues a = 1/$steps {
  gen perwt`a' = perwt`=`a'-1' * (((months_to_`a'/12) * (growthann-1))+1)
  label var perwt`a' "Person weight at step `a'" 
}

*create counterfactual wage values
gen cf_hrwage0 = hrwage0

forvalues a = 1/$steps {
  gen hrwage`a' = .
  label var hrwage`a' "Hourly wage at step `a'"
  *increase hourly wage values by inflation between data period and each step
  replace hrwage`a' = hrwage`=`a'-1' * (cpi`a' / cpi`=`a'-1') if hrwage0 != .
   * replace hrwage`a' = (cpi`a' / cpi0) * hrwage0 if hrwage0 != .
  
*increase hourly wage to new MW if increase occured since data period
  *simple option:
    *replace hrwage`a' = stmin`a' if (stmin`a' > hrwage`a') & (hrwage`=`a'-1' > (lower_bound * stmin`=`ka'-1'))

  *old model's logic:
  if stmin`a' > stmin`=`a'-1' {
    *in places where there was a minimum wage increase
    if hrwage`a' < (stmin`a' * spillover) {
      *if their cpi/natural-wage-growth-adjusted wage is less than the new minimum wage
      if (hrwage`=`a'-1' < stmin`=`a'-1') {
        *if they were below the previous minimum wage, bring them to the same relative place
        replace hrwage`a' = max((hrwage0 / stmin0) * stmin`a', hrwage`a') 
      }
      else {
        *otherwise, bring them either 1/4 the distance to the spillover cutoff or up to the new minimum, which is larger
        replace hrwage`a' = max(stmin`a', hrwage`=`a'-1' + (((stmin`a' * spillover)-hrwage`=`a'-1')*.025))
      }
    }
  }
 
 gen cf_hrwage`a' = hrwage`a'
 label var cf_hrwage`a' "Counterfactual wage at step `a'"
 }

*identify directly and indirectly affected workers, calculate implied raise
forvalues a = 1/$steps {
  gen direct`a' = .
  gen indirect`a' = .
  gen raise`a' = .
  gen d_wage`a' = .
  gen d_annual_inc`a' = .

  label var direct`a' "Directly affected at step `a'"
  label var indirect`a' "Indirectly affected at step `a'"
  label var raise`a' "Raise resulting from increase at step `a'"

  if worker == 1 {
    replace direct`a' = 0
    replace indirect`a' = 0
    
    *flag workers with wages below the new MW and above the old lower bound as directly affected
    *flag workers with wages above the new MW and below the spillover cutoff as indirectly affected
    replace direct`a' = 1 if (new_mw`a' > hrwage`a') & (hrwage`a' > (lower_bound * stmin`a'))
    replace indirect`a' = 1 if (hrwage`a' >= new_mw`a') & (hrwage`a' < (spillover * new_mw`a'))

    *calculate implied raises for both 
    replace raise`a' = min(max((new_mw`a' - hrwage`a'), 0.25 * ((spillover * new_mw`a') - hrwage`a')), new_mw`a' - stmin`a') if direct`a' == 1
    replace raise`a' = 0.25 * ((spillover * new_mw`a') - hrwage`a') if indirect`a' == 1

    *add raise to existing hourly wage
    replace hrwage`a' = hrwage`a' + raise`a'

    *calculate difference between new hourly wage and counterfactual wage
    replace d_wage`a' = hrwage`a' - cf_hrwage`a'
    replace d_annual_inc`a' = d_wage`a' * uhrswork *52
    }
}

keep if $conditions

save ${data}allsimdata.dta, replace







