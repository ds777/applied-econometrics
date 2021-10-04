set scheme sj

sjlog using ch4.13,replace
use hprice2a, clear
regress lprice lnox ldist rooms stratio
test rooms
sjlog close, replace

sjlog using ch4.13a,replace
quietly regress lprice lnox ldist rooms stratio
test rooms = 0.33
sjlog close, replace

sjlog using ch4.14,replace
quietly regress lprice lnox ldist rooms stratio
test rooms + ldist + stratio = 0 
sjlog close, replace

sjlog using ch4.15,replace
quietly regress lprice lnox ldist rooms stratio
lincom rooms + ldist + stratio 
sjlog close, replace

sjlog using ch4.16,replace
quietly regress lprice lnox ldist rooms stratio
test ldist = stratio
test lnox  = 10 * stratio
sjlog close, replace

sjlog using ch4.17,replace
gen ldist2 = ldist - stratio
gen rooms2 = rooms - stratio
regress lprice lnox ldist2 rooms2 
lincom -ldist2 -rooms2
sjlog close, replace

sjlog using ch4.18,replace
constraint def 1 ldist + rooms + stratio = 0
cnsreg lprice lnox ldist rooms stratio, constraint(1)
sjlog close, replace

sjlog using ch4.19,replace
constraint def 2 ldist + rooms + stratio = 0.5
cnsreg lprice lnox ldist rooms stratio, constraint(2)
sjlog close, replace

sjlog using ch4.20,replace
quietly regress lprice lnox ldist rooms stratio
test lnox ldist
sjlog close, replace

sjlog using ch4.21,replace
quietly regress lprice lnox ldist rooms stratio
test (lnox = 10 * stratio) (ldist = stratio)
sjlog close, replace

sjlog using ch4.22,replace
quietly regress lprice lnox ldist rooms stratio
testnl _b[lnox] * _b[stratio] = 0.06
sjlog close, replace

sjlog using ch4.23,replace
quietly regress lprice lnox ldist rooms stratio
nlcom _b[lnox] * _b[stratio] 
sjlog close, replace

sjlog using ch4.24,replace
quietly regress lprice lnox ldist rooms stratio
testnl (_b[lnox] * _b[stratio] = 0.06) ///
       (_b[rooms] / _b[ldist] = 3 * _b[lnox])
sjlog close, replace

sjlog using ch4.25,replace
nnest lprice lnox ldist rooms stratio ///
           (crime proptax ldist rooms stratio)
sjlog close, replace

sjlog using ch4.26,replace
use hprice2a, clear
regress price nox dist rooms stratio proptax
mfx, eyex
sjlog close, replace

/*
sjlog using ch4.27, replace
quietly regress price nox dist rooms stratio 
scalar tmfx = invttail(e(df_r),0.975)
quietly summarize stratio if e(sample), detail
local pct  1 10 25 50 75 90 99 
tempvar y x eyex seyex1 seyex2
tempname Meyex Seyex eta se
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
   quietly mfx compute, eyex at(mean stratio=`pc`p'')
   local ++i
   quietly replace `y' = e(Xmfx_y) in `i'
   mat `Meyex' = e(Xmfx_eyex)
   mat `eta' = `Meyex'[1,"stratio"]
   quietly replace `eyex' = `eta'[1,1] in `i'
   mat `Seyex' = e(Xmfx_se_eyex)
   mat `se' = `Seyex'[1,"stratio"]
   quietly replace `seyex1' = `eyex' + tmfx*`se'[1,1] in `i'   
   quietly replace `seyex2' = `eyex' - tmfx*`se'[1,1] in `i'  
   }
label var `x' "Student/teacher ratio (percentiles `pct')" 
label var `y' "Predicted median house price"
label var `eyex' "Elasticity"
label var `seyex1' "95% c.i."
label var `seyex2' "95% c.i."
twoway (scatter `eyex' `x', ms(Oh) yscale(range(-0.5 -2.0))) ///
(rline `seyex1' `seyex2' `x') ///
(connected `y' `x', yaxis(2) yscale(axis(2) range(20000 35000))), ///
ytitle(Elasticity of price vs. student/teacher ratio)
sjlog close, replace
*/

sjlog using ch4.27, replace
// run regression
quietly regress price nox dist rooms stratio
// compute appropriate t-statistic  for 95% confidence interval
scalar tmfx = invttail(e(df_r),0.975)
generate y_val = .              // generate variables needed
generate x_val = .
generate eyex_val = .
generate seyex1_val = .
generate seyex2_val = .
// summarize, detail computes percentiles of stratio
quietly summarize stratio if e(sample), detail 
local pct  1 10 25 50 75 90 99                  
local i = 0
foreach p of local pct {
	local pc`p'=r(p`p')
	local ++i
// set those percentiles into x_val
	quietly replace x_val = `pc`p'' in `i'	
}
sjlog close,replace

sjlog using ch4.27aa, replace
local i = 0
foreach p of local pct { 
// compute elasticities at those points
   quietly mfx compute, eyex at(mean stratio=`pc`p'')  
   local ++i         
// save predictions at these points in y_val
   quietly replace y_val = e(Xmfx_y) in `i'   
// retrieve elasticities
   matrix Meyex = e(Xmfx_eyex)                         
   matrix eta = Meyex[1,"stratio"]               // for the stratio column
   quietly replace eyex_val = eta[1,1] in `i'    // and save in eyex_val
// retrieve standard errors of the elasticities
   matrix Seyex = e(Xmfx_se_eyex)                     
   matrix se = Seyex[1,"stratio"]                // for the stratio column
// compute upper and lower bounds of confidence interval  
   quietly replace seyex1_val = eyex_val + tmfx*se[1,1] in `i'  
   quietly replace seyex2_val = eyex_val - tmfx*se[1,1] in `i'  
}
sjlog close, replace

sjlog using ch4.27ab, replace
label variable x_val "Student/teacher ratio (percentiles `pct')" 
label variable y_val "Predicted median house price"
label variable eyex_val "Elasticity"
label variable seyex1_val "95% c.i."
label variable seyex2_val "95% c.i."
// graph the scatter of elasticities vs. percentiles of stratio
// as well as the predictions with rline 
// and the 95% confidence bands with connected
twoway (scatter eyex_val x_val, ms(Oh) yscale(range(-0.5 -2.0))) ///
   (rline seyex1_val seyex2_val x_val) ///
   (connected y_val x_val, yaxis(2) yscale(axis(2) range(20000 35000))), ///
   ytitle(Elasticity of price vs. student/teacher ratio)
drop y_val x_val eyex_val seyex1_val seyex2_val  // discard graph's variables
sjlog close, replace

graph export fig4_2.eps, replace

