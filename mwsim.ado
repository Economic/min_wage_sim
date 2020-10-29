
* Minimum wage model
capture program drop mwsim
program define mwsim

    if ( !inlist(subinstr("`1'", ",", "", .), "run", "analyze") ) {
        disp as err `"Unknown command '`1''. Supported: run, analyze"' _n
        exit 198
    }

    mwsim_`0'

end
