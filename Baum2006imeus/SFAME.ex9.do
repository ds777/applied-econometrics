* exercises for SFAME ch. 9

use http://fmwww.bc.edu/ec-p/data/stockwatson/cig85_95, clear
encode state,gen(stateid)
tsset stateid year
gen incpc=income/pop
gen lpackpc = log(packpc)
gen lavgprs = log(avgprs)
gen lincpc = log(incpc)
save cigconsump,replace

* (1) estimate via fixed effects
xtreg packpc avgprs incpc,fe
est store fe

* (2) estimate via random effects
xtreg packpc avgprs incpc,re
est store re
hausman fe re

* (3) estimate in const-elasticity form
xtreg lpackpc lavgprs lincpc,fe

* (4) estimate with DPD
xtabond2 lpackpc L.lpackpc lavgprs lincpc, gmm(lpackpc) iv(year L.avgprs) ///
 twostep robust noleveleq

keep if inlist(state,"ME","NH","VT","MA","RI","CT")
keep lpackpc lavgprs lincpc year stateid
levelsof stateid, local(nest)
reshape wide lpackpc lavgprs lincpc, i(year) j(stateid)
save cigconsumpNE, replace
foreach s of local nest {
	local sulist "`sulist' (lpackpc`s' lavgprs`s' lincpc`s') " 
}
di "`sulist'"
sureg `sulist', corr


