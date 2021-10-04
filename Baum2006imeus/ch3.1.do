sjlog using ch3.1,replace
use hprice2a, clear
summarize price lprice lnox ldist stratio, sep(0)
sjlog close, replace

sjlog using ch3.1a,replace
regress lprice lnox ldist rooms stratio
sjlog close, replace

sjlog using ch3.1aa, replace
estat ic
sjlog close, replace

sjlog using ch3.3,replace
regress, beta
sjlog close, replace

*use hprice2a, clear
*regress lprice lnox ldist rooms stratio
sjlog using ch3.4,replace
ereturn list
sjlog close, replace

sjlog using ch3.4aa, replace
estat summarize
sjlog close, replace

sjlog using ch3.4a,replace
matrix list e(b)
sjlog close, replace

sjlog using ch3.4b, replace
estat vce
sjlog close, replace

* DO NOT use specification accepted by RESET -- not introduced yet
sjlog using ch3.11c, replace
regress lprice lnox ldist rooms stratio
estat vif
sjlog close, replace

