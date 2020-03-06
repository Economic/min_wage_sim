*Load correct minimum wage and tipped minimum wage values for data year of
*dataset and month and years of each proposed increase

*create data set of all relevant state minimum wages 
use ${allmins}

gen step0 = ym(`year_data',`month_data')
format %tm step0

label variable step0 "Date of model source data"

keep if mdate==step0

drop mdate
drop month
drop year

rename stmin stmin0
rename tipmin tipmin0

tempfile mindata
save `mindata'

forvalues a = 1 / `numsteps' {
    use ${allmins},clear

    gen step`a' = ym(`year_raise`a'',`month_raise`a'')
    format %tm step`a'
    label variable step`a' "Date of step `a' raise"

    keep if mdate == step`a'
    drop mdate
    drop month
    drop year

    rename stmin stmin`a'
    label variable stmin`a' "State minimum wage at Step `a'"
    rename tipmin tipmin`a'
    label variable tipmin`a' "State tipped minimum wage at Step `a'"
    
    if `a' == 1 {
        tempfile combine_mins
        save `combine_mins'
    }
    else {
        merge 1:1 pwstate using `combine_mins'
	drop _merge
        save `combine_mins', replace
    }
}

merge 1:1 pwstate using `mindata'
drop _merge
save `mindata', replace

