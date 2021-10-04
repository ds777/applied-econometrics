* exercises SFAME ch 5

* (1) misspec, avplot
sysuse lifeexp, clear
desc
gen lgnppc = log(gnppc)
label var lgnppc "Log real GNP per capita"
keep if safewater < .
save lifeexpW,replace
regress lexp popgrowth  lgnppc
avplot safewater

* (2) RESET
regress lexp popgrowth  lgnppc safewater
estat ovtest

* (3) dfits
predict double dfits if e(sample), dfits
g adfits = abs(dfits)
gsort -adfits
list country region lexp adfits in 1/5

* (4) outliers
regress lexp popgrowth  lgnppc  safewater if country ~= "Haiti" 
estat ovtest




