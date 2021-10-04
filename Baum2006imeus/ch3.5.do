set scheme sj

use hprice2a, clear
sjlog using ch3.5, replace
graph matrix lprice lnox ldist rooms stratio, ms(Oh) msize(tiny) 
sjlog close, replace
graph export fig3_1.eps, replace

* suppress legend
sjlog using ch3.6,replace
use hprice2a, clear
quietly regress lprice lnox ldist rooms stratio
predict double lpricehat, xb
label var lpricehat "Predicted log price"
twoway (scatter lpricehat lprice, msize(small) mcolor(black) msize(tiny)) || ///
(line lprice lprice if lprice <., clwidth(thin)), ///
ytitle("Predicted log median housing price") ///
xtitle("Actual log median housing price") aspectratio(1) legend(off)
sjlog close, replace
graph export fig3_2.eps, replace

/*
gen lgnppc = log(gnppc)
label var lgnppc "Log real GNP per capita"
sjlog using ch3.6, replace
graph matrix lexp popgrowth lgnppc safewater if country ~= "Haiti", ///
ti("excluding Haiti") ms(Oh)
sjlog close, replace
graph export fig3_2.eps, replace

sjlog using ch3.7, replace
generate double lexphat = .
drop if country == "Haiti" 
label var lexphat "Predicted life expectancy at birth"
forvalues r = 1/3 {
     quietly {
     regress lexp popgrowth safewater lgnppc if region == `r' 
     tempvar pred
     predict double `pred' if e(sample), xb
     replace lexphat = `pred' if e(sample)
     }
}
twoway (scatter lexphat lexp if region==1, /// 
 msymbol(smcircle) msize(small) mcolor(black)) ///
 (scatter lexphat lexp if region==2, /// 
 msymbol(square_hollow) msize(small) mcolor(black)) ///
 (scatter lexphat lexp if region==3, ///
 msymbol(diamond_hollow) msize(small) mcolor(black)) ///
 (line lexp lexp if lexphat <., clwidth(thin)), /// 
 ytitle(Predicted life expectancy at birth) ///
 legend(nostack cols(3) ///
 order(1 "Eur. & Cent.Asia" 2 "N. America" 3 "S. America") size(small))
sjlog close, replace
graph export fig3_3.eps, replace
*/
