set scheme sj

sjlog using ch2.13a, replace
use grunfeld, clear
tsset
summarize mvalue invest kstock
sjlog close, replace

sjlog using ch2.13, replace
preserve
collapse (mean) mvalue (sum) totinvYr=invest (mean) kstock, by(year)
graph twoway tsline mvalue totinvYr kstock
sjlog close, replace
graph export fig2_13.eps, replace
* summarize mvalue totinvYr kstock

sjlog using ch2.13b, replace
restore
preserve
collapse (mean) mvalue (sum) totinvCo=invest (mean) kstock, by(company)
summarize mvalue totinvCo kstock
sjlog close, replace
