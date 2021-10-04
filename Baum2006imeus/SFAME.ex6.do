* exercises SFAME ch 6

use cigconsump, clear
keep if year==1985 |  year==1995
save cigconsump8595,replace

* (1) H due to group (in this case year)
regress lpackpc lavgprs lincpc 
est store one
hettest year 
predict double eps, residual
robvar eps, by(year)

* (2) Correct with FGLS
by year, sort: egen sd_eps = sd(eps)
gen double gw_wt = 1/sd_eps^2
regress lpackpc lavgprs lincpc [aw=gw_wt]
est store two
est table one two, b se t

* (3) time series
sysuse sp500.dta, clear
tsset date
reg D.close  D(2/3).close L.volume
estat bgodfrey, lags(10)

* (4) prais
prais D.close  D(2/3).close L.volume




