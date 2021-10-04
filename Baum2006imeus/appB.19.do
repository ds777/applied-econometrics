sjlog using appB.19, replace
capture program drop semean
*! semean  v1.0.1  CFBaum  04aug2005
program define semean, rclass
	version 9.0
	syntax varlist(max=1 numeric)
	quietly summarize `varlist'
	scalar semean = r(sd)/sqrt(r(N))
	display _n "Mean of `varlist' = " r(mean) " S.E. = " semean
	return scalar semean = semean
	return scalar mean = r(mean)
	return local var `varlist'
end
use abdata, clear
semean emp
return list
sjlog close, replace

use abdata, clear
sjlog using appB.20, replace
capture program drop semean
*! semean  v1.0.2  CFBaum  04aug2005
program define semean, rclass
	version 9.0
	syntax varlist(max=1 numeric) [if] [in] [, noPRInt]
	marksample touse
	quietly summarize `varlist' if `touse'
	scalar semean = r(sd)/sqrt(r(N))
	if ("`print'" ~= "noprint") {
		display _n "Mean of `varlist' = " r(mean) ///
		" S.E. = " semean
	}
	return scalar semean = semean
	return scalar mean = r(mean)
	return scalar N = r(N)
	return local var `varlist'
end
sjlog close, replace

sjlog using appB.20a, replace
semean emp
return list
semean emp if year < 1982, noprint
return list
sjlog close, replace

use abdata, clear
sjlog using appB.21, replace
capture program drop semean
*! semean  v1.0.3  CFBaum  04aug2005
program define semean, rclass byable(recall) sortpreserve
	version 9.0
	syntax varlist(max=1 ts numeric) [if] [in] [, noPRInt]
	marksample touse
	quietly summarize `varlist' if `touse'
	scalar semean = r(sd)/sqrt(r(N))
	if ("`print'" ~= "noprint") {
		display _n "Mean of `varlist' = " r(mean) ///
		" S.E. = " semean
	}
	return scalar semean = semean
	return scalar mean = r(mean)
	return scalar N = r(N)
	return local var `varlist'
end
sjlog close, replace

sjlog using appB.21a, replace
semean D.emp 
semean emp if year == 1982
by year, sort: semean emp
sjlog close, replace

sjlog using appB.22, replace
capture program drop semean
*! semean  v1.1.0  CFBaum  04aug2005
program define semean, rclass byable(recall) sortpreserve
	version 9.0
	syntax varlist(max=1 ts numeric) [if] [in] ///
		[, noPRInt FUNCtion(string)]
	marksample touse
	tempvar target
	if "`function'" == "" {
		local tgt "`varlist'"
	}
	else {
		local tgt "`function'(`varlist')"
	}
	capture tsset
	capture generate double `target' = `tgt' if `touse'
	if _rc > 0 {
		display as err "Error: bad function `tgt'"
		error 198
		}
	quietly summarize `target' 
	scalar semean = r(sd)/sqrt(r(N))
	if ("`print'" ~= "noprint") {
		display _n "Mean of `tgt' = " r(mean) ///
		" S.E. = " semean
	}
	return scalar semean = semean
	return scalar mean = r(mean)
	return scalar N = r(N)
	return local var `tgt'
end
sjlog close, replace

tsset
sjlog using appB.23, replace
semean emp
semean emp, func(sqrt)
semean emp if year==1982, func(log)
return list
semean D.emp if year==1982, func(log)
return list
sjlog close, replace

