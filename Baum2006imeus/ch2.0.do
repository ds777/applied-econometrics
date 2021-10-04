* create extract for Chapter 2 revised

set scheme sj
set more off
use http://www.stata-press.com/data/r8/census2, clear
keep if region < 3  // =="N Cntrl" | region == "NE"
foreach v of varlist pop* marriage divorce {
replace `v' = `v'/1000
format `v' %8.1f
}
rename popurban popurb
rename marriage marr
rename divorce divr

* encode region, gen(reg)
* drop region
label var state "State"
label var pop "1980 Population, '000"
label var popurb "1980 Urban population, '000"
label var medage "Median age, years"
label var drate "Death rate per 10,000"
label var marr "Marriages, '000"
label var divr "Divorces, '000"
* label var reg "Census region"
label data "1980 Census data for NE and NC states"
compress
keep state region pop popurb medage marr divr 
list, sep(0)
save census2c,replace
outsheet using census2c, replace
sjlog using ch2.01, replace
use census2c, clear
list, sep(0)
sjlog close, replace

set more on
 
sjlog using ch2.02, replace
describe
sjlog close, replace

sjlog using ch2.03, replace
generate urbanized = popurb/pop
summarize urbanized
sjlog close, replace

sjlog using ch2.04, replace
replace urbanized = 100*urbanized
summarize urbanized
sjlog close, replace

sjlog using ch2.04a, replace
gsort region -pop
list region state pop, sepby(region)
sjlog close, replace
sjlog using ch2.05, replace
sort pop
list state region pop in 1/5
list state region pop in -5/l
sjlog close, replace

sjlog using ch2.06, replace
gsort -pop
list state region pop in 1/5
sjlog close, replace

set more off
sjlog using ch2.07, replace
generate medagel = medage if pop > 5000
sort state
list state region pop medagel, sep(0)
sjlog close, replace

sjlog using ch2.08, replace
summarize medagel 
summarize medage if pop > 5000
sjlog close, replace
sjlog using ch2.09, replace
generate smallpop = 0
replace smallpop = 1 if pop <= 5000
generate largepop = 0
replace largepop = 1 if pop > 5000
list state pop smallpop largepop, sep(0)
sjlog close, replace

set more on
drop smallpop largepop

sjlog using ch2.010, replace
generate smallpop = (pop <= 5000)
generate largepop = (pop > 5000)
sjlog close, replace

drop smallpop largepop
sjlog using ch2.011, replace
generate smallpop = (pop <= 5000) if pop < .
generate largepop = (pop > 5000) if pop < .
sjlog close, replace

* summarize medage marr divr if smallpop
* summarize medage marr divr if largepop
sjlog using ch2.012, replace
summarize medage marr divr if region==1
summarize medage marr divr if region==2
sjlog close, replace

sjlog using ch2.013, replace
by region, sort: summarize medage marr divr
sjlog close, replace

sjlog using ch2.014, replace
tabstat medage, by(region) statistics(N mean sd min max) 
sjlog close, replace

sjlog using ch2.015, replace
generate popsize = smallpop + 2*largepop
by region popsize, sort: summarize medage marr divr
sjlog close, replace

sjlog using ch2.016, replace
describe region
sjlog close, replace

set more on
sjlog using ch2.017, replace
label list cenreg
sjlog close, replace

sjlog using ch2.018, replace
label variable urbanized "Population in urban areas, %"
label variable smallpop "States with <= 5 million pop, 1980"
label variable largepop "States with > 5 million pop, 1980"
label variable popsize "Population size code"
describe pop smallpop largepop popsize urbanized
sjlog close, replace

sjlog using ch2.019a, replace
label define popsize 1 "<= 5 million" 2 "> 5 million"
label values popsize popsize
sjlog close, replace

sjlog using ch2.019b, replace
describe popsize
sjlog close, replace

sjlog using ch2.019c, replace
by popsize, sort: summarize medage
sjlog close, replace

sjlog using ch2.020, replace
label data "1980 US Census data with population size indicators"
sjlog close, replace

sjlog using ch2.021, replace
notes: Subset of Census data, prepared on TS for Chapter 2 
notes medagel: median age for large states only
notes popsize: variable separating states by population size
notes popsize: value label popsize defined for this variable
describe
notes
sjlog close, replace

* sjlog using ch2.022, replace
* generate netmarr = marr/divr
* summarize netmarr
* sjlog close, replace

sjlog using ch2.023, replace
generate netmarr2x = cond(marr/divr > 2, 1, 2)
label define netmarr2xc 1 "marr > 2 divr" 2 "marr <= 2 divr"
label values netmarr2x netmarr2xc
tabstat pop medage, by(netmarr2x)
sjlog close, replace

sjlog using ch2.024, replace
generate medagebrack = recode(medage,28,29,30,31,32,33)
tabulate medagebrack
sjlog close, replace

sjlog using ch2.025, replace
histogram medagebrack, discrete frequency ///
lcolor(black) fcolor(gs15) addlabels ///
addlabopts(mlabposition(6)) xtitle(Upper limits of median age) ///
title(Northeast and North Central States: Median Age) 
sjlog close, replace
graph export fig2_01.eps, replace

save census2d, replace

sjlog using ch2.026, replace
use census2d, clear
gsort region -pop
by region: generate totpop = sum(pop)
list region state pop totpop, sepby(region)
sjlog close, replace

sjlog using ch2.027, replace
by region: list region totpop if _n == _N
sjlog close, replace

sjlog using ch2.028, replace
by region: egen meanpop = mean(pop)
list region state pop meanpop, sepby(region)
sjlog close, replace

sjlog using ch2.029, replace
by region popsize, sort: egen meanpop2 = mean(pop)
list region popsize state pop meanpop2, sepby(region)
sjlog close, replace

use gdp4cty, clear
local country US UK DE FR
local cc 1
foreach c of local country {
	generate double `c'gdp = gdp`cc'
	local ++cc
	}
sjlog using ch2.030, replace
foreach c in US UK DE FR  {
	generate double lngdp`c' = log(`c'gdp)
	summarize lngdp`c' 
}
sjlog close, replace

sjlog using ch2.031, replace
use census2c, clear
summarize pop
return list
sjlog close, replace

sjlog using ch2.032, replace
mean pop popurb
ereturn list
matrix list e(b)
matrix list e(V)
sjlog close, replace
