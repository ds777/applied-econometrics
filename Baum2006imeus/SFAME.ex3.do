* exercises for chapters SFAME 2-3

* (1) create Far West subset
use cigconsump, clear
keep if inlist(state,"WA","OR","CA","NV","UT","ID","AZ")
generate nstate="Washington" if state=="WA"
replace nstate="Oregon" if state=="OR"
replace nstate="California" if state=="CA"
replace nstate="Nevada" if state=="NV"
replace nstate="Utah" if state=="UT"
replace nstate="Idaho" if state=="ID"
replace nstate="Arizona" if state=="AZ"
drop state
rename nstate state
save cigconsumpW, replace

* (2) reshape to wide
levelsof stateid, local(st)
levelsof state, local(stnm)
keep stateid year packpc avgprs incpc
reshape wide packpc avgprs incpc, i(year) j(stateid)
local i 0
foreach s of local st {
	local i=`i'+1
	local snm: word `i' of `stnm'
	display as err _n  "`snm'" _n
	list packpc`s' avgprs`s' incpc`s', sep(0)
	local corr "`corr' packpc`s'"
}
corr `corr'

* (3) merge
use http://www.stata-press.com/data/r9/census5.dta, clear
sort state
save census5,replace
use cigconsumpW, clear
sort state
merge state using census5, uniqusing
tab _merge
drop if _merge ~=3
drop _merge

tsset stateid year
by year, sort: egen medage=median(median_age)
by year, sort: generate older = (median_age > medage)
tab older
tabstat packpc, by(older) stat(mean)
* ttest packpc, by(older)

* (4) moving average
tsset stateid year
mvsumm packpc, gen(mw4packpc) stat(mean) window(4) end
list year packpc mw4packpc if state=="California", sep(0)





