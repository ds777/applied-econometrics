sjlog using ch2.9, replace
local addstate MA ME NH RI VT
foreach s of local addstate {
	local fns "`fns' `s'data"
	}
sjlog close, replace

foreach s of local addstate {
	use `s'data
	sort year
	capt rename dpi dpi`s'
	capt rename pop pop`s'
	save `s'data,replace
	}
	
use CTdata, clear
capt rename dpi dpiCT
capt rename pop popCT
save CTdata, replace

sjlog using ch2.9a, replace
use CTdata, clear
sort year
merge year using `fns'
sjlog close, replace

sjlog using ch2.9b,replace
assert _merge == 3
drop _merge*
tsset year
save NEstates, replace
describe
sjlog close, replace





