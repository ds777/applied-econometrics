set scheme sj

sjlog using ch5.15aa, replace
use turksales, clear
summarize sales
sjlog close, replace

sjlog using ch5.15, replace
summarize sales, meanonly
local mu = r(mean)
forvalues i=1/3 {
	generate qseas`i' = (quarter(dofq(t)) == `i')
}
sjlog close, replace

sjlog using ch5.15a, replace
regress sales qseas* 
sjlog close, replace

sjlog using ch5.15b, replace
predict double salesSA, residual
replace salesSA = salesSA + `mu'
sjlog close, replace

sjlog using ch5.15c, replace
summarize sales salesSA
label var salesSA "sales, seasonally adjusted"
tsline sales salesSA, lpattern(solid dash)
sjlog close, replace
graph export fig5_1.eps, replace

sjlog using ch5.16, replace
regress sales qseas* t
test qseas1 qseas2 qseas3
predict double salesSADT, residual
replace salesSADT = salesSADT + `mu'
label var salesSADT "sales, detrended and SA"
tsline sales salesSADT, lpattern(solid dash) yline(`mu') 
sjlog close, replace
graph export fig5_2.eps, replace

