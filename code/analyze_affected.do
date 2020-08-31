*identify directly and indirectly affected workers in each step

clear*

tempfile all_affected
save `all_affected', emptyok

use $simdata, clear

forvalues a = 1/$steps {
    preserve
    collapse (sum) pop=pop direct=direct`a' indirect=indirect`a' (mean) m_pop=pop m_direct=direct`a' m_indirect=indirect`a' ///
        [pw=perwt`a']  

    drop m_pop
    gen step = `a'
    append using `all_affected'
    save `"`all_affected'"', replace
    restore
}

use `all_affected', clear
sort step


/*
use `overall_step`a'', clear
forvalues b=2/$steps {
append using `overall_step`b''
}
tempfile `all_affected'
save `all_affected'




/*
program affected 
args byvar

    collapse (sum) pop direct`a' indirect`a' (mean) m_pop=pop m_direct=direct`a' m_indirect=indirect`a' ///
        [pw=perwt`a']

    drop m_pop
    tempfile `combined0`a''
    save `combined0`a''
}
else {
    use `allsimdata', clear
    collapse (sum) pop direct`a' indirect`a' (mean) m_pop=pop m_direct=direct`a' m_indirect=indirect`a' ///
        [pw=perwt`a']
    drop m_pop
    tempfile `combined`a''
    save `combined`a''
}
end

affected racec
