sjlog using appB.1, replace
local country US UK DE FR
local ctycode 111 112 136 134
display "`country'"
display "`ctycode'"
sjlog close, replace

sjlog using appB.2, replace
local count 0
local country US UK DE FR
foreach c of local country {
   local count `count'+1
   display "Country `count' : `c'"
} 
sjlog close, replace

sjlog using appB.3, replace
local count 0
local country US UK DE FR
foreach c of local country {
   local count = `count'+1
   display "Country `count' : `c'"
} 
sjlog close, replace

sjlog using appB.4, replace
local count 0
local country US UK DE FR
foreach c of local country {
   local count = `count'+1
   local newlist "`newlist' `count' `c'"
} 
display "`newlist'"
sjlog close, replace

use gdp4cty, clear
sjlog using appB.5, replace
local country US UK DE FR
foreach c of local country {
	tsline gdp if cty=="`c'", title("GDP for `c'")
}
sjlog close, replace	

sjlog using appB.6, replace
local country US UK DE FR
foreach c of local country {
	tsline gdp if cty=="`c'", title("GDP for `c'") ///
	   nodraw name(`c',replace)
}
graph combine `country', ti("Gross Domestic Product, 1971Q1-1995Q4")
sjlog close, replace
	
sjlog using appB.7, replace
local country US UK DE FR
local wds: word count `country'
display "There are `wds' countries:"
forvalues i = 1/`wds' {
	local wd: word `i' of `country'
	display "Country `i' is `wd'"
}
sjlog close, replace

use gdp4cty, clear
sjlog using appB.8, replace
scalar root2 = sqrt(2.0)
generate double rootGDP = gdp*root2
sjlog close, replace

use gdp4cty, clear
sjlog using appB.9, replace
forvalues i = 1/4 {
	generate double lngdp`i' = log(gdp`i')
	summarize lngdp`i' 
}
sjlog close, replace

use gdp4cty, clear
local country US UK DE FR
local cc 1
foreach c of local country {
	generate double `c'gdp = gdp`cc'
	local ++cc
	}

sjlog using appB.9a, replace
local country US UK DE FR
foreach c of local country {
	generate double lngdp`c' = log(`c'gdp)
	summarize lngdp`c' 
	}
sjlog close, replace

drop gdp
sjlog using appB.9b, replace
generate double gdptot = 0
foreach c of varlist *gdp {
	quietly replace gdptot = gdptot + `c'
}
summarize *gdp gdptot
sjlog close, replace

use gdp4cty, clear
sjlog using appB.10, replace
forvalues y = 1995(2)1999 {
	forvalues i = 1/4 {
		summarize gdp`i'_`y' 
	}
}
sjlog close, replace

sysuse lifeexp, clear
sjlog using appB.11, replace
foreach v of varlist lexp-safewater {
	summarize `v'
	correlate popgrowth `v' 
	scatter popgrowth `v'
}
sjlog close, replace

use gdp4cty, clear
sjlog using appB.12, replace
local ctycode 111 112 136 134
local i 0
foreach c of local ctycode {
	local ++i
	local rc "`rc' (`i'=`c')"
}
display "`rc'"
recode cc `rc', gen(newcc)
tabulate newcc
sjlog close, replace

use gdp4cty, clear
sjlog using appB.13, replace
local country US UK DE FR
local yrlist 1995 1999
forvalues i = 1/4 {  
	local cname: word `i' of `country'
	foreach y of local yrlist {
		rename gdp`i'_`y' gdp`cname'_`y'
	}
}
summ gdpUS*
sjlog close, replace

sjlog using appB.14, replace
use abdata, clear
describe
return list
local sb: sortedby
display "dataset sorted by : `sb'"
sjlog close, replace

sjlog using appB.15, replace
summarize emp, detail
return list
scalar iqr = r(p75) - r(p25)
display "IQR = " iqr
scalar semean = r(sd)/sqrt(r(N))
display "Mean = " r(mean) " S.E. = " semean
sjlog close, replace

sjlog using appB.16, replace
use abdata, clear
tsset
return list
sjlog close, replace

sjlog using appB.17, replace
generate lowind = (ind<6)
ttest emp, by(lowind)
return list
sjlog close, replace

sjlog using appB.18, replace
regress emp wage cap
ereturn list
local regressors: colnames e(b)
display "Regressors: `regressors'"
sjlog close, replace
