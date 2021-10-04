set scheme sj

sjlog using ch8.1, replace
use grunfeldGaps, clear
xtdes
sjlog close, replace

sjlog using ch8.2, replace
tsspell year, cond(D.year == 1)
egen nspell = max(_spell), by(company)
drop if nspell > 1
xtdes
sjlog close, replace

sjlog using ch8.3, replace
use grunfeldGaps, clear
tsspell year, cond(D.year == 1)
replace _spell = F._spell if _spell == 0
egen maxspell = max(_seq+1), by(company _spell)
drop if maxspell < 5
xtdes
sjlog close, replace

sjlog using ch8.4, replace
use grunfeld, clear
drop if company>4
mvcorr invest mvalue, window(5) generate(rho)
xtline rho, yline(0) yscale(range(-1 1)) ///
 byopts(title(Investment vs. Market Value: Moving Correlations by Firm))
sjlog close, replace
graph export fig8_1.eps, replace

/*
sjlog using ch8.4, replace
use grunfeld, clear
drop if company>4
mvcorr invest mvalue, win(5) gen(rho)
forvalues i = 1/4 {
	tsline rho if company==`i', nodraw ti("Firm `i'") name(comp`i',replace) ///
	    yscale(range(-1 1)) ylabel(#5) yline(0)
	local g "`g' comp`i'"
	}
graph combine `g', ti("Investment vs Market Value: Moving Correlations by Firm")
sjlog close, replace
graph export fig8_1.eps, replace
*/

sjlog using ch8.5, replace
use invest2, clear
keep if company<5
tsset company time
rollreg market L(0/1).invest time, move(8) stub(mktM)
local dv `r(depvar)'
local rl `r(reglist)'
local stub `r(stub)'
local wantcoef invest
local m "`r(rolloption)'(`r(rollobs)')"
generate fullsample = .
forvalues i = 1/4 {
     qui regress `dv' `rl' if company==`i'
     qui replace fullsample = _b[`wantcoef'] if company==`i' & time > 8
}
label var `stub'_`wantcoef' "moving beta"
xtline `stub'_`wantcoef', saving("`wantcoef'.gph",replace) ///
byopts(title(Moving coefficient of market on invest) ///
subtitle("Full-sample coefficient displayed") yrescale legend(off)) ///
addplot(line fullsample time if fullsample < .)
sjlog close, replace

* save d8.2,replace
graph export fig8_2.eps, replace

/*
	tsline `stub'_`wantcoef' if company==`i' & `stub'_`wantcoef'<., ///
	ti("company `i'") yli(`cinv') yti("moving beta") ///
	name(comp`i',replace) nodraw
	local all "`all' comp`i' "
	}
graph combine `all', ti("`m' coefficient of `dv' on `wantcoef'") col(2) ///
	t1("Full-sample coefficient displayed") saving("`wantcoef'.gph",replace)
*/

/* sjlog using ch8.5, replace
use invest2, clear
keep if company<5
tsset company time
rollreg market L(0/1).invest time, move(8) stub(mktM)
local dv `r(depvar)'
local rl `r(reglist)'
local stub `r(stub)'
local wantcoef invest
local m "`r(rolloption)'(`r(rollobs)')"
forvalues i = 1/4 {
	quietly regress `dv' `rl' if company==`i'
	local cinv = _b[`wantcoef']
	tsline `stub'_`wantcoef' if company==`i' & `stub'_`wantcoef'<., ///
	ti("company `i'") yli(`cinv') yti("moving beta") ///
	name(comp`i',replace) nodraw
	local all "`all' comp`i' "
	}
graph combine `all', ti("`m' coefficient of `dv' on `wantcoef'") col(2) ///
	t1("Full-sample coefficient displayed") saving("`wantcoef'.gph",replace)
sjlog close, replace
graph export fig8_2.eps, replace
*/

sjlog using ch8.5a, replace
use invest2, clear
keep if company<5
tsset company time
rolling _b, window(8) saving(roll_invest, replace) nodots: ///
   regress market L(0/1).invest time 
use roll_invest, clear
tsset company start
describe
sjlog close, replace

* label var _b_invest "moving beta"
* xtline _b_invest,  byopts(title(Moving coefficient of market on invest))
* sjlog close, replace
