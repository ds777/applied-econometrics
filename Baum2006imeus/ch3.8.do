set scheme sj

sjlog using ch3.8, replace
use hprice2a, clear
quietly regress lprice lnox if _n<=100
predict double xb if e(sample)
predict double stdpred if e(sample), stdp
sjlog close, replace

sjlog using ch3.8_1, replace
scalar tval = invttail(e(df_r),0.975)
generate double uplim = xb + tval * stdpred
generate double lowlim = xb - tval * stdpred
sjlog close, replace

sjlog using ch3.8_2, replace
summarize lnox if e(sample), meanonly
local lnoxbar = r(mean)
label var xb "Pred"
label var uplim "95% prediction interval"
label var lowlim "95% prediction interval"
sjlog close, replace

sjlog using ch3.8a, replace
twoway (scatter lprice lnox if e(sample), ///
sort ms(Oh) xline(`lnoxbar')) ///
(connected xb lnox if e(sample), sort msize(small)) ///
(rline uplim lowlim lnox if e(sample), sort), ///
ytitle(Actual and predicted log price) legend(cols(3))
sjlog close, replace
graph export fig3_3.eps, replace

