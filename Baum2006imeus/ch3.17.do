set scheme sj

sysuse lifeexp, clear
gen double lgnppc = log(gnppc)
sjlog using ch3.17,replace
quietly regress lexp popgrowth lgnppc safewater if country ~= "Haiti"
scalar tmfx = invttail(e(df_r),0.975)
mfx compute
mfx compute, eyex
mfx compute, eydx 
sjlog close, replace

sjlog using ch3.18, replace
quietly summarize safewater if e(sample), detail
local pct 1 10 25 50 75 90
tempvar y x eyex seyex1 seyex2
tempname Meyex Seyex
quietly gen `y' = .
quietly gen `x' = .
quietly gen `eyex' = .
quietly gen `seyex1' = .
quietly gen `seyex2' = .
local i = 0
foreach p of local pct {
	local pc`p'=r(p`p')
	local ++i
	quietly replace `x' = `pc`p'' in `i'	
	}
local i = 0
foreach p of local pct { 
   quietly mfx compute, eyex at(mean safewater=`pc`p'')
   local ++i
   quietly replace `y' = e(Xmfx_y) in `i'
   mat `Meyex' = e(Xmfx_eyex)
   quietly replace `eyex' = `Meyex'[1,3] in `i'
   mat `Seyex' = e(Xmfx_se_eyex)
   quietly replace `seyex1' = `eyex' + tmfx*`Seyex'[1,3] in `i'   
   quietly replace `seyex2' = `eyex' - tmfx*`Seyex'[1,3] in `i'  
   }
label var `x' "Safe Water percentiles `pct'" 
label var `y' "Predicted life expectancy"
label var `eyex' "Elasticity"
label var `seyex1' "95% confidence interval"
label var `seyex2' "95% confidence interval"
twoway (scatter `eyex' `x', ms(Oh)) ///
   (rline `seyex1' `seyex2' `x') ///
   (connected `y' `x', yaxis(2)), ///
   ytitle(Elasticity of life exp. vs. %/pop with safe water)
sjlog close, replace
graph export fig3_7.eps, replace


