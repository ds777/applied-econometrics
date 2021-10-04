use http://www.stata-press.com/data/r9/census2.dta, clear
outfile state region pop medage drate using temp,replace
infile str14 state str7 region pop medage drate using temp, clear
label data "Extracted from http://www.stata-press.com/data/r9/census2.dta"
save census2a,replace
sjlog using ch2.1, replace
use census2a
describe region
tabulate region
sjlog close,replace

sjlog using ch2.2,replace
encode region, generate(cenreg)
describe cenreg
summarize cenreg
sjlog close,replace

*save census2a,replace
