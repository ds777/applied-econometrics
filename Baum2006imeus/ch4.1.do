set scheme sj

use hprice2a,clear
sjlog using ch4.1, replace
quietly regress lprice lnox ldist rooms 
makematrix pc, from(r(rho)) label cols(stratio)  ///
title("Correlations with student--teacher ratio") ///
listwise:  correlate lnox ldist rooms
sjlog close, replace

sjlog using ch4.1a, replace
predict double eps, residual
regress eps stratio
sjlog close, replace

generate rooms2 = rooms^2
*sjlog using ch4.2, replace
quietly generate nonsense = invnorm(uniform())
regress lprice lnox ldist rooms stratio rooms2 nonsense
*sjlog close, replace

sjlog using ch4.3, replace
generate crime2 = crime^2
set seed 20050321
generate epsilon = invnorm(uniform())
quietly generate y2 = 10  - 0.05 * crime + 0.3 * rooms - 0.005 * crime2 + epsilon
regress y2  rooms crime crime2
sjlog close, replace

sjlog using ch4.3a, replace
regress y2  rooms crime
ovtest
sjlog close, replace

/*
sjlog using ch4.4, replace
quietly generate inter = crime * dist 
quietly generate y3 = 10  + 0.4 * dist - 0.1 * crime - 0.08 * inter + epsilon
regress y3 dist crime inter
sjlog close, replace
sjlog using ch4.4a, replace
regress y3 dist crime
sjlog close, replace
*/


sjlog using ch4.5, replace
generate epsilon2 = invnorm(uniform())
generate rooms5 = rooms + 5 * epsilon2
generate rooms10 = rooms + 10 * epsilon2
quietly {
	regress lprice crime rooms
	estimates store good
	regress lprice crime rooms5 
	estimates store bad5
	regress lprice crime rooms10
	estimates store bad10
	}
estimates table good bad5 bad10, stats(rmse) b(%9.4f) se(%5.3f)
sjlog close, replace

sjlog using ch4.6, replace
use hprice2a, clear
regress lprice rooms crime ldist
estat hettest, iid
estat hettest rooms crime ldist, iid
whitetst
sjlog close, replace

sjlog using ch4.7, replace
regress lprice rooms crime ldist, robust
sjlog close, replace

sjlog using ch4.7a, replace
generate rooms2 = rooms^2
regress lprice rooms crime ldist [aw=1/rooms2]
sjlog close, replace

* generate dpiK = dpi/1000
sjlog using ch4.8, replace
use NEdata, clear
summarize dpipc 
sjlog close, replace

sjlog using ch4.8aaa, replace
regress dpipc year
predict double eps, residual
robvar eps, by(state)
sjlog close, replace

sjlog using ch4.8aa, replace
by state, sort: egen sd_eps = sd(eps)
generate double gw_wt = 1/sd_eps^2
tabstat sd_eps gw_wt, by(state)
sjlog close, replace

sjlog using ch4.8ab, replace
regress dpipc year [aw=gw_wt]
sjlog close, replace

sjlog using ch4.8as, replace
use pubschl, clear
summarize read_scr expn_stu comp_stu meal_pct enrl_tot
sjlog close, replace

sjlog using ch4.8a, replace
regress read_scr expn_stu comp_stu meal_pct
sjlog close, replace
sjlog using ch4.8b, replace
regress read_scr expn_stu comp_stu meal_pct [aw=enrl_tot]
sjlog close, replace

sjlog using ch4.9a, replace
use fertil2, clear
quietly regress ceb age agefbrth usemeth
estimates store nonRobust
summarize ceb age agefbrth usemeth children if e(sample)
sjlog close, replace

use fertil2, clear
quietly {
	regress ceb age agefbrth usemeth
	estimates store nonRobust
*	regress ceb age agefbrth usemeth, robust
*	estimates store Robust
	regress ceb age agefbrth usemeth, cluster(children)
	estimates store Cluster
	}
sjlog using ch4.9, replace
regress ceb age agefbrth usemeth, robust
estimates store Robust
estimates table nonRobust Robust, b(%9.4f) se(%5.3f) t(%5.2f) ///
  title(Estimates of CEB with OLS and Robust standard errors)
sjlog close, replace

sjlog using ch4.9b, replace
regress ceb age agefbrth usemeth, cluster(children)
sjlog close, replace

sjlog using ch4.10a, replace
use ukrates, clear
summarize rs r20
sjlog close, replace

/* 
quietly {
	regress D.rs LD.r20
	estimates store nonHAC
	newey D.rs LD.r20, lag(5)
	estimates store NeweyWest
}
*/
sjlog using ch4.10b, replace
quietly regress D.rs LD.r20
estimates store nonHAC
newey D.rs LD.r20, lag(5)
estimates store NeweyWest
estimates table nonHAC NeweyWest, b(%9.4f) se(%5.3f) t(%5.2f) ///
  title(Estimates of D.rs with OLS and Newey--West standard errors)
sjlog close, replace

sjlog using ch4.10, replace
regress D.rs LD.r20
predict double eps, residual
estat bgodfrey, lags(6)
wntestq eps
ac eps
sjlog close, replace
graph export fig4_1.eps, replace

sjlog using ch4.11, replace
prais D.rs LD.r20, nolog
sjlog close, replace

sjlog using ch4.12, replace
newey D.rs LD.r20, lag(5)
sjlog close, replace
