set scheme sj

* use specification accepted by RESET
sjlog using ch3.10a, replace
use hprice2a, clear
generate rooms2 = rooms^2
regress lprice lnox ldist rooms rooms2 stratio lproptax
avplots, ms(Oh) msize(small) col(2)
sjlog close, replace
graph export fig3_6.eps, replace

sjlog using ch3.9, replace
quietly regress lprice lnox ldist rooms stratio
estat ovtest
estat ovtest, rhs
sjlog close, replace

sjlog using ch3.9a, replace
regress lprice lnox ldist rooms rooms2 stratio lproptax
estat ovtest
sjlog close, replace

* use specification accepted by RESET
sjlog using ch3.10, replace
quietly regress lprice lnox ldist rooms rooms2 stratio lproptax
rvpplot ldist, ms(Oh) yline(0)
sjlog close, replace
graph export fig3_5.eps, replace

sjlog using ch4.4, replace
generate taxschl = lproptax * stratio
regress lprice lnox ldist lproptax stratio taxschl
sjlog close, replace

* use specification accepted by RESET
sjlog using ch3.10b, replace
quietly regress lprice lnox ldist rooms rooms2 stratio lproptax
generate town = _n
predict double lev if e(sample), leverage
predict double eps if e(sample), res
generate double eps2 = eps^2
summarize price lprice
sjlog close, replace

sjlog using ch3.10c, replace
gsort -lev
list town price lprice lev eps2 in 1/5
sjlog close, replace

sjlog using ch3.10d, replace
gsort -eps2
list town price lprice lev eps2 in 1/5
sjlog close, replace

* use specification accepted by RESET
regress lprice lnox ldist rooms rooms2 stratio lproptax
sjlog using ch3.11, replace
predict double dfits if e(sample), dfits
sjlog close, replace

sjlog using ch3.11_1, replace
gsort -dfits
quietly generate cutoff = abs(dfits) > 2*sqrt((e(df_m)+1)/e(N)) & e(sample)
list town price lprice dfits if cutoff
sjlog close, replace

sjlog using ch3.11a, replace
quietly regress lprice lnox ldist rooms rooms2 stratio lproptax
dfbeta lnox
quietly generate dfcut = abs(DFlnox) > 2/sqrt(e(N)) & e(sample)
sort DFlnox
summarize lnox
list town price lprice lnox DFlnox if dfcut
sjlog close, replace

drop cutoff dfcut
* use specification accepted by RESET
sjlog using ch3.11b, replace
regress lprice lnox ldist rooms rooms2 stratio lproptax if price>5000 & price<50001
sjlog close, replace

/*
dfbeta lnox
gsort -dfits
quietly generate cutoff = abs(dfits) > 2*sqrt((e(df_m)+1)/e(N)) & e(sample)
list town price lprice dfits if cutoff
quietly generate dfcut = abs(DFlnox) > 2/sqrt(e(N)) & e(sample)
sort DFlnox
list town price lprice lnox DFlnox if dfcut
*/
